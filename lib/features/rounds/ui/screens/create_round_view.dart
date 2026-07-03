import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class CreateRoundView extends StatelessWidget {
  const CreateRoundView({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(
        title: const Text('Create Round'),
        suffixes: [
          FHeaderAction(
            icon: const Icon(Icons.close_rounded),
            onPress: () => Navigator.of(context).pop(),
          )
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Set up a new savings circle.',
            ),
            const SizedBox(height: 24),
            // Mock content
            FButton(
              onPress: () {},
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
