import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:saabi_mobile/features/settings/providers/security_pod.dart';
import 'package:saabi_mobile/shared/routes/app_router.dart';

class SecuritySettingsView extends ConsumerWidget {
  const SecuritySettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final securityState = ref.watch(securityProvider);

    return FScaffold(
      header: FHeader.nested(
        title: const Text('Security & PIN'),
        prefixes: [FHeaderAction.back(onPress: () => context.pop())],
      ),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildTile(
            context,
            icon: Icons.dialpad,
            title: securityState.isPinEnabled ? 'Change PIN' : 'Setup PIN',
            subtitle: 'Use a 4-digit PIN for transactions',
            onTap: () {
              Routes.pinSetup.push(context);
            },
            trailing: Icon(Icons.chevron_right_rounded, color: context.theme.colors.mutedForeground),
          ),
          if (securityState.isPinEnabled && securityState.isBiometricsSupported) ...[
            const SizedBox(height: 12),
            _buildTile(
              context,
              icon: Icons.fingerprint,
              title: 'Biometric Authentication',
              subtitle: 'Use Face ID / Touch ID instead of PIN',
              trailing: FSwitch(
                value: securityState.isBiometricsEnabled,
                onChange: (val) {
                  ref.read(securityProvider.notifier).setBiometricsEnabled(val);
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: context.theme.colors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.theme.colors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.theme.colors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: context.theme.colors.primary, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: context.theme.colors.foreground,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: context.theme.colors.mutedForeground,
                          ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 12),
              trailing,
            ],
          ],
        ),
      ),
    );
  }
}
