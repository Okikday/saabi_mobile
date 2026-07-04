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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 48, bottom: 4),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: message.isError ? context.theme.colors.destructive.withValues(alpha: 0.1) : context.theme.colors.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(6),
              ),
              border: message.isError ? Border.all(color: context.theme.colors.destructive.withValues(alpha: 0.5)) : null,
            ),
            child: Text(
              message.text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: message.isError ? context.theme.colors.destructive : context.theme.colors.primaryForeground,
                  ),
            ),
          ),
          if (message.isError)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline_rounded, size: 14, color: context.theme.colors.destructive),
                  const SizedBox(width: 4),
                  Text('Failed to process', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: context.theme.colors.destructive)),
                ],
              ),
            )
          else
            const SizedBox(height: 12),
        ],
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
        padding: isAction ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: isAction ? Colors.transparent : context.theme.colors.card,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
            bottomLeft: Radius.circular(6),
            bottomRight: Radius.circular(24),
          ),
          border: isAction ? null : Border.all(color: context.theme.colors.border),
        ),
        child: child,
      ),
    );
  }
}
