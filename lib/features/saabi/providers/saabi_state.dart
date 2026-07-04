import 'package:saabi_mobile/features/saabi/providers/models/chat_message.dart';

/// State for the Saabi AI chat tab.
class SaabiState {
  final List<ChatMessage> messages;
  final bool isProcessing;

  const SaabiState({
    this.messages = const [],
    this.isProcessing = false,
  });

  SaabiState copyWith({
    List<ChatMessage>? messages,
    bool? isProcessing,
  }) {
    return SaabiState(
      messages: messages ?? this.messages,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }
}
