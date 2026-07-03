import 'dart:async';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:saabi_mobile/shared/routes/app_router.dart';

/// Rounds tab — Group savings circles (Ajo/Esusu/Adashe)
class RoundsView extends StatelessWidget {
  const RoundsView({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(
        title: const Text('Rounds'),
        suffixes: [
          FHeaderAction(
            icon: const Icon(Icons.add_rounded),
            onPress: () => context.pushNamed(Routes.roundsCreate.name),
          ),
        ],
      ),
      child: _RoundsContent(),
    );
  }
}

class _RoundsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CreateJoinCard(),
          const SizedBox(height: 24),
          _SectionLabel('Live Updates'),
          const SizedBox(height: 12),
          const _LiveUpdatesCarousel(),
          const SizedBox(height: 24),
          _SectionLabel('Active Circles'),
          const SizedBox(height: 12),
          _ActiveCircleCard(),
          const SizedBox(height: 24),
          _SectionLabel('Past Rounds'),
          const SizedBox(height: 12),
          _EmptyPastRounds(),
        ],
      ),
    );
  }
}

class _CreateJoinCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.theme.colors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.theme.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Savings Circles',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: context.theme.colors.foreground,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Save together, build trust, and unlock bigger credit limits with your community.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.theme.colors.mutedForeground,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: context.theme.colors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Create Circle',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: context.theme.colors.foreground,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: context.theme.colors.background,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: context.theme.colors.border),
                  ),
                  child: Text(
                    'Join Circle',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: context.theme.colors.foreground,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActiveCircleCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(Routes.circleDetail.name),
      child: Container(
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
                  'Market Traders Fund',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: context.theme.colors.foreground,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: context.theme.colors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Week 3/10',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: context.theme.colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Turn',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: context.theme.colors.mutedForeground,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Week 8',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: context.theme.colors.foreground,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Pot Size',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: context.theme.colors.mutedForeground,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₦500,000',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: context.theme.colors.foreground,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ],
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
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: context.theme.colors.foreground,
            fontWeight: FontWeight.w600,
          ),
    );
  }
}

class _EmptyPastRounds extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.theme.colors.primary.withValues(alpha: 0.1),
              border: Border.all(color: context.theme.colors.primary.withValues(alpha: 0.2)),
            ),
            child: Center(
              child: Icon(Icons.history_rounded, color: context.theme.colors.primary, size: 24),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'No completed rounds yet',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.theme.colors.mutedForeground,
                ),
          ),
        ],
      ),
    );
  }
}

class _LiveUpdatesCarousel extends StatefulWidget {
  const _LiveUpdatesCarousel();

  @override
  State<_LiveUpdatesCarousel> createState() => _LiveUpdatesCarouselState();
}

class _LiveUpdatesCarouselState extends State<_LiveUpdatesCarousel> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentIndex = 0;

  static const List<String> _updates = [
    'Mama K just contributed ₦20,000 to Market Traders Fund',
    'Adewale joined the NextGen Savings Circle',
    'Chinedu successfully cashed out ₦500,000',
    'You are next to cash out in Week 8!',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;
      _currentIndex = (_currentIndex + 1) % _updates.length;
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: context.theme.colors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.theme.colors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Icon(Icons.campaign_rounded, color: context.theme.colors.primary, size: 24),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: _updates.length,
              itemBuilder: (context, index) {
                return Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    _updates[index],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: context.theme.colors.foreground,
                          fontWeight: FontWeight.w500,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
