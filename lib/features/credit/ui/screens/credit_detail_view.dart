import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:saabi_mobile/shared/theme/src/app_colors.dart';

/// Credit Score Detail View — pushed from Home.
class CreditDetailView extends StatelessWidget {
  const CreditDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: const Text('Credit Score'),
        prefixes: [
          FHeaderAction.back(onPress: () => context.pop()),
        ],
      ),
      child: _CreditDetailContent(),
    );
  }
}

class _CreditDetailContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ScoreGauge(),
          const SizedBox(height: 24),
          _SectionLabel('Score Factors'),
          const SizedBox(height: 12),
          _ScoreFactorItem(
            icon: Icons.sync_alt_rounded,
            title: 'Transaction Consistency',
            status: 'Excellent',
            statusColor: AppColors.green500,
          ),
          const SizedBox(height: 8),
          _ScoreFactorItem(
            icon: Icons.account_balance_wallet_rounded,
            title: 'Volume',
            status: 'Good',
            statusColor: AppColors.green500,
          ),
          const SizedBox(height: 8),
          _ScoreFactorItem(
            icon: Icons.group_rounded,
            title: 'Rounds Participation',
            status: 'Needs Work',
            statusColor: AppColors.accent,
          ),
          const SizedBox(height: 24),
          _SectionLabel('Loan Eligibility'),
          const SizedBox(height: 12),
          _LoanEligibilityCard(),
        ],
      ),
    );
  }
}

class _ScoreGauge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neutralBlack100),
      ),
      child: Column(
        children: [
          Text(
            '720',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Good',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.premiumWhite,
                ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Your score is built from 90 days of Nomba collections and transfers.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.neutralBlack400,
                  ),
            ),
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
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppColors.premiumWhite,
            fontWeight: FontWeight.w600,
          ),
    );
  }
}

class _ScoreFactorItem extends StatelessWidget {
  const _ScoreFactorItem({
    required this.icon,
    required this.title,
    required this.status,
    required this.statusColor,
  });

  final IconData icon;
  final String title;
  final String status;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neutralBlack100),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.neutralBlack400, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.premiumWhite,
                  ),
            ),
          ),
          Text(
            status,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _LoanEligibilityCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neutralBlack100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pre-approved Limit',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.neutralBlack400,
                    ),
              ),
              Icon(Icons.verified_rounded, color: AppColors.green500, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '₦150,000',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.premiumWhite,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Apply Now',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.premiumWhite,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
