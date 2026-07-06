import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons_pro/hugeicons.dart';

class AutomationRule {
  final String id;
  final String triggerSender;
  final String actionRecipient;
  final double? specificAmount; // null means "send all"

  AutomationRule({required this.id, required this.triggerSender, required this.actionRecipient, this.specificAmount});
}

class AutomationsPod extends Notifier<List<AutomationRule>> {
  @override
  List<AutomationRule> build() => [];

  void addRule(AutomationRule rule) {
    state = [...state, rule];
  }

  void removeRule(String id) {
    state = state.where((r) => r.id != id).toList();
  }
}

final automationsProvider = NotifierProvider<AutomationsPod, List<AutomationRule>>(AutomationsPod.new);

class AutomationsView extends ConsumerWidget {
  const AutomationsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rules = ref.watch(automationsProvider);

    return FScaffold(
      header: FHeader.nested(
        title: const Text('Live Automations'),
        prefixes: [FHeaderAction.back(onPress: () => context.pop())],
      ),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.theme.colors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.theme.colors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Automated Forwarding',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: context.theme.colors.foreground),
                ),
                const SizedBox(height: 8),
                Text(
                  'Set up rules to automatically forward incoming payments to another account.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.theme.colors.mutedForeground),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FButton(onPress: () => _showAddRuleSheet(context, ref), child: const Text('Create Rule')),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          if (rules.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    Icon(HugeIconsStroke.workflowCircle01, size: 48, color: context.theme.colors.mutedForeground),
                    const SizedBox(height: 16),
                    Text('No automations active', style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
            )
          else ...[
            Text('Active Rules', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            ...rules.map((rule) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.theme.colors.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: context.theme.colors.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'If payment received from ${rule.triggerSender}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Forward ${rule.specificAmount != null ? "₦${rule.specificAmount}" : "all"} to ${rule.actionRecipient}',
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(color: context.theme.colors.mutedForeground),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(HugeIconsStroke.delete01, color: context.theme.colors.destructive),
                      onPressed: () => ref.read(automationsProvider.notifier).removeRule(rule.id),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  void _showAddRuleSheet(BuildContext context, WidgetRef ref) {
    showFSheet(context: context, side: FLayout.btt, builder: (context) => _AddRuleSheet());
  }
}

class _AddRuleSheet extends ConsumerStatefulWidget {
  @override
  ConsumerState<_AddRuleSheet> createState() => _AddRuleSheetState();
}

class _AddRuleSheetState extends ConsumerState<_AddRuleSheet> {
  final _senderController = TextEditingController();
  final _recipientController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _senderController.dispose();
    _recipientController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Create Forwarding Rule',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.theme.colors.destructive.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: context.theme.colors.destructive.withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.warning_amber_rounded, color: context.theme.colors.destructive, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Please cross-check the account numbers. Transactions above ₦9,999 will have a 2-minute delay where they can be cancelled. All other forwards are immediate.',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: context.theme.colors.destructive),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          FTextField(
            label: const Text('When received from (Account Name or Number)'),
            control: FTextFieldControl.managed(
              initial: TextEditingValue(text: _senderController.text),
              onChange: (value) => _senderController.text = value.text,
            ),
          ),
          const SizedBox(height: 16),
          FTextField(
            label: const Text('Forward to (Account Number)'),
            control: FTextFieldControl.managed(
              initial: TextEditingValue(text: _recipientController.text),
              onChange: (value) => _recipientController.text = value.text,
            ),
          ),
          const SizedBox(height: 16),
          FTextField(
            label: const Text('Amount (Leave blank to forward all)'),
            keyboardType: TextInputType.number,
            control: FTextFieldControl.managed(
              initial: TextEditingValue(text: _amountController.text),
              onChange: (value) => _amountController.text = value.text,
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: FButton(
              onPress: () {
                final sender = _senderController.text.trim();
                final recipient = _recipientController.text.trim();
                final amount = double.tryParse(_amountController.text.trim());

                if (sender.isNotEmpty && recipient.isNotEmpty) {
                  ref
                      .read(automationsProvider.notifier)
                      .addRule(
                        AutomationRule(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          triggerSender: sender,
                          actionRecipient: recipient,
                          specificAmount: amount,
                        ),
                      );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save Rule'),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
