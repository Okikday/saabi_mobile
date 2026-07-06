import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:saabi_mobile/features/saabi/logic/saabi_intent.dart';
import 'package:intl/intl.dart';
import 'package:saabi_mobile/features/transactions/providers/transaction_flow_pod.dart';
import 'package:saabi_mobile/features/transactions/ui/sheets/select_bank_sheet.dart';
import 'package:hugeicons_pro/hugeicons.dart';

/// Opens the unified transaction flow bottom sheet.
Future<bool?> showTransactionSheet(BuildContext context, {SaabiIntent? initialIntent}) {
  return showFSheet(
    context: context,
    side: FLayout.btt,
    mainAxisMaxRatio: 8.5 / 10,
    resizeToAvoidBottomInset: false,
    builder: (context) => TransactionFlowSheet(initialIntent: initialIntent),
  );
}

class TransactionFlowSheet extends ConsumerStatefulWidget {
  final SaabiIntent? initialIntent;

  const TransactionFlowSheet({super.key, this.initialIntent});

  @override
  ConsumerState<TransactionFlowSheet> createState() => _TransactionFlowSheetState();
}

class _TransactionFlowSheetState extends ConsumerState<TransactionFlowSheet> {
  final NumberFormat _currencyFormat = NumberFormat.currency(locale: 'en_NG', symbol: '₦');

  late final TextEditingController _amountController;
  late final TextEditingController _recipientController;
  late final TextEditingController _descController;
  
  late final FocusNode _recipientFocus;
  late final FocusNode _amountFocus;
  late final FocusNode _descFocus;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _recipientController = TextEditingController();
    _descController = TextEditingController();
    
    _recipientFocus = FocusNode();
    _amountFocus = FocusNode();
    _descFocus = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialIntent != null) {
        final intent = widget.initialIntent!;
        if (intent is SendIntent) {
          ref
              .read(transactionFlowProvider.notifier)
              .initialize(
                isTransfer: false,
                initialRecipient: intent.recipient,
                initialAmount: intent.amount?.toString(),
                initialDescription: intent.description,
              );
          _recipientController.text = intent.recipient ?? '';
          if (intent.amount != null) _amountController.text = intent.amount.toString();
          if (intent.description != null) _descController.text = intent.description!;

          if ((intent.recipient ?? '').isNotEmpty) {
            ref.read(transactionFlowProvider.notifier).updateRecipient(intent.recipient!);
          }
          if (intent.amount != null) {
            ref.read(transactionFlowProvider.notifier).updateAmount(intent.amount.toString());
          }
          if (intent.description != null) {
            ref.read(transactionFlowProvider.notifier).updateDescription(intent.description!);
          }

          if ((intent.recipient ?? '').isNotEmpty && (intent.amount ?? 0) > 0) {
            ref.read(transactionFlowProvider.notifier).setStep(1);
          }
        } else if (intent is TransferIntent) {
          ref
              .read(transactionFlowProvider.notifier)
              .initialize(
                isTransfer: true,
                initialRecipient: intent.accountNumber,
                initialAmount: intent.amount?.toString(),
                initialDescription: intent.description,
              );
          _recipientController.text = intent.accountNumber ?? '';
          if (intent.amount != null) _amountController.text = intent.amount.toString();
          if (intent.description != null) _descController.text = intent.description!;

          if ((intent.accountNumber ?? '').isNotEmpty) {
            ref.read(transactionFlowProvider.notifier).updateRecipient(intent.accountNumber!);
          }
          if (intent.amount != null) {
            ref.read(transactionFlowProvider.notifier).updateAmount(intent.amount.toString());
          }
          if (intent.description != null) {
            ref.read(transactionFlowProvider.notifier).updateDescription(intent.description!);
          }

          if ((intent.accountNumber ?? '').isNotEmpty && (intent.amount ?? 0) > 0) {
            ref.read(transactionFlowProvider.notifier).setStep(1);
          }
        }
      }
      
      final state = ref.read(transactionFlowProvider);
      _focusForStep(state.currentStep);
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _recipientController.dispose();
    _descController.dispose();
    _recipientFocus.dispose();
    _amountFocus.dispose();
    _descFocus.dispose();
    super.dispose();
  }

  void _nextStep() {
    final state = ref.read(transactionFlowProvider);
    if (state.currentStep < 3) {
      ref.read(transactionFlowProvider.notifier).nextStep();
      _focusForStep(state.currentStep + 1);
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<bool> _onWillPop() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return FDialog(
          title: const Text('Cancel Transaction?'),
          body: const Text('Are you sure you want to cancel this transaction?'),
          actions: [
            FButton(variant: .outline, onPress: () => Navigator.of(context).pop(false), child: const Text('No')),
            FButton(onPress: () => Navigator.of(context).pop(true), child: const Text('Yes, Cancel')),
          ],
        );
      },
    );
    return confirm ?? false;
  }

  void _prevStep() async {
    final state = ref.read(transactionFlowProvider);
    if (state.currentStep > 0) {
      ref.read(transactionFlowProvider.notifier).prevStep();
      _focusForStep(state.currentStep - 1);
    } else {
      final shouldPop = await _onWillPop();
      if (shouldPop && mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void _focusForStep(int step) {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      switch (step) {
        case 0:
          _recipientFocus.requestFocus();
          break;
        case 1:
          _amountFocus.requestFocus();
          break;
        case 2:
          _descFocus.requestFocus();
          break;
        default:
          FocusScope.of(context).unfocus();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionFlowProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop(result);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: BoxDecoration(
            color: context.theme.colors.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(color: context.theme.colors.border, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (state.currentStep > 0)
                    GestureDetector(
                      onTap: _prevStep,
                      child: Icon(Icons.arrow_back_rounded, color: context.theme.colors.mutedForeground),
                    )
                  else
                    const SizedBox(width: 24),
                  Text(
                    state.isTransfer ? 'Transfer to Bank Account' : 'Send Money',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: context.theme.colors.foreground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close_rounded, color: context.theme.colors.mutedForeground),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Flexible(
                child: SingleChildScrollView(
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                    alignment: Alignment.topCenter,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: KeyedSubtree(key: ValueKey(state.currentStep), child: _getCurrentStepWidget(state)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getCurrentStepWidget(TransactionFlowState state) {
    switch (state.currentStep) {
      case 0:
        return _buildRecipientStep(state);
      case 1:
        return _buildAmountStep(state);
      case 2:
        return _buildDescriptionStep(state);
      case 3:
        return _buildPaymentSummaryStep(state);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildRecipientStep(TransactionFlowState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.theme.colors.card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: context.theme.colors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recipient Account',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.theme.colors.mutedForeground,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              FTextField(
                autofocus: true,
                focusNode: _recipientFocus,
                control: FTextFieldControl.managed(
                  initial: TextEditingValue(text: state.recipient),
                  onChange: (value) {
                    ref.read(transactionFlowProvider.notifier).updateRecipient(value.text);
                  },
                ),
                hint: state.isTransfer ? 'Enter 10 digit account number' : '@username or Phone',
                keyboardType: state.isTransfer ? TextInputType.number : TextInputType.text,
              ),
              if (state.isTransfer) ...[
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
                    final picked = await showFSheet<String>(
                      context: context,
                      side: FLayout.btt,
                      builder: (ctx) => const SelectBankSheet(),
                    );
                    if (picked != null) {
                      ref.read(transactionFlowProvider.notifier).selectBank(picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: context.theme.colors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: context.theme.colors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          state.selectedBank ?? 'Select Bank',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: state.selectedBank != null
                                ? context.theme.colors.foreground
                                : context.theme.colors.mutedForeground,
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down_rounded, color: context.theme.colors.mutedForeground),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (state.bankMatched) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF4CAF50).withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Color(0xFF4CAF50)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.matchedAccountName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: context.theme.colors.foreground,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        state.matchedBankName,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: context.theme.colors.mutedForeground),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FButton(
            onPress: (!state.isTransfer && state.recipient.isNotEmpty) || (state.isTransfer && state.bankMatched)
                ? _nextStep
                : null,
            child: const Text('Next'),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountStep(TransactionFlowState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: context.theme.colors.card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: context.theme.colors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Enter Amount',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.theme.colors.mutedForeground,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '₦',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: context.theme.colors.foreground,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: FTextField(
                      autofocus: true,
                      focusNode: _amountFocus,
                      control: FTextFieldControl.managed(
                        initial: TextEditingValue(text: state.amount),
                        onChange: (val) {
                          ref.read(transactionFlowProvider.notifier).updateAmount(val.text);
                        },
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      hint: '0.00',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Balance: ₦8,268.87',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.theme.colors.mutedForeground),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FButton(
            onPress: (double.tryParse(state.amount) ?? 0.0) > 0 ? _nextStep : null,
            child: const Text('Next'),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionStep(TransactionFlowState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [context.theme.colors.primary, context.theme.colors.primary.withValues(alpha: 0.6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: context.theme.colors.primary.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(HugeIconsStroke.pencilEdit02, size: 32, color: Colors.white),
        ),
        const SizedBox(height: 24),
        Text(
          'What is this for?',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: context.theme.colors.foreground, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Add a note for this transaction (optional)',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: context.theme.colors.mutedForeground),
        ),
        const SizedBox(height: 32),
        FTextField(
          autofocus: true,
          focusNode: _descFocus,
          control: FTextFieldControl.managed(
            initial: TextEditingValue(text: state.description),
            onChange: (val) {
              ref.read(transactionFlowProvider.notifier).updateDescription(val.text);
            },
          ),
          hint: 'E.g. Dinner, Rent, Groceries...',
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            _buildDescChip('Food', state.description),
            _buildDescChip('Drinks', state.description),
            _buildDescChip('Transport', state.description),
            _buildDescChip('Gift', state.description),
          ],
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: FButton(onPress: _nextStep, child: const Text('Review Payment')),
        ),
      ],
    );
  }

  Widget _buildDescChip(String label, String currentDesc) {
    final isSelected = currentDesc == label;
    return GestureDetector(
      onTap: () {
        // Update through provider
        ref.read(transactionFlowProvider.notifier).updateDescription(label);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? context.theme.colors.primary : context.theme.colors.card,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isSelected ? context.theme.colors.primary : context.theme.colors.border),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: context.theme.colors.primary.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isSelected ? context.theme.colors.primaryForeground : context.theme.colors.foreground,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentSummaryStep(TransactionFlowState state) {
    final amt = double.tryParse(state.amount) ?? 0.0;
    final fee = 83.72;
    final vat = 6.28;
    final total = amt + fee + vat;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 12),
        Text(
          _currencyFormat.format(total),
          style: Theme.of(
            context,
          ).textTheme.displaySmall?.copyWith(color: context.theme.colors.foreground, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: context.theme.colors.card,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: context.theme.colors.border),
            boxShadow: [
              BoxShadow(
                color: context.theme.colors.border.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              if (state.isTransfer) ...[
                _buildDetailRow('Bank', state.matchedBankName),
                _buildDetailRow('Account Number', state.recipient),
                _buildDetailRow('Name', state.matchedAccountName),
              ] else ...[
                _buildDetailRow('Recipient', state.recipient),
              ],
              if (state.description.isNotEmpty) _buildDetailRow('Description', state.description),
              _buildDetailRow('Amount', _currencyFormat.format(amt)),
              _buildDetailRow('Fee', _currencyFormat.format(fee)),
              _buildDetailRow('VAT', _currencyFormat.format(vat)),
              const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider(height: 24, thickness: 0.5)),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Payment Method',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: context.theme.colors.foreground, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.theme.colors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.theme.colors.primary),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: context.theme.colors.primary.withValues(alpha: 0.1),
                child: Icon(Icons.wallet_rounded, size: 20, color: context.theme.colors.primary),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Balance',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: context.theme.colors.foreground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _currencyFormat.format(8268.87),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.theme.colors.mutedForeground),
                  ),
                ],
              ),
              const Spacer(),
              Icon(Icons.check_circle_rounded, color: context.theme.colors.primary),
            ],
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: FButton(
            onPress: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Pay Securely'),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: context.theme.colors.mutedForeground),
          ),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: context.theme.colors.foreground, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
