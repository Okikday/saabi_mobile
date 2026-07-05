import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:saabi_mobile/core/storage/hive/hive_keys.dart';
import 'package:saabi_mobile/features/saabi/providers/saabi_pod.dart';
import 'package:intl/intl.dart';

class SaabiHistoryView extends ConsumerStatefulWidget {
  const SaabiHistoryView({super.key});

  @override
  ConsumerState<SaabiHistoryView> createState() => _SaabiHistoryViewState();
}

class _SaabiHistoryViewState extends ConsumerState<SaabiHistoryView> {
  late bool _saveHistory;

  @override
  void initState() {
    super.initState();
    _saveHistory = HiveKeys.saabiSaveHistory.get() ?? true;
  }

  void _toggleHistory(bool value) {
    setState(() => _saveHistory = value);
    HiveKeys.saabiSaveHistory.set(value);
    if (!value) {
      ref.read(saabiProvider.notifier).clearHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(saabiProvider);
    final sessions = state.pastSessions;
    final df = DateFormat('MMM d, yyyy • h:mm a');

    return FScaffold(
      header: FHeader.nested(
        title: const Text('Chat History'),
        prefixes: [FHeaderAction.back(onPress: () => Navigator.of(context).pop())],
        suffixes: [
          if (_saveHistory)
            FHeaderAction(
              icon: const Icon(Icons.delete_forever_rounded),
              onPress: () {
                ref.read(saabiProvider.notifier).clearHistory();
              },
            ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: context.theme.colors.border)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Save Chat History',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: context.theme.colors.foreground, fontWeight: FontWeight.w500),
                ),
                FSwitch(value: _saveHistory, onChange: _toggleHistory),
              ],
            ),
          ),
          Expanded(
            child: sessions.isEmpty
                ? Center(
                    child: Text(
                      'No past chats found.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: context.theme.colors.mutedForeground),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: sessions.length,
                    itemBuilder: (context, index) {
                      final session = sessions[index];
                      return FTile(
                        onPress: () {
                          ref.read(saabiProvider.notifier).loadSession(session.id);
                          Navigator.of(context).pop();
                        },
                        prefix: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: context.theme.colors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.chat_bubble_outline_rounded, color: context.theme.colors.primary, size: 20),
                        ),
                        title: Text(
                          session.title,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: context.theme.colors.foreground,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          df.format(session.updatedAt),
                          style: Theme.of(
                            context,
                          ).textTheme.labelSmall?.copyWith(color: context.theme.colors.mutedForeground),
                        ),
                        suffix: Icon(Icons.chevron_right_rounded, color: context.theme.colors.mutedForeground),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
