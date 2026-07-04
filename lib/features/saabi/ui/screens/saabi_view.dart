import 'dart:ui' as dart_ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:saabi_mobile/shared/components/layout/app_padding.dart';
import 'package:saabi_mobile/features/saabi/providers/saabi_pod.dart';
import 'package:saabi_mobile/features/saabi/ui/widgets/chat_bubble.dart';
import 'package:saabi_mobile/core/storage/hive/hive_keys.dart';

/// Saabi tab — AI-powered financial assistant for informal traders.
class SaabiView extends ConsumerStatefulWidget {
  const SaabiView({super.key});

  @override
  ConsumerState<SaabiView> createState() => _SaabiViewState();
}

class _SaabiViewState extends ConsumerState<SaabiView> {
  final TextEditingController _controller = TextEditingController();

  void _submit() {
    final text = _controller.text;
    if (text.trim().isEmpty) return;
    
    _controller.clear();
    final useBackend = HiveKeys.saabiUseBackend.get();
    ref.read(saabiProvider.notifier).submitMessage(text, useBackend: useBackend);
  }
  
  void _submitSuggestion(String text) {
    final useBackend = HiveKeys.saabiUseBackend.get();
    ref.read(saabiProvider.notifier).submitMessage(text, useBackend: useBackend);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                MaterialPageRoute(fullscreenDialog: true, builder: (context) => const _SaabiFullScreenView()),
              );
            },
          ),
        ],
      ),
      child: _SaabiContent(controller: _controller, onSubmit: _submit, onSuggest: _submitSuggestion),
    );
  }
}

class _SaabiContent extends ConsumerWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;
  final ValueChanged<String> onSuggest;

  const _SaabiContent({required this.controller, required this.onSubmit, required this.onSuggest});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(saabiProvider);
    final messages = state.messages;

    return BottomPadding(
      child: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? _EmptyState(onSuggest: onSuggest)
                : ListView.builder(
                    reverse: true, // Anchor to bottom
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    itemCount: messages.length + (state.isProcessing ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (state.isProcessing && index == 0) {
                        return const _ProcessingIndicator();
                      }
                      final msgIndex = state.isProcessing ? index - 1 : index;
                      // Because reverse=true, index 0 is the newest message (last in list)
                      final msg = messages[messages.length - 1 - msgIndex];
                      return ChatBubble(message: msg);
                    },
                  ),
          ),
          _ChatInputBar(controller: controller, onSubmit: onSubmit),
        ],
      ),
    );
  }
}

class _ProcessingIndicator extends StatelessWidget {
  const _ProcessingIndicator();
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 16, bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.theme.colors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.theme.colors.border),
        ),
        child: const SizedBox(
          width: 16, height: 16, 
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final ValueChanged<String> onSuggest;
  
  const _EmptyState({required this.onSuggest});

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
              border: Border.all(color: context.theme.colors.primary.withValues(alpha: 0.25), width: 1.5),
            ),
            child: Center(child: Icon(Icons.auto_awesome_rounded, color: context.theme.colors.primary, size: 32)),
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
          _SuggestionChip('Transfer 2000 to 9122382182', onSuggest: onSuggest),
          const SizedBox(height: 8),
          _SuggestionChip('What\'s my credit score?', onSuggest: onSuggest),
          const SizedBox(height: 8),
          _SuggestionChip('Check my balance', onSuggest: onSuggest),
        ],
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip(this.label, {required this.onSuggest});

  final String label;
  final ValueChanged<String> onSuggest;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSuggest(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: context.theme.colors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: context.theme.colors.border),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.theme.colors.mutedForeground),
        ),
      ),
    );
  }
}

class _ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;
  
  const _ChatInputBar({required this.controller, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              decoration: BoxDecoration(
                color: context.theme.colors.background,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: context.theme.colors.border),
              ),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Ask Saabi AI…',
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: context.theme.colors.mutedForeground),
                  border: InputBorder.none,
                ),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: context.theme.colors.foreground),
                onSubmitted: (_) => onSubmit(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onSubmit,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(shape: BoxShape.circle, color: context.theme.colors.primary),
              child: Center(child: Icon(Icons.arrow_upward_rounded, color: context.theme.colors.foreground, size: 20)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SaabiFullScreenView extends ConsumerStatefulWidget {
  const _SaabiFullScreenView();

  @override
  ConsumerState<_SaabiFullScreenView> createState() => _SaabiFullScreenViewState();
}

class _SaabiFullScreenViewState extends ConsumerState<_SaabiFullScreenView> {
  final TextEditingController _controller = TextEditingController();

  void _submit() {
    final text = _controller.text;
    if (text.trim().isEmpty) return;
    
    _controller.clear();
    final useBackend = HiveKeys.saabiUseBackend.get();
    ref.read(saabiProvider.notifier).submitMessage(text, useBackend: useBackend);
  }

  void _submitSuggestion(String text) {
    final useBackend = HiveKeys.saabiUseBackend.get();
    ref.read(saabiProvider.notifier).submitMessage(text, useBackend: useBackend);
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                Expanded(
                  child: _SaabiContent(
                    controller: _controller,
                    onSubmit: _submit,
                    onSuggest: _submitSuggestion,
                  ),
                ),
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
                  padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top, left: 16, right: 16, bottom: 12),
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
