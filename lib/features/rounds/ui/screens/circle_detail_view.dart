import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class CircleDetailView extends StatelessWidget {
  const CircleDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(
        title: const Text('Circle Details'),
        suffixes: [
          FHeaderAction(
            icon: const Icon(Icons.more_vert_rounded),
            onPress: () {},
          )
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                    'Market Women Ajo',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: context.theme.colors.foreground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '5 members • Next payout in 3 days',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: context.theme.colors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
