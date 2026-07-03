import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Unknown error!'),
              const SizedBox(height: 12),
              const Text('We encountered an unknown error. Kindly contact support.'),
              const SizedBox(height: 20),
              FilledButton(onPressed: () => Navigator.of(context).maybePop(), child: const Text('Go back')),
            ],
          ),
        ),
      ),
    );
  }
}
