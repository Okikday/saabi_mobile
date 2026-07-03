import 'package:flutter/material.dart';

import '../theme/saabi_theme.dart';
import '../widgets/saabi_widgets.dart';

class InvestmentPage extends StatelessWidget {
  const InvestmentPage({super.key});

  final List<_InvestmentPlan> _plans = const [
    _InvestmentPlan('Oja Daily Savings', '₦500 - ₦2,000 / day', '8% p.a.', 'Flexible (Withdraw anytime)', [
      'Daily WhatsApp Reminders',
      'Auto-save from sales',
      'No withdrawal fees',
      'Squad Wallet Integration',
    ], false),
    _InvestmentPlan("Trader's Trust Fund", '₦5,000 / week', '12% p.a.', '3 - 6 Months', [
      'Quarterly Dividends',
      'Compound Interest',
      'Business Emergency Loan access',
      'Squad Payout API',
    ], true),
    _InvestmentPlan('Next Level Capital', '₦20,000 / month', '15% p.a.', '1 Year fixed', [
      'Highest Returns',
      'GTB Partnership Backed',
      'Free Business Consulting',
      'Priority Squad Transfers',
    ], false),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      children: [
        Text(
          'Make that 2k work for you.',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900, height: 1.0),
        ),
        const SizedBox(height: 10),
        Text(
          'Sabi your money, make your money Sabi for you. No amount is too small to build your future.',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white.withOpacity(0.45), height: 1.5),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: SaabiTheme.accent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: SaabiTheme.accent.withOpacity(0.2)),
          ),
          child: const Text(
            'Powered by SAABI Engine + Squad API',
            textAlign: TextAlign.center,
            style: TextStyle(color: SaabiTheme.accent, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1.2),
          ),
        ),
        const SizedBox(height: 24),
        const SectionCard(
          radius: 32,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Reality Check', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
              SizedBox(height: 4),
              Text('Why we focus on micro-transactions', style: TextStyle(color: Colors.white54)),
              SizedBox(height: 18),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  MetricCard(
                    value: '< 5%',
                    label: 'Nigerians with Investment Access',
                    detail: 'Mostly High-Income Earners',
                    emphasis: false,
                    icon: Icons.lock_outline,
                  ),
                  MetricCard(
                    value: '40M+',
                    label: 'Informal Traders',
                    detail: 'Driving the Economy',
                    emphasis: false,
                    icon: Icons.groups_outlined,
                  ),
                  MetricCard(
                    value: '250k+',
                    label: 'SAABI Micro-Investors',
                    detail: 'Growing Daily',
                    emphasis: true,
                    icon: Icons.trending_up,
                  ),
                  MetricCard(
                    value: '₦500',
                    label: 'Minimum Investment',
                    detail: 'Start Small, Grow Big',
                    emphasis: true,
                    icon: Icons.account_balance_wallet_outlined,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Available Plans',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 6),
        Text(
          'Simple, secure, and tailored for your hustle.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.45)),
        ),
        const SizedBox(height: 16),
        Column(
          children: [
            for (final plan in _plans) ...[_PlanCard(plan: plan), const SizedBox(height: 16)],
          ],
        ),
        const SizedBox(height: 8),
        SectionCard(
          radius: 32,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ROI Calculator',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 16),
              const Center(
                child: RoiRing(percent: 0.42, centerLabel: 'EST. RETURN', centerValue: '₦3,430'),
              ),
              const SizedBox(height: 16),
              const ProgressBarRow(label: 'Growth Potential', value: 0.72, color: SaabiTheme.accent),
              const SizedBox(height: 12),
              const ProgressBarRow(label: 'Liquidity', value: 0.54, color: Colors.blueAccent),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          radius: 32,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Quick Actions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              SizedBox(height: 16),
              _QuickActionTile(
                icon: Icons.credit_card,
                title: 'Start Investing',
                subtitle: 'Choose a plan and fund it',
              ),
              _QuickActionTile(
                icon: Icons.account_balance,
                title: 'Get Virtual Account',
                subtitle: 'Fund from bank transfers',
              ),
              _QuickActionTile(
                icon: Icons.south_east,
                title: 'Withdraw to Bank',
                subtitle: 'Move gains back to your account',
              ),
              _QuickActionTile(
                icon: Icons.lightbulb_outline,
                title: 'Investment Tips',
                subtitle: 'Simple rules for steady growth',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          radius: 32,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Money Tips', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              SizedBox(height: 12),
              _TipRow('Start small: No amount is too small, consistency is the master key.'),
              _TipRow('Don\'t eat your seed: Try to reinvest your profit to grow your money faster.'),
              _TipRow('Separate business cash from savings: Use SAABI to keep your profit safe.'),
              _TipRow('Emergency fund first: Always keep some quick cash before fixing the rest.'),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.plan});

  final _InvestmentPlan plan;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      radius: 32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (plan.popular)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: SaabiTheme.accent, borderRadius: BorderRadius.circular(999)),
              child: const Text('Most Popular', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900)),
            ),
          const SizedBox(height: 14),
          Text(plan.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text(
            plan.returnRate,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900, color: SaabiTheme.accent),
          ),
          const SizedBox(height: 12),
          Text(
            plan.amount,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.65)),
          ),
          const SizedBox(height: 4),
          Text(
            plan.duration,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withOpacity(0.4)),
          ),
          const SizedBox(height: 16),
          ...plan.features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: SaabiTheme.accent, size: 16),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      feature,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.65)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: plan.popular ? SaabiTheme.accent : Colors.white.withOpacity(0.07),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                plan.name == 'Next Level Capital' ? 'Withdraw to Bank' : 'Start Investing',
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InvestmentPlan {
  const _InvestmentPlan(this.name, this.amount, this.returnRate, this.duration, this.features, this.popular);

  final String name;
  final String amount;
  final String returnRate;
  final String duration;
  final List<String> features;
  final bool popular;
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({required this.icon, required this.title, required this.subtitle});

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(color: SaabiTheme.accent.withOpacity(0.12), borderRadius: BorderRadius.circular(16)),
        child: Icon(icon, color: SaabiTheme.accent),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.45))),
    );
  }
}

class _TipRow extends StatelessWidget {
  const _TipRow(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.circle, color: SaabiTheme.accent, size: 8),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: TextStyle(color: Colors.white.withOpacity(0.65), height: 1.5)),
          ),
        ],
      ),
    );
  }
}
