import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:saabi_mobile/shared/theme/logic/theme_pod.dart';
import 'package:saabi_mobile/features/saabi/providers/live_assist_pod.dart' as saabi_live;

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeModeProvider).value ?? true;

    return FScaffold(
      header: FHeader.nested(
        title: const Text('Settings'),
        prefixes: [FHeaderAction.back(onPress: () => context.pop())],
      ),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionHeader(context, 'Preferences'),
          _buildTile(
            context,
            icon: HugeIconsSolid.moon02,
            title: 'Dark Mode',
            trailing: FSwitch(value: isDark, onChange: (value) => ref.read(themeModeProvider.notifier).set(value)),
          ),
          const SizedBox(height: 12),
          _buildTile(
            context,
            icon: HugeIconsSolid.notification01,
            title: 'Notifications',
            trailing: Icon(Icons.chevron_right_rounded, color: context.theme.colors.mutedForeground),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Account'),
          _buildTile(
            context,
            icon: HugeIconsSolid.user03,
            title: 'Profile Information',
            trailing: Icon(Icons.chevron_right_rounded, color: context.theme.colors.mutedForeground),
          ),
          const SizedBox(height: 12),
          _buildTile(
            context,
            icon: HugeIconsSolid.shieldKey,
            title: 'Security & PIN',
            trailing: Icon(Icons.chevron_right_rounded, color: context.theme.colors.mutedForeground),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Support'),
          _buildTile(
            context,
            icon: HugeIconsStroke.chatQuestion01,
            title: 'Help Center',
            trailing: Icon(Icons.chevron_right_rounded, color: context.theme.colors.mutedForeground),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Experimental Features'),
          Consumer(
            builder: (context, ref, _) {
              final liveState = ref.watch(saabi_live.liveAssistProvider);
              return Column(
                children: [
                  _buildTile(
                    context,
                    icon: HugeIconsSolid.mic01,
                    title: 'Saabi Live Assist',
                    trailing: FSwitch(
                      value: liveState.isEnabled,
                      onChange: (value) => ref.read(saabi_live.liveAssistProvider.notifier).toggleEnabled(value),
                    ),
                  ),
                  if (liveState.isEnabled) ...[
                    const SizedBox(height: 12),
                    _buildTile(
                      context,
                      icon: HugeIconsStroke.wifiDisconnected01,
                      title: 'Offline Processing Only',
                      trailing: FSwitch(
                        value: liveState.isOfflineOnly,
                        onChange: (value) => ref.read(saabi_live.liveAssistProvider.notifier).toggleOfflineOnly(value),
                      ),
                    ),
                  ]
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(color: context.theme.colors.primary, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildTile(BuildContext context, {required IconData icon, required String title, required Widget trailing}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.theme.colors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.theme.colors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: context.theme.colors.mutedForeground, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: context.theme.colors.foreground),
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
