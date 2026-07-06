import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:saabi_mobile/features/transactions/ui/sheets/transaction_flow_sheet.dart';
import 'package:saabi_mobile/features/saabi/logic/saabi_intent.dart';

/// Rich detail view for a savings circle.
class CircleDetailView extends StatelessWidget {
  const CircleDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: const Text('Circle Details'),
        prefixes: [FHeaderAction.back(onPress: () => context.pop())],
        suffixes: [FHeaderAction(icon: const Icon(Icons.more_vert_rounded), onPress: () {})],
      ),
      child: _CircleDetailContent(),
    );
  }
}

class _CircleDetailContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CircleHeroCard(),
          const SizedBox(height: 20),
          _ProgressSection(),
          const SizedBox(height: 24),
          _SectionLabel('Members'),
          const SizedBox(height: 12),
          _MembersList(),
          const SizedBox(height: 24),
          _SectionLabel('Contribution History'),
          const SizedBox(height: 12),
          _ContributionHistory(),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: FButton(
              onPress: () => showTransactionSheet(context, initialIntent: TransferIntent(amount: 20000.0)),
              child: const Text('Contribute Now'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleHeroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [context.theme.colors.primary, context.theme.colors.primary.withValues(alpha: 0.75)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Market Traders Fund',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
              // Stats
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Week 3/10',
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            spacing: 12,
            children: [
              Expanded(
                child: _HeroStat(label: 'Pot Size', value: '₦500,000'),
              ),

              Expanded(
                child: _HeroStat(label: 'Members', value: '10'),
              ),

              _HeroStat(label: 'Your Turn', value: 'Week 8'),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white70)),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _ProgressSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const progress = 0.3; // Week 3 of 10
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.theme.colors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.theme.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Round Progress',
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: context.theme.colors.foreground, fontWeight: FontWeight.w600),
              ),
              Text(
                '3 of 10 weeks',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: context.theme.colors.mutedForeground),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 8,
                backgroundColor: context.theme.colors.border,
                color: context.theme.colors.primary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Next payout in 3 days — ₦50,000 to Week 3 member',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.theme.colors.mutedForeground),
          ),
        ],
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

class _MembersList extends StatelessWidget {
  static const _members = [
    (name: 'Mama K', week: 'Week 1 ✓', paid: true),
    (name: 'Adewale', week: 'Week 2 ✓', paid: true),
    (name: 'Chinedu', week: 'Week 3 — Next', paid: false),
    (name: 'Ngozi', week: 'Week 4', paid: false),
    (name: 'You', week: 'Week 8', paid: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _members.map((m) => _MemberTile(name: m.name, week: m.week, paid: m.paid)).toList(),
    );
  }
}

class _MemberTile extends StatelessWidget {
  const _MemberTile({required this.name, required this.week, required this.paid});
  final String name;
  final String week;
  final bool paid;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: context.theme.colors.primary.withValues(alpha: 0.15),
            child: Text(
              name[0],
              style: TextStyle(color: context.theme.colors.primary, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: context.theme.colors.foreground, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            week,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: paid ? const Color(0xFF4CAF50) : context.theme.colors.mutedForeground,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContributionHistory extends StatelessWidget {
  static const _history = [
    (name: 'Mama K', amount: '₦50,000', date: 'Jun 30'),
    (name: 'Adewale', amount: '₦50,000', date: 'Jun 23'),
  ];

  @override
  Widget build(BuildContext context) {
    if (_history.isEmpty) {
      return Text(
        'No contributions yet',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.theme.colors.mutedForeground),
      );
    }
    return Column(
      children: _history
          .map(
            (h) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: context.theme.colors.card,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: context.theme.colors.border),
              ),
              child: Row(
                children: [
                  Icon(Icons.arrow_downward_rounded, color: const Color(0xFF4CAF50), size: 18),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          h.name,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: context.theme.colors.foreground,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          h.date,
                          style: Theme.of(
                            context,
                          ).textTheme.labelSmall?.copyWith(color: context.theme.colors.mutedForeground),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    h.amount,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF4CAF50), fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
