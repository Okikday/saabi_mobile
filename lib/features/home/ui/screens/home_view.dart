import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:saabi_mobile/shared/routes/app_router.dart';
import 'package:saabi_mobile/features/transactions/ui/sheets/transaction_flow_sheet.dart';
import 'package:saabi_mobile/features/saabi_actions/logic/saabi_intent.dart';

/// Home tab — main dashboard surface for Saabi Plus.
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(
        title: const Text('Home'),
        suffixes: [
          FHeaderAction(icon: const Icon(HugeIconsSolid.settings02), onPress: () => Routes.settings.push(context)),
        ],
      ),
      child: _HomeContent(),
    );
  }
}

class _HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _BalanceCard()),
              const SizedBox(width: 12),
              _CreditScoreBadge(),
            ],
          ),
          const SizedBox(height: 20),
          _QuickActionsRow(),
          const SizedBox(height: 24),
          _SectionLabel('Recent Transactions'),
          const SizedBox(height: 12),
          _EmptyTransactions(),
        ],
      ),
    );
  }
}

class _BalanceCard extends StatefulWidget {
  const _BalanceCard();

  @override
  State<_BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<_BalanceCard> {
  bool _isHidden = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.theme.colors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.theme.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Balance',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.theme.colors.mutedForeground),
              ),
              GestureDetector(
                onTap: () => setState(() => _isHidden = !_isHidden),
                child: Icon(
                  _isHidden ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                  color: context.theme.colors.mutedForeground,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _isHidden ? '****' : '₦0.00',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: context.theme.colors.foreground,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _CreditScoreBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Routes.creditDetail.push(context),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: context.theme.colors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.theme.colors.border),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: context.theme.colors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '720',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: context.theme.colors.primary, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Credit',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: context.theme.colors.mutedForeground),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionTile(
            icon: FLucideIcons.send,
            label: 'Send',
            onTap: () => showTransactionSheet(context, initialIntent: const SendIntent()),
          ),
        ),
        const SizedBox(width: 12),
        // Expanded(
        //   child: _ActionTile(icon: FLucideIcons.send, label: 'Receive', onTap: () {}),
        // ),
        // const SizedBox(width: 12),
        Expanded(
          child: _ActionTile(
            icon: HugeIconsStroke.transaction,
            label: 'Transfer',
            onTap: () => showTransactionSheet(context, initialIntent: const TransferIntent()),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionTile(icon: Icons.more_horiz_rounded, label: 'More', onTap: () {}),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: context.theme.colors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.theme.colors.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: context.theme.colors.primary, size: 22),
            const SizedBox(height: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: context.theme.colors.foreground),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(
        context,
      ).textTheme.titleSmall?.copyWith(color: context.theme.colors.foreground, fontWeight: FontWeight.w600),
    );
  }
}

class _EmptyTransactions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: context.theme.colors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.theme.colors.border),
      ),
      child: Column(
        children: [
          Icon(Icons.receipt_long_outlined, color: context.theme.colors.mutedForeground, size: 36),
          const SizedBox(height: 12),
          Text(
            'No transactions yet',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: context.theme.colors.mutedForeground),
          ),
        ],
      ),
    );
  }
}
