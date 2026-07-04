import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:saabi_mobile/features/saabi/logic/saabi_intent.dart';
import 'package:intl/intl.dart';

/// Opens the unified transaction flow bottom sheet.
Future<void> showTransactionSheet(BuildContext context, {SaabiIntent? initialIntent}) {
  return showFSheet(
    context: context,
    side: FLayout.btt,
    mainAxisMaxRatio: 8 / 10,
    builder: (context) => TransactionFlowSheet(initialIntent: initialIntent),
  );
}

class TransactionFlowSheet extends StatefulWidget {
  final SaabiIntent? initialIntent;

  const TransactionFlowSheet({super.key, this.initialIntent});

  @override
  State<TransactionFlowSheet> createState() => _TransactionFlowSheetState();
}

class _TransactionFlowSheetState extends State<TransactionFlowSheet> {
  int _currentStep = 0;

  // Form states
  String _recipient = '';
  double _amount = 0.0;
  String _remark = '';
  bool _isTransfer = false;

  // Bank lookup state (step 0 transfer)
  bool _bankMatched = false;
  String _matchedBankName = '';
  String _matchedAccountName = '';
  String? _selectedBank;
  static const _bankNames = ['Nomba Bank', 'Access Bank', 'GTBank', 'UBA', 'Zenith Bank', 'First Bank', 'Opay'];

  final NumberFormat _currencyFormat = NumberFormat.currency(locale: 'en_NG', symbol: '₦');

  @override
  void initState() {
    super.initState();

    if (widget.initialIntent != null) {
      final intent = widget.initialIntent!;
      if (intent is SendIntent) {
        _isTransfer = false;
        _recipient = intent.recipient ?? '';
        _amount = intent.amount ?? 0.0;
        if (_recipient.isNotEmpty && _amount > 0) {
          _currentStep = 1; // Jump to amount verification
        }
      } else if (intent is TransferIntent) {
        _isTransfer = true;
        _recipient = intent.accountNumber ?? '';
        _amount = intent.amount ?? 0.0;
        if (_recipient.isNotEmpty && _amount > 0) {
          _currentStep = 1; // Jump to amount verification
        }
      }
    }
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      // Final Pay
      Navigator.of(context).pop();
      // Show success toast (normally would trigger real API call)
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 300),
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
              // Drag indicator
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(color: context.theme.colors.border, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              // Header row with back/close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep > 0)
                    GestureDetector(
                      onTap: _prevStep,
                      child: Icon(Icons.arrow_back_rounded, color: context.theme.colors.mutedForeground),
                    )
                  else
                    const SizedBox(width: 24),
                  Text(
                    _isTransfer ? 'Transfer to Bank Account' : 'Send Money',
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
              // The steps dynamically sized
              Flexible(
                child: SingleChildScrollView(
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                    alignment: Alignment.topCenter,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: KeyedSubtree(key: ValueKey(_currentStep), child: _getCurrentStepWidget()),
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

  Widget _getCurrentStepWidget() {
    switch (_currentStep) {
      case 0:
        return _buildRecipientStep();
      case 1:
        return _buildAmountStep();
      case 2:
        return _buildReminderStep();
      case 3:
        return _buildPaymentSummaryStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildRecipientStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                'Recipient Account',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.theme.colors.mutedForeground,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              FTextField(
                control: FTextFieldControl.managed(
                  initial: TextEditingValue(text: _recipient),
                  onChange: (value) {
                    _recipient = value.text;
                    // Simulate account lookup after 10 digits
                    if (_isTransfer && value.text.length == 10) {
                      Future.delayed(const Duration(milliseconds: 600), () {
                        if (!mounted || _recipient.length != 10) return;
                        setState(() {
                          _bankMatched = true;
                          _matchedBankName = _selectedBank ?? 'Nomba Bank';
                          _matchedAccountName = 'Kemi Balogun'; // Mock lookup
                        });
                      });
                    } else if (_isTransfer) {
                      setState(() {
                        _bankMatched = false;
                        _matchedAccountName = '';
                      });
                    }
                  },
                ),
                hint: _isTransfer ? 'Enter 10 digit account number' : '@username or Phone',
                keyboardType: _isTransfer ? TextInputType.number : TextInputType.text,
              ),
              if (_isTransfer) ...[
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
                    final banks = _bankNames;
                    final picked = await showFSheet<String>(
                      context: context,
                      side: FLayout.btt,
                      builder: (ctx) => SafeArea(
                        child: Container(
                          decoration: BoxDecoration(
                            color: ctx.theme.colors.background,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                          ),
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  width: 40,
                                  height: 4,
                                  margin: const EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    color: ctx.theme.colors.border,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                              Text(
                                'Select Bank',
                                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                                  color: ctx.theme.colors.foreground,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ...banks.map(
                                (b) => GestureDetector(
                                  onTap: () => Navigator.of(ctx).pop(b),
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 14),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: ctx.theme.colors.card,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: ctx.theme.colors.border),
                                          ),
                                          child: Icon(
                                            Icons.account_balance_rounded,
                                            color: ctx.theme.colors.primary,
                                            size: 18,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          b,
                                          style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                                            color: ctx.theme.colors.foreground,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                    if (picked != null)
                      setState(() {
                        _selectedBank = picked;
                        _bankMatched = false;
                        _matchedAccountName = '';
                      });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: context.theme.colors.background,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: context.theme.colors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedBank ?? 'Select Bank',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: _selectedBank != null
                                ? context.theme.colors.foreground
                                : context.theme.colors.mutedForeground,
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded, color: context.theme.colors.mutedForeground),
                      ],
                    ),
                  ),
                ),
                // Animated bank match reveal card
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                  child: _bankMatched
                      ? Container(
                          margin: const EdgeInsets.only(top: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50).withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF4CAF50).withValues(alpha: 0.25)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.verified_rounded, color: Color(0xFF4CAF50), size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _matchedAccountName,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: context.theme.colors.foreground,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      _matchedBankName,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall?.copyWith(color: context.theme.colors.mutedForeground),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(width: double.infinity),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Recents',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(color: context.theme.colors.foreground, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildRecentItem('Jane Doe', '0123456789 • Nomba Bank', 'J'),
            _buildRecentItem('John Smith', '9876543210 • Global Bank', 'J'),
            _buildRecentItem('Alice Johnson', '1122334455 • Tech Bank', 'A'),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FButton(onPress: _nextStep, child: const Text('Next')),
        ),
      ],
    );
  }

  Widget _buildRecentItem(String name, String details, String avatar) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: context.theme.colors.primary.withValues(alpha: 0.1),
            child: Text(
              avatar,
              style: TextStyle(color: context.theme.colors.primary, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: context.theme.colors.foreground, fontWeight: FontWeight.w500),
                ),
                Text(
                  details,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.theme.colors.mutedForeground),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Resolved recipient banner
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.theme.colors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.theme.colors.border),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: context.theme.colors.primary.withValues(alpha: 0.1),
                child: Icon(Icons.account_balance_rounded, size: 18, color: context.theme.colors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _recipient.isNotEmpty ? _recipient : 'Jane Doe',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: context.theme.colors.foreground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '0123456789 • Nomba Bank',
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
        const SizedBox(height: 24),
        Text(
          'Amount',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: context.theme.colors.mutedForeground, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        FTextField(
          control: FTextFieldControl.managed(
            initial: TextEditingValue(text: _amount > 0 ? _amount.toString() : ''),
            onChange: (value) {
              _amount = double.tryParse(value.text) ?? 0.0;
            },
          ),
          hint: '₦0.00',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        // Quick amount chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildAmountChip(500),
            _buildAmountChip(1000),
            _buildAmountChip(2000),
            _buildAmountChip(5000),
            _buildAmountChip(9999),
            _buildAmountChip(10000),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Remark',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: context.theme.colors.mutedForeground, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        FTextField(
          control: FTextFieldControl.managed(
            initial: TextEditingValue(text: _remark),
            onChange: (value) => _remark = value.text,
          ),
          hint: 'What is this for?',
        ),
        const SizedBox(height: 16),
        Wrap(spacing: 8, children: [_buildRemarkChip('Purchase'), _buildRemarkChip('Personal')]),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FButton(onPress: _nextStep, child: const Text('Confirm')),
        ),
      ],
    );
  }

  Widget _buildAmountChip(double amount) {
    final isSelected = _amount == amount;
    return GestureDetector(
      onTap: () {
        setState(() {
          _amount = amount;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? context.theme.colors.primary : context.theme.colors.card,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? context.theme.colors.primary : context.theme.colors.border),
        ),
        child: Text(
          _currencyFormat.format(amount).replaceAll('.00', ''),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isSelected ? context.theme.colors.primaryForeground : context.theme.colors.foreground,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildRemarkChip(String label) {
    final isSelected = _remark == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _remark = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? context.theme.colors.primary : context.theme.colors.card,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? context.theme.colors.primary : context.theme.colors.border),
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

  Widget _buildReminderStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Icon(Icons.info_outline_rounded, size: 48, color: context.theme.colors.primary),
        const SizedBox(height: 16),
        Text(
          'Reminder',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: context.theme.colors.foreground, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          'Double check the transfer details before you proceed.\nPlease note that successful transfers cannot be reversed.',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: context.theme.colors.mutedForeground, height: 1.5),
        ),
        const SizedBox(height: 24),
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
                'Transaction Details',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: context.theme.colors.foreground, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Name', _recipient.isNotEmpty ? _recipient : 'JANE DOE'),
              _buildDetailRow('Account No.', '0123456789'),
              _buildDetailRow('Bank', 'Nomba Bank'),
              _buildDetailRow('Amount', _currencyFormat.format(_amount)),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: FButton(onPress: _prevStep, child: const Text('Recheck')),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: FButton(onPress: _nextStep, child: const Text('Continue')),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentSummaryStep() {
    final fee = 83.72;
    final vat = 6.28;
    final total = _amount + fee + vat;

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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.theme.colors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.theme.colors.border),
          ),
          child: Column(
            children: [
              _buildDetailRow('Bank', 'Nomba Bank'),
              _buildDetailRow('Account Number', '0123456789'),
              _buildDetailRow('Name', _recipient.isNotEmpty ? _recipient : 'JANE DOE'),
              _buildDetailRow('Amount', _currencyFormat.format(_amount)),
              _buildDetailRow('Fee', _currencyFormat.format(fee)),
              _buildDetailRow('VAT', _currencyFormat.format(vat)),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Use Cashback',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: context.theme.colors.mutedForeground),
                  ),
                  Text(
                    'Use ₦51.37 to offset fee',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: context.theme.colors.primary, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
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
                radius: 14,
                backgroundColor: context.theme.colors.background,
                child: Icon(Icons.wallet_rounded, size: 16, color: context.theme.colors.primary),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Balance',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: context.theme.colors.foreground,
                      fontWeight: FontWeight.w500,
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
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FButton(onPress: _nextStep, child: const Text('Pay')),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
            ).textTheme.bodyMedium?.copyWith(color: context.theme.colors.foreground, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
