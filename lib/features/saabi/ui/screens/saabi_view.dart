import 'dart:ui' as dart_ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:saabi_mobile/shared/components/layout/app_padding.dart';
import 'package:saabi_mobile/features/saabi/providers/saabi_pod.dart';
import 'package:saabi_mobile/features/saabi/ui/widgets/chat_bubble.dart';
import 'package:saabi_mobile/core/storage/hive/hive_keys.dart';
import 'package:saabi_mobile/features/saabi/ui/screens/saabi_history_view.dart';

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
    final useBackend = HiveKeys.saabiUseBackend.get() ?? false;
    ref.read(saabiProvider.notifier).submitMessage(text, useBackend: useBackend);
  }

  void _submitSuggestion(String text) {
    final useBackend = HiveKeys.saabiUseBackend.get() ?? false;
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
            icon: const Icon(Icons.add_comment_rounded),
            onPress: () {
              ref.read(saabiProvider.notifier).startNewSession();
            },
          ),
          if (HiveKeys.saabiSaveHistory.get() ?? true)
            FHeaderAction(
              icon: const Icon(Icons.history_rounded),
              onPress: () async {
                await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SaabiHistoryView()));
                setState(() {});
              },
            ),
          FHeaderAction(
            icon: const Icon(Icons.fullscreen_rounded),
            onPress: () async {
              await Navigator.of(
                context,
              ).push(MaterialPageRoute(fullscreenDialog: true, builder: (context) => const _SaabiFullScreenView()));
              setState(() {});
            },
          ),
        ],
      ),
      child: _SaabiContent(
        controller: _controller,
        onSubmit: _submit,
        onSuggest: _submitSuggestion,
        onAttach: () {
          final useBackend = HiveKeys.saabiUseBackend.get() ?? false;
          ref.read(saabiProvider.notifier).submitMessage("verify this receipt for me", useBackend: useBackend);
        },
      ),
    );
  }
}

class _SaabiContent extends ConsumerWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;
  final ValueChanged<String> onSuggest;
  final VoidCallback onAttach;

  const _SaabiContent({
    required this.controller,
    required this.onSubmit,
    required this.onSuggest,
    required this.onAttach,
  });

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
          _ChatInputBar(controller: controller, onSubmit: onSubmit, onAttach: onAttach),
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
        child: const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
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
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: context.theme.colors.foreground, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Your AI financial assistant.\nAsk me anything about your business.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: context.theme.colors.mutedForeground, height: 1.5),
            ),
          ),
          const SizedBox(height: 32),
          _SuggestionChip('Transfer 2000 to 9122382182', onSuggest: onSuggest),
          const SizedBox(height: 12),
          _SuggestionChip('What\'s my credit score?', onSuggest: onSuggest),
          const SizedBox(height: 24),
          Center(
            child: GestureDetector(
              onTap: () {
                showFSheet(context: context, builder: (ctx) => const _IntentRegistrySheet(), side: .btt);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'See all capabilities',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: context.theme.colors.primary, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded, size: 14, color: context.theme.colors.primary),
                ],
              ),
            ),
          ),
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
  final VoidCallback onAttach;

  const _ChatInputBar({required this.controller, required this.onSubmit, required this.onAttach});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      child: Row(
        children: [
          GestureDetector(
            onTap: onAttach,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.theme.colors.border.withValues(alpha: 0.3),
              ),
              child: Icon(Icons.attach_file_rounded, color: context.theme.colors.foreground, size: 20),
            ),
          ),
          const SizedBox(width: 8),
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
                  hintStyle: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: context.theme.colors.mutedForeground),
                  border: InputBorder.none,
                ),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: context.theme.colors.foreground),
                onSubmitted: (_) => onSubmit(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, child) {
              final isEmpty = value.text.trim().isEmpty;
              return GestureDetector(
                onTap: isEmpty ? null : onSubmit,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isEmpty
                        ? context.theme.colors.mutedForeground.withValues(alpha: 0.3)
                        : context.theme.colors.primary,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_upward_rounded,
                      color: isEmpty ? context.theme.colors.mutedForeground : context.theme.colors.foreground,
                      size: 20,
                    ),
                  ),
                ),
              );
            },
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
    final useBackend = HiveKeys.saabiUseBackend.get() ?? false;
    ref.read(saabiProvider.notifier).submitMessage(text, useBackend: useBackend);
  }

  void _submitSuggestion(String text) {
    final useBackend = HiveKeys.saabiUseBackend.get() ?? false;
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
                    onAttach: () {},
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
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              ref.read(saabiProvider.notifier).startNewSession();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: context.theme.colors.border.withValues(alpha: 0.5),
                              ),
                              child: Center(
                                child: Icon(Icons.add_comment_rounded, color: context.theme.colors.foreground, size: 18),
                              ),
                            ),
                          ),
                          if (HiveKeys.saabiSaveHistory.get() ?? true) ...[
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () async {
                                await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SaabiHistoryView()));
                                setState(() {});
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: context.theme.colors.border.withValues(alpha: 0.5),
                                ),
                                child: Center(
                                  child: Icon(Icons.history_rounded, color: context.theme.colors.foreground, size: 18),
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(width: 8),
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

class _IntentRegistrySheet extends StatelessWidget {
  const _IntentRegistrySheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(color: context.theme.colors.border, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Text(
              'What Saabi can do',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: context.theme.colors.foreground, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Saabi AI is your financial assistant. Here are the actions currently supported natively:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: context.theme.colors.mutedForeground),
            ),
            const SizedBox(height: 24),
            _buildCapability(
              context,
              Icons.account_balance_rounded,
              'Transfer Money',
              'e.g. "Transfer 2000 to 0123456789"',
            ),
            _buildCapability(context, Icons.send_rounded, 'Send to Saabi User', 'e.g. "Send 5k to Kemi"'),
            _buildCapability(context, Icons.phone_android_rounded, 'Buy Airtime', 'e.g. "Recharge 500 airtime"'),
            _buildCapability(context, Icons.wifi_rounded, 'Buy Data', 'e.g. "Buy 2GB data for my number"'),
            _buildCapability(context, Icons.receipt_rounded, 'Pay Bills', 'e.g. "Pay my electricity bill"'),
            _buildCapability(context, Icons.trending_up_rounded, 'Investment', 'e.g. "Start a new investment plan"'),
            _buildCapability(context, Icons.real_estate_agent_rounded, 'Loans', 'e.g. "Request a business loan"'),
          ],
        ),
      ),
    );
  }

  Widget _buildCapability(BuildContext context, IconData icon, String title, String example) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.theme.colors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: context.theme.colors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: context.theme.colors.foreground, fontWeight: FontWeight.w600),
                ),
                Text(
                  example,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.theme.colors.mutedForeground),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
