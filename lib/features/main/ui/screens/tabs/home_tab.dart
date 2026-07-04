import 'dart:async';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:saabi_mobile/features/main/ui/widgets/home/balance_card.dart';
import 'package:saabi_mobile/features/main/ui/widgets/home/sheets/more_actions_sheet.dart';
import 'package:saabi_mobile/shared/routes/app_router.dart';
import 'package:saabi_mobile/features/transactions/ui/sheets/transaction_flow_sheet.dart';
import 'package:saabi_mobile/features/saabi/logic/saabi_intent.dart';

/// Home tab — main dashboard surface for Saabi Plus.
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(
        title: const Text('Home'),
        // style: FHeaderStyleDelta.delta(decoration: DecorationDelta.value(BoxDecoration(color: ))),
        suffixes: [
          FHeaderAction(
            icon: const Icon(HugeIconsStroke.notification01, size: 20),
            onPress: () => Routes.notifications.push(context),
          ),
          FHeaderAction(
            icon: const Icon(HugeIconsSolid.settings02, size: 22),
            onPress: () => Routes.settings.push(context),
          ),
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(child: BalanceCard()),
              const SizedBox(width: 12),
              _CreditScoreBadge(),
            ],
          ),
          const SizedBox(height: 16),
          const _LiveReminderBanner(),
          const SizedBox(height: 20),
          _QuickActionsRow(),
          const SizedBox(height: 24),
          _RecentTransactionsSection(),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Live Reminder Banner
// ──────────────────────────────────────────────────────────────────────────────

class _LiveReminderBanner extends StatefulWidget {
  const _LiveReminderBanner();

  @override
  State<_LiveReminderBanner> createState() => _LiveReminderBannerState();
}

class _LiveReminderBannerState extends State<_LiveReminderBanner> {
  late final PageController _ctrl;
  Timer? _timer;
  int _idx = 0;

  static const _reminders = [
    (icon: Icons.savings_rounded, text: 'Contribute to Market Traders Fund today'),
    (icon: Icons.star_rounded, text: 'Review your credit activity to improve your score'),
    (icon: Icons.swap_horiz_rounded, text: 'Your next round payout is in 3 days'),
    (icon: Icons.check_circle_rounded, text: 'All your transactions are up to date'),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = PageController();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      _idx = (_idx + 1) % _reminders.length;
      _ctrl.animateToPage(_idx, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Routes.notifications.push(context),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: context.theme.colors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.theme.colors.primary.withValues(alpha: 0.18)),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            Icon(Icons.campaign_rounded, color: context.theme.colors.primary, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: PageView.builder(
                controller: _ctrl,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: _reminders.length,
                itemBuilder: (_, i) => Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _reminders[i].text,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.theme.colors.foreground,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: context.theme.colors.mutedForeground, size: 16),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Credit Score Badge
// ──────────────────────────────────────────────────────────────────────────────

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
              'Score',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: context.theme.colors.mutedForeground),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Quick Actions
// ──────────────────────────────────────────────────────────────────────────────

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
        Expanded(
          child: _ActionTile(
            icon: HugeIconsStroke.transaction,
            label: 'Transfer',
            onTap: () => showTransactionSheet(context, initialIntent: const TransferIntent()),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionTile(icon: Icons.more_horiz_rounded, label: 'More', onTap: () => showMoreActionsSheet(context)),
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

// ──────────────────────────────────────────────────────────────────────────────
// Recent Transactions
// ──────────────────────────────────────────────────────────────────────────────

class _RecentTransactionsSection extends StatelessWidget {
  static const _txns = [
    _TxnData(
      icon: HugeIconsStroke.arrowUpRight01,
      iconColor: Color(0xFFF44336),
      title: 'Transfer to Jane Doe',
      subtitle: 'Nomba Bank • 0123456789',
      amount: '-₦25,000',
      time: 'Today, 10:42 AM',
      isDebit: true,
    ),
    _TxnData(
      icon: HugeIconsStroke.arrowDown02,
      iconColor: Color(0xFF4CAF50),
      title: 'Received from Mama K',
      subtitle: 'Nomba Bank',
      amount: '+₦50,000',
      time: 'Yesterday, 3:14 PM',
      isDebit: false,
    ),
    // _TxnData(
    //   icon: Icons.phone_android_rounded,
    //   iconColor: Color(0xFF2196F3),
    //   title: 'Airtime Purchase',
    //   subtitle: 'MTN • 0812 345 6789',
    //   amount: '-₦1,000',
    //   time: 'Jun 30, 8:00 AM',
    //   isDebit: true,
    // ),
    // _TxnData(
    //   icon: Icons.savings_rounded,
    //   iconColor: Color(0xFF9C27B0),
    //   title: 'Circle Contribution',
    //   subtitle: 'Market Traders Fund',
    //   amount: '-₦20,000',
    //   time: 'Jun 29, 9:05 AM',
    //   isDebit: true,
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Transactions',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(color: context.theme.colors.foreground, fontWeight: FontWeight.w600),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                'See all',
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: context.theme.colors.primary, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: context.theme.colors.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: context.theme.colors.border),
          ),
          child: Column(
            children: List.generate(_txns.length, (i) {
              return Column(
                children: [
                  _TxnTile(data: _txns[i]),
                  if (i < _txns.length - 1)
                    Divider(height: 0, thickness: 0.5, indent: 60, color: context.theme.colors.border),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _TxnData {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String amount;
  final String time;
  final bool isDebit;
  const _TxnData({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.time,
    required this.isDebit,
  });
}

class _TxnTile extends StatelessWidget {
  const _TxnTile({required this.data});
  final _TxnData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: data.iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(data.icon, color: data.iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: context.theme.colors.foreground, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(
                  data.subtitle,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(color: context.theme.colors.mutedForeground),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                data.amount,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: data.isDebit ? const Color(0xFFF44336) : const Color(0xFF4CAF50),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                data.time,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: context.theme.colors.mutedForeground),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
