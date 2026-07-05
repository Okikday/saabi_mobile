import 'package:saabi_mobile/features/saabi/providers/models/chat_message.dart';
import 'package:saabi_mobile/features/saabi/providers/models/chat_session.dart';

/// State for the Saabi AI chat tab.
class SaabiState {
  final String? currentSessionId;
  final List<ChatMessage> messages;
  final List<ChatSession> pastSessions;
  final bool isProcessing;

  const SaabiState({
    this.currentSessionId,
    this.messages = const [],
    this.pastSessions = const [],
    this.isProcessing = false,
  });

  SaabiState copyWith({
    String? currentSessionId,
    List<ChatMessage>? messages,
    List<ChatSession>? pastSessions,
    bool? isProcessing,
  }) {
    return SaabiState(
      currentSessionId: currentSessionId ?? this.currentSessionId,
      messages: messages ?? this.messages,
      pastSessions: pastSessions ?? this.pastSessions,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }
}
