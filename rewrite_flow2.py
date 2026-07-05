import re

with open('lib/features/transactions/ui/sheets/transaction_flow_sheet.dart', 'r') as f:
    content = f.read()

# Replace variables with riverpod equivalents in build and helper methods
replacements = [
    (r'_currentStep', r'ref.watch(transactionFlowProvider).currentStep'),
    (r'_isTransfer', r'ref.watch(transactionFlowProvider).isTransfer'),
    (r'_recipient', r'ref.watch(transactionFlowProvider).recipient'),
    (r'_amount', r'double.tryParse(ref.watch(transactionFlowProvider).amount) ?? 0.0'),
    (r'_remark', r'ref.watch(transactionFlowProvider).description'),
    (r'_bankMatched', r'ref.watch(transactionFlowProvider).bankMatched'),
    (r'_selectedBank', r'ref.watch(transactionFlowProvider).selectedBank'),
    (r'_matchedBankName', r'ref.watch(transactionFlowProvider).matchedBankName'),
    (r'_matchedAccountName', r'ref.watch(transactionFlowProvider).matchedAccountName'),
    
    # State updates
    (r'setState\(\(\) => _currentStep\+\+\);', r'ref.read(transactionFlowProvider.notifier).nextStep();'),
    (r'setState\(\(\) => _currentStep--\);', r'ref.read(transactionFlowProvider.notifier).previousStep();'),
    (r'setState\(\(\) \{\s*_remark = label;\s*\}\);', r'ref.read(transactionFlowProvider.notifier).updateDescription(label);'),
]

for old, new in replacements:
    content = re.sub(old, new, content)

# Remove the state variables declaration
content = re.sub(r'int _currentStep = 0;.*final NumberFormat _currencyFormat =', r'final NumberFormat _currencyFormat =', content, flags=re.DOTALL)

with open('lib/features/transactions/ui/sheets/transaction_flow_sheet.dart', 'w') as f:
    f.write(content)
