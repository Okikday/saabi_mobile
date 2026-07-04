import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:saabi_mobile/features/main/providers/src/home_pod.dart';

/// Balance card with persisted hide/show toggle.
/// Double-tap or tap the eye icon to toggle visibility.
class BalanceCard extends ConsumerWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHidden = ref.watch(balanceHiddenProvider).value ?? false;

    return GestureDetector(
      onDoubleTap: () => ref.read(balanceHiddenProvider.notifier).set(!isHidden),
      child: Container(
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
                Expanded(
                  child: Text(
                    'Total Balance',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.theme.colors.mutedForeground),
                  ),
                ),
                GestureDetector(
                  onTap: () => ref.read(balanceHiddenProvider.notifier).set(!isHidden),
                  child: Icon(
                    isHidden ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                    color: context.theme.colors.mutedForeground,
                    size: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Text(
                key: ValueKey(isHidden),
                isHidden ? '● ● ● ●' : '₦0.00',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: context.theme.colors.foreground,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
