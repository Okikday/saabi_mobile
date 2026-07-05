import re

with open('lib/features/transactions/ui/sheets/transaction_flow_sheet.dart', 'r') as f:
    content = f.read()

# 1. Change to ConsumerStatefulWidget
content = content.replace('import \'package:flutter/material.dart\';', 'import \'package:flutter/material.dart\';\nimport \'package:flutter_riverpod/flutter_riverpod.dart\';\nimport \'package:saabi_mobile/features/transactions/providers/transaction_flow_pod.dart\';\nimport \'package:saabi_mobile/features/transactions/ui/sheets/select_bank_sheet.dart\';')
content = content.replace('class TransactionFlowSheet extends StatefulWidget', 'class TransactionFlowSheet extends ConsumerStatefulWidget')
content = content.replace('State<TransactionFlowSheet> createState() => _TransactionFlowSheetState();', 'ConsumerState<TransactionFlowSheet> createState() => _TransactionFlowSheetState();')
content = content.replace('class _TransactionFlowSheetState extends State<TransactionFlowSheet>', 'class _TransactionFlowSheetState extends ConsumerState<TransactionFlowSheet>')

# 2. Update initState to initialize Pod instead of local variables
init_state_old = """  @override
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
  }"""
init_state_new = """  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialIntent != null) {
        final intent = widget.initialIntent!;
        if (intent is SendIntent) {
          ref.read(transactionFlowProvider.notifier).initialize(isTransfer: false, initialRecipient: intent.recipient, initialAmount: intent.amount?.toString());
          if ((intent.recipient ?? '').isNotEmpty && (intent.amount ?? 0) > 0) {
            ref.read(transactionFlowProvider.notifier).setStep(1);
          }
        } else if (intent is TransferIntent) {
          ref.read(transactionFlowProvider.notifier).initialize(isTransfer: true, initialRecipient: intent.accountNumber, initialAmount: intent.amount?.toString());
          if ((intent.accountNumber ?? '').isNotEmpty && (intent.amount ?? 0) > 0) {
            ref.read(transactionFlowProvider.notifier).setStep(1);
          }
        }
      }
    });
  }"""
content = content.replace(init_state_old, init_state_new)

# Write back
with open('lib/features/transactions/ui/sheets/transaction_flow_sheet.dart', 'w') as f:
    f.write(content)
