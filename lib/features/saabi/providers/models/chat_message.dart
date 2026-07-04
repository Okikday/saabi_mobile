import 'package:flutter/widgets.dart';
import 'package:saabi_mobile/features/saabi/logic/saabi_intent.dart';

/// Base class for all chat messages in the Saabi AI interface.
sealed class ChatMessage {
  final String id;
  final DateTime timestamp;

  const ChatMessage({required this.id, required this.timestamp});
}

/// A standard text message sent by the user.
class UserMessage extends ChatMessage {
  final String text;
  final bool isError;

  const UserMessage({
    required super.id,
    required super.timestamp,
    required this.text,
    this.isError = false,
  });

  UserMessage copyWith({bool? isError}) {
    return UserMessage(
      id: id,
      timestamp: timestamp,
      text: text,
      isError: isError ?? this.isError,
    );
  }
}

/// A simple text response from the Saabi AI assistant.
class AssistantTextMessage extends ChatMessage {
  final String text;

  const AssistantTextMessage({required super.id, required super.timestamp, required this.text});
}

/// An interactive action card returned by the Saabi AI assistant,
/// generated from a [SaabiIntent].
class AssistantActionMessage extends ChatMessage {
  final SaabiIntent intent;

  /// A builder function that returns the UI for this specific intent.
  final Widget Function(BuildContext context, SaabiIntent intent) contentBuilder;

  const AssistantActionMessage({
    required super.id,
    required super.timestamp,
    required this.intent,
    required this.contentBuilder,
  });
}
