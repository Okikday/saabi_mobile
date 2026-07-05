import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:saabi_mobile/core/storage/isar/isar_data.dart';
import 'package:saabi_mobile/features/saabi/providers/models/chat_message.dart';
import 'package:saabi_mobile/features/saabi/providers/models/chat_message_model.dart';
import 'package:saabi_mobile/features/saabi/providers/saabi_state.dart';
import 'package:saabi_mobile/core/nlp/nlp.dart';
import 'package:saabi_mobile/features/saabi/logic/saabi_intent.dart';
import 'package:saabi_mobile/features/saabi/ui/widgets/action_cards/action_cards.dart';
import 'package:saabi_mobile/core/storage/hive/hive_keys.dart';
import 'package:saabi_mobile/features/saabi/providers/models/chat_session_model.dart';
import 'package:saabi_mobile/features/saabi/providers/models/chat_session.dart';
import 'package:hugeicons_pro/hugeicons.dart';

final saabiProvider = NotifierProvider<SaabiPod, SaabiState>(SaabiPod.new, name: 'SaabiPod');

class SaabiPod extends Notifier<SaabiState> {
  static final me = saabiProvider;

  final _nlp = SaabiNlp();
  final _isarData = IsarData.instance<ChatMessageModel>();
  final _sessionIsarData = IsarData.instance<ChatSessionModel>();

  @override
  SaabiState build() {
    _init();
    return const SaabiState();
  }

  Future<void> _init() async {
    // 1. Initialize NLP (downloads model if needed)
    await _nlp.init();

    // 2. Load persisted sessions
    await loadSessions();
  }

  Future<void> loadSessions() async {
    final persistedSessions = await _sessionIsarData.getAll();
    persistedSessions.sort((a, b) => b.updatedAt.compareTo(a.updatedAt)); // Newest first

    final domainSessions = persistedSessions
        .map((s) => ChatSession(id: s.sessionId, title: s.title, createdAt: s.createdAt, updatedAt: s.updatedAt))
        .toList();

    state = state.copyWith(pastSessions: domainSessions);

    // If there is a very recent session (e.g. today), we could load it.
    // For now, we will start fresh until the user picks a session or types.
  }

  Future<void> loadSession(String sessionId) async {
    final isar = await IsarData.isarFuture;
    final sessionModel = await isar.collection<ChatSessionModel>().where().sessionIdEqualTo(sessionId).findFirst();

    if (sessionModel != null) {
      await sessionModel.messages.load();
      final messages = sessionModel.messages.map(_modelToDomain).toList();
      messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      state = state.copyWith(currentSessionId: sessionId, messages: messages);
    }
  }

  void startNewSession() {
    state = state.copyWith(currentSessionId: null, messages: []);
  }

  /// Called when the user submits a message in the chat input.
  Future<void> submitMessage(String text, {bool useBackend = false}) async {
    if (text.trim().isEmpty) return;

    // 1. Add user message
    final userMsg = UserMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      text: text,
    );

    // Persist and update state
    await _persistMessage(userMsg);
    state = state.copyWith(messages: [...state.messages, userMsg], isProcessing: true);

    // 2. Process message
    try {
      if (useBackend) {
        // Simulate backend delay for now
        await Future.delayed(const Duration(seconds: 1));

        // Fallback stub for online processing
        final assistantMsg = AssistantTextMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          timestamp: DateTime.now(),
          text: 'This was routed to the backend. (Backend API not connected yet!)',
        );
        await _persistMessage(assistantMsg);
        state = state.copyWith(messages: [...state.messages, assistantMsg], isProcessing: false);
      } else {
        // Local NLP Processing
        final intent = await _nlp.parse(text);

        final assistantMsg = AssistantActionMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          timestamp: DateTime.now(),
          intent: intent,
          contentBuilder: _buildActionContent,
        );

        await _persistMessage(assistantMsg);
        state = state.copyWith(messages: [...state.messages, assistantMsg], isProcessing: false);
      }
    } catch (e, st) {
      debugPrint('Error processing message: $e\n$st');
      // Mark the user message as failed
      final failedUserMsg = userMsg.copyWith(isError: true);

      // We don't persist isError to Isar right now, so it will clear on reload,
      // which is fine for ephemeral failures.

      state = state.copyWith(
        messages: state.messages.map((m) => m.id == failedUserMsg.id ? failedUserMsg : m).toList(),
        isProcessing: false,
      );
    }
  }

  /// Helper to convert Domain message -> Isar model and save it
  Future<void> _persistMessage(ChatMessage msg) async {
    if (!(HiveKeys.saabiSaveHistory.get() ?? true)) return;

    final isar = await IsarData.isarFuture;

    // Ensure we have a session
    String? sId = state.currentSessionId;
    ChatSessionModel? sessionModel;

    if (sId == null) {
      sId = DateTime.now().millisecondsSinceEpoch.toString();
      sessionModel = ChatSessionModel()
        ..sessionId = sId
        ..title = msg is UserMessage ? msg.text : 'New Chat'
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now();

      // We must notify state immediately so further messages in this burst use the same ID
      // But we will actually dispatch state update in the main submit function usually,
      // here we just update the session locally if needed.
    } else {
      sessionModel = await isar.collection<ChatSessionModel>().where().sessionIdEqualTo(sId).findFirst();
      if (sessionModel != null) {
        sessionModel.updatedAt = DateTime.now();
      }
    }

    if (sessionModel == null) return;

    final model = ChatMessageModel()
      ..messageId = msg.id
      ..timestamp = msg.timestamp;

    if (msg is UserMessage) {
      model.type = ChatMessageType.user;
      model.text = msg.text;
    } else if (msg is AssistantTextMessage) {
      model.type = ChatMessageType.assistantText;
      model.text = msg.text;
    } else if (msg is AssistantActionMessage) {
      model.type = ChatMessageType.assistantAction;
      model.intentType = msg.intent.runtimeType.toString();
      model.intentData = _serializeIntent(msg.intent);
    }

    await isar.writeTxn(() async {
      await isar.collection<ChatSessionModel>().put(sessionModel!);
      await isar.collection<ChatMessageModel>().put(model);

      model.session.value = sessionModel;
      await model.session.save();
    });

    if (state.currentSessionId != sId) {
      // Refresh sessions list
      await loadSessions();
      state = state.copyWith(currentSessionId: sId);
    }
  }

  /// Helper to convert Isar model -> Domain message
  ChatMessage _modelToDomain(ChatMessageModel model) {
    switch (model.type) {
      case ChatMessageType.user:
        return UserMessage(id: model.messageId, timestamp: model.timestamp, text: model.text ?? '');
      case ChatMessageType.assistantText:
        return AssistantTextMessage(id: model.messageId, timestamp: model.timestamp, text: model.text ?? '');
      case ChatMessageType.assistantAction:
        final intent = _deserializeIntent(model.intentType, model.intentData);
        return AssistantActionMessage(
          id: model.messageId,
          timestamp: model.timestamp,
          intent: intent,
          contentBuilder: _buildActionContent,
        );
    }
  }

  /// Clears the chat history from state and Isar.
  Future<void> clearHistory() async {
    // Clear from Isar
    final isar = await IsarData.isarFuture;
    await isar.writeTxn(() async {
      await isar.collection<ChatMessageModel>().clear();
      await isar.collection<ChatSessionModel>().clear();
    });

    // Clear from state
    state = state.copyWith(messages: [], pastSessions: [], currentSessionId: null);
  }

  // ──────────────────────────────────────────────────────────────
  // Intent Serialization (for Isar persistence)
  // ──────────────────────────────────────────────────────────────

  String _serializeIntent(SaabiIntent intent) {
    if (intent is TransferIntent) {
      return jsonEncode({'amount': intent.amount, 'accountNumber': intent.accountNumber, 'bankCode': intent.bankCode});
    } else if (intent is SendIntent) {
      return jsonEncode({'amount': intent.amount, 'recipient': intent.recipient});
    } else if (intent is TransactionHistoryIntent) {
      return jsonEncode({'date': intent.date?.millisecondsSinceEpoch});
    } else if (intent is AirtimeIntent) {
      return jsonEncode({'amount': intent.amount, 'phoneNumber': intent.phoneNumber});
    } else if (intent is UnknownIntent) {
      return jsonEncode({'text': intent.originalText});
    }
    // Intents without params (CreditScore, CheckBalance, CreateRound)
    return '{}';
  }

  SaabiIntent _deserializeIntent(String? type, String? data) {
    if (data == null || data.isEmpty) return const UnknownIntent('');

    try {
      final map = jsonDecode(data) as Map<String, dynamic>;

      switch (type) {
        case 'TransferIntent':
          return TransferIntent(
            amount: map['amount'] as double?,
            accountNumber: map['accountNumber'] as String?,
            bankCode: map['bankCode'] as String?,
          );
        case 'SendIntent':
          return SendIntent(amount: map['amount'] as double?, recipient: map['recipient'] as String?);
        case 'TransactionHistoryIntent':
          return TransactionHistoryIntent(
            date: map['date'] != null ? DateTime.fromMillisecondsSinceEpoch(map['date'] as int) : null,
          );
        case 'AirtimeIntent':
          return AirtimeIntent(amount: map['amount'] as double?, phoneNumber: map['phoneNumber'] as String?);
        case 'CreditScoreIntent':
          return const CreditScoreIntent();
        case 'CheckBalanceIntent':
          return const CheckBalanceIntent();
        case 'CreateRoundIntent':
          return const CreateRoundIntent();
        case 'UnknownIntent':
        default:
          return UnknownIntent(map['text'] as String? ?? '');
      }
    } catch (_) {
      return const UnknownIntent('Failed to parse past intent');
    }
  }

  // ──────────────────────────────────────────────────────────────
  // UI Builders
  // ──────────────────────────────────────────────────────────────

  /// Central registry for mapping an intent to its UI action card
  Widget _buildActionContent(BuildContext context, SaabiIntent intent) {
    if (intent is TransferIntent) {
      return TransferActionCard(intent: intent);
    } else if (intent is SendIntent) {
      return SendActionCard(intent: intent);
    } else if (intent is CheckBalanceIntent) {
      return const BalanceActionCard();
    } else if (intent is TransactionHistoryIntent) {
      return GenericActionCard(
        intent: intent,
        title: 'Transaction History',
        buttonText: 'View Transactions',
        icon: HugeIconsStroke.calendar01,
      );
    } else if (intent is AirtimeIntent) {
      return GenericActionCard(intent: intent, title: 'Buy Airtime', buttonText: 'Continue', icon: Icons.smartphone);
    } else if (intent is DataIntent) {
      return GenericActionCard(intent: intent, title: 'Buy Data', buttonText: 'Continue', icon: HugeIconsStroke.wifi01);
    } else if (intent is BillsIntent) {
      return GenericActionCard(
        intent: intent,
        title: 'Pay Bills',
        buttonText: 'View Bills',
        icon: HugeIconsStroke.invoice01,
      );
    } else if (intent is InvestmentIntent) {
      return GenericActionCard(
        intent: intent,
        title: 'Investments',
        buttonText: 'View Investments',
        icon: HugeIconsStroke.chartHistogram,
      );
    } else if (intent is LoanIntent) {
      return GenericActionCard(
        intent: intent,
        title: 'Request Loan',
        buttonText: 'View Loans',
        icon: HugeIconsStroke.bank,
      );
    } else if (intent is CreditScoreIntent) {
      return GenericActionCard(
        intent: intent,
        title: 'Credit Score',
        buttonText: 'View Credit Score',
        icon: Icons.speed,
      );
    } else if (intent is CreateRoundIntent) {
      return GenericActionCard(
        intent: intent,
        title: 'Savings Circle',
        buttonText: 'Create Circle',
        icon: HugeIconsStroke.userGroup,
      );
    } else if (intent is UnknownIntent) {
      return UnknownActionCard(intent: intent);
    }

    // Fallback for intents without custom cards yet
    return Text('I can help with that soon! (${intent.runtimeType})');
  }
}
