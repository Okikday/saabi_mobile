import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:saabi_mobile/features/saabi/logic/saabi_intent.dart';
import 'package:saabi_mobile/features/saabi/logic/saabi_intent_handler.dart';
import 'package:intl/intl.dart';

/// Renders a transfer confirmation card.
class TransferActionCard extends StatelessWidget {
  final TransferIntent intent;

  const TransferActionCard({super.key, required this.intent});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'en_NG', symbol: '₦');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.theme.colors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.theme.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(HugeIconsStroke.bank, color: context.theme.colors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Transfer Details',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: context.theme.colors.foreground, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (intent.amount != null) ...[
            Text(
              'Amount',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: context.theme.colors.mutedForeground),
            ),
            Text(
              currency.format(intent.amount),
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: context.theme.colors.foreground, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
          ],
          if (intent.accountNumber != null) ...[
            Text(
              'To (Account Number)',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: context.theme.colors.mutedForeground),
            ),
            Text(
              intent.accountNumber!,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: context.theme.colors.foreground, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
          ],
          SizedBox(
            width: double.infinity,
            child: FButton(
              onPress: () => SaabiIntentHandler.execute(context, intent),
              child: const Text('Review Transfer'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Renders a send money card.
class SendActionCard extends StatelessWidget {
  final SendIntent intent;

  const SendActionCard({super.key, required this.intent});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'en_NG', symbol: '₦');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.theme.colors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.theme.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(FLucideIcons.send, color: context.theme.colors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Send Money',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: context.theme.colors.foreground, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (intent.amount != null) ...[
            Text(
              'Amount',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: context.theme.colors.mutedForeground),
            ),
            Text(
              currency.format(intent.amount),
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: context.theme.colors.foreground, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
          ],
          if (intent.recipient != null) ...[
            Text(
              'To (Phone/Tag)',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: context.theme.colors.mutedForeground),
            ),
            Text(
              intent.recipient!,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: context.theme.colors.foreground, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
          ],
          SizedBox(
            width: double.infinity,
            child: FButton(
              onPress: () => SaabiIntentHandler.execute(context, intent),
              child: const Text('Review Details'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Renders a balance summary card.
class BalanceActionCard extends StatelessWidget {
  const BalanceActionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.theme.colors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.theme.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Balance',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: context.theme.colors.mutedForeground),
          ),
          const SizedBox(height: 4),
          Text(
            '₦45,250.00',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: context.theme.colors.foreground, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

/// Renders an unknown intent card with suggestions.
class UnknownActionCard extends StatelessWidget {
  final UnknownIntent intent;

  const UnknownActionCard({super.key, required this.intent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.theme.colors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.theme.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "I couldn't quite understand that. Here are some things you can ask me:",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: context.theme.colors.foreground),
          ),
          const SizedBox(height: 12),
          _Chip("Transfer 5000 to 0123456789"),
          const SizedBox(height: 8),
          _Chip("What's my credit score?"),
          const SizedBox(height: 8),
          _Chip("Show my transaction history"),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  const _Chip(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: context.theme.colors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: context.theme.colors.primary, fontWeight: FontWeight.w500),
      ),
    );
  }
}

/// A generic action card for intents that just need a simple button.
class GenericActionCard extends StatelessWidget {
  final SaabiIntent intent;
  final String title;
  final String buttonText;
  final IconData icon;
  final String? subtitle;

  const GenericActionCard({
    super.key,
    required this.intent,
    required this.title,
    required this.buttonText,
    required this.icon,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.theme.colors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.theme.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: context.theme.colors.primary, size: 20),
              const SizedBox(width: 8),
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
                    if (subtitle != null && subtitle!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.theme.colors.mutedForeground),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FButton(
              onPress: () => SaabiIntentHandler.execute(context, intent),
              child: Text(buttonText),
            ),
          ),
        ],
      ),
    );
  }
}
