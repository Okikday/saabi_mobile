import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saabi_mobile/core/storage/isar/isar_data.dart';
import 'package:saabi_mobile/features/saabi/providers/models/chat_message.dart';
import 'package:saabi_mobile/features/saabi/providers/models/chat_message_model.dart';
import 'package:saabi_mobile/features/saabi/providers/saabi_state.dart';
import 'package:saabi_mobile/core/nlp/nlp.dart';
import 'package:saabi_mobile/features/saabi/logic/saabi_intent.dart';
import 'package:saabi_mobile/features/saabi/ui/widgets/action_cards/action_cards.dart';

final saabiProvider = NotifierProvider<SaabiPod, SaabiState>(SaabiPod.new, name: 'SaabiPod');

class SaabiPod extends Notifier<SaabiState> {
  static final me = saabiProvider;

  final _nlp = SaabiNlp();
  final _isarData = IsarData.instance<ChatMessageModel>();

  @override
  SaabiState build() {
    _init();
    return const SaabiState();
  }

  Future<void> _init() async {
    // 1. Initialize NLP (downloads model if needed)
    await _nlp.init();

    // 2. Load persisted messages
    final persisted = await _isarData.getAll();
    final messages = persisted.map(_modelToDomain).toList();

    // Sort by timestamp just in case
    messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    state = state.copyWith(messages: messages);
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
  }

  /// Helper to convert Domain message -> Isar model and save it
  Future<void> _persistMessage(ChatMessage msg) async {
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
      // Store intent data via a simple serialization
      model.intentData = _serializeIntent(msg.intent);
    }

    await _isarData.store(model);
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
    } else if (intent is UnknownIntent) {
      return UnknownActionCard(intent: intent);
    }

    // Fallback for intents without custom cards yet
    return Text('I can help with that soon! (${intent.runtimeType})');
  }
}
