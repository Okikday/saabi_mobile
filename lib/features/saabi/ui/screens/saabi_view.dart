import 'dart:ui' as dart_ui;
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// Saabi tab — AI-powered financial assistant for informal traders.
class SaabiView extends StatelessWidget {
  const SaabiView({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(
        title: const Text('Saabi'),
        suffixes: [
          FHeaderAction(
            icon: const Icon(Icons.fullscreen_rounded),
            onPress: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => const _SaabiFullScreenView(),
                ),
              );
            },
          ),
        ],
      ),
      child: _SaabiContent(),
    );
  }
}

class _SaabiContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: _EmptyState()),
        _ChatInputBar(),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: context.theme.colors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(
                color: context.theme.colors.primary.withValues(alpha: 0.25),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Icon(Icons.auto_awesome_rounded, color: context.theme.colors.primary, size: 32),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Saabi AI',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: context.theme.colors.foreground,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Your AI financial assistant.\nAsk me anything about your business.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.theme.colors.mutedForeground,
                    height: 1.5,
                  ),
            ),
          ),
          const SizedBox(height: 32),
          _SuggestionChip('What\'s my credit score?'),
          const SizedBox(height: 8),
          _SuggestionChip('Send 5k to Adewale'),
          const SizedBox(height: 8),
          _SuggestionChip('Help me track my expenses'),
        ],
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: context.theme.colors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.theme.colors.border),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: context.theme.colors.mutedForeground,
            ),
      ),
    );
  }
}

class _ChatInputBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      decoration: BoxDecoration(
        color: context.theme.colors.card,
        border: Border(top: BorderSide(color: context.theme.colors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: context.theme.colors.background,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: context.theme.colors.border),
              ),
              child: Text(
                'Ask Saabi AI…',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: context.theme.colors.mutedForeground,
                    ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.theme.colors.primary,
            ),
            child: Center(
              child: Icon(Icons.arrow_upward_rounded, color: context.theme.colors.foreground, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class _SaabiFullScreenView extends StatelessWidget {
  const _SaabiFullScreenView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colors.background,
      body: Stack(
        children: [
          // Main Content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 60), // Space for glass header
                Expanded(child: _EmptyState()),
                _ChatInputBar(),
              ],
            ),
          ),
          
          // Glassmorphism Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: dart_ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  color: context.theme.colors.background.withValues(alpha: 0.6),
                  padding: EdgeInsets.only(
                    top: MediaQuery.paddingOf(context).top,
                    left: 16,
                    right: 16,
                    bottom: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Saabi AI',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: context.theme.colors.foreground,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: context.theme.colors.border.withValues(alpha: 0.5),
                          ),
                          child: Center(
                            child: Icon(Icons.close_rounded, color: context.theme.colors.foreground, size: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
