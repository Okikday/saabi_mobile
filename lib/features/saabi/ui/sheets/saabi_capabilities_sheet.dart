import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:hugeicons_pro/hugeicons.dart';

class SaabiCapabilitiesSheet extends StatelessWidget {
  const SaabiCapabilitiesSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SaabiCapabilitiesSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: context.theme.colors.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: context.theme.colors.muted, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'What can Saabi do?',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: context.theme.colors.foreground, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Try asking Saabi to help you with your daily financial tasks.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: context.theme.colors.mutedForeground),
            ),
            const SizedBox(height: 24),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildCapabilityItem(
                      context,
                      icon: HugeIconsStroke.bank,
                      title: 'Transfers',
                      description: 'Transfer money to any bank account or phone number.',
                      example: '"Send 5k to Okikiola"',
                    ),
                    const SizedBox(height: 16),
                    _buildCapabilityItem(
                      context,
                      icon: HugeIconsStroke.aiPhone01,
                      title: 'Airtime & Data',
                      description: 'Top up your phone or buy data bundles instantly.',
                      example: '"Buy 1000 airtime for my number"',
                    ),
                    const SizedBox(height: 16),
                    _buildCapabilityItem(
                      context,
                      icon: HugeIconsStroke.calendar01,
                      title: 'Transaction History',
                      description: 'Quickly check your past transactions by date.',
                      example: '"Show me my transactions for yesterday"',
                    ),
                    const SizedBox(height: 16),
                    _buildCapabilityItem(
                      context,
                      icon: HugeIconsStroke.invoice01,
                      title: 'Pay Bills',
                      description: 'Pay electricity, cable TV, and other utility bills.',
                      example: '"I want to pay for electricity"',
                    ),
                    const SizedBox(height: 16),
                    _buildCapabilityItem(
                      context,
                      icon: HugeIconsStroke.userGroup,
                      title: 'Savings Circles',
                      description: 'Start or manage your Ajo/Esusu groups.',
                      example: '"Create a new savings circle"',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FButton(onPress: () => Navigator.of(context).pop(), child: const Text('Got it')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCapabilityItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required String example,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: context.theme.colors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
          child: Icon(icon, color: context.theme.colors.primary, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: context.theme.colors.foreground, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: context.theme.colors.mutedForeground),
              ),
              const SizedBox(height: 4),
              Text(
                example,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.theme.colors.primary,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
