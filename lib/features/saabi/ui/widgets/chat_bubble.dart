import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:saabi_mobile/features/saabi/providers/models/chat_message.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    if (message is UserMessage) {
      return _UserBubble(message: message as UserMessage);
    } else if (message is AssistantTextMessage) {
      return _AssistantBubble(
        timestamp: message.timestamp,
        child: Text(
          (message as AssistantTextMessage).text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.theme.colors.foreground,
              ),
        ),
      );
    } else if (message is AssistantActionMessage) {
      final actionMsg = message as AssistantActionMessage;
      return _AssistantBubble(
        timestamp: message.timestamp,
        isAction: true,
        child: actionMsg.contentBuilder(context, actionMsg.intent),
      );
    }
    return const SizedBox.shrink();
  }
}

class _UserBubble extends StatelessWidget {
  final UserMessage message;

  const _UserBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(left: 48, bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: context.theme.colors.primary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(4),
          ),
        ),
        child: Text(
          message.text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.theme.colors.primaryForeground,
              ),
        ),
      ),
    );
  }
}

class _AssistantBubble extends StatelessWidget {
  final Widget child;
  final DateTime timestamp;
  final bool isAction;

  const _AssistantBubble({
    required this.child,
    required this.timestamp,
    this.isAction = false,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(right: 48, bottom: 16),
        padding: isAction ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: isAction
            ? null
            : BoxDecoration(
                color: context.theme.colors.card,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(16),
                ),
                border: Border.all(color: context.theme.colors.border),
              ),
        child: child,
      ),
    );
  }
}
