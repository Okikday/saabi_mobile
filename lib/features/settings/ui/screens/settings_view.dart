import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:saabi_mobile/shared/theme/logic/theme_pod.dart';
import 'package:saabi_mobile/shared/theme/src/app_colors.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeModeProvider).value ?? true;

    return FScaffold(
      header: FHeader.nested(
        title: const Text('Settings'),
        prefixes: [
          FHeaderAction.back(onPress: () => context.pop()),
        ],
      ),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionHeader(context, 'Preferences'),
          _buildTile(
            context,
            icon: Icons.dark_mode_rounded,
            title: 'Dark Mode',
            trailing: FSwitch(
              value: isDark,
              onChange: (value) => ref.read(themeModeProvider.notifier).set(value),
            ),
          ),
          const SizedBox(height: 12),
          _buildTile(
            context,
            icon: Icons.notifications_rounded,
            title: 'Notifications',
            trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.neutralBlack400),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Account'),
          _buildTile(
            context,
            icon: Icons.person_rounded,
            title: 'Profile Information',
            trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.neutralBlack400),
          ),
          const SizedBox(height: 12),
          _buildTile(
            context,
            icon: Icons.security_rounded,
            title: 'Security & PIN',
            trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.neutralBlack400),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Support'),
          _buildTile(
            context,
            icon: Icons.help_outline_rounded,
            title: 'Help Center',
            trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.neutralBlack400),
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
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget trailing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neutralBlack100),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.neutralBlack400, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
