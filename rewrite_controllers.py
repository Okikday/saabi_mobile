import re

with open('lib/features/transactions/ui/sheets/transaction_flow_sheet.dart', 'r') as f:
    content = f.read()

# Replace _recipientController
content = content.replace("controller: _recipientController,\n                hint: state.isTransfer ? 'Enter 10 digit account number' : '@username or Phone',\n                keyboardType: state.isTransfer ? TextInputType.number : TextInputType.text,\n                onChange: (value) {\n                  ref.read(transactionFlowProvider.notifier).updateRecipient(value);\n                },", "control: FTextFieldControl.managed(\n                  initial: TextEditingValue(text: state.recipient),\n                  onChange: (value) {\n                    ref.read(transactionFlowProvider.notifier).updateRecipient(value.text);\n                  },\n                ),\n                hint: state.isTransfer ? 'Enter 10 digit account number' : '@username or Phone',\n                keyboardType: state.isTransfer ? TextInputType.number : TextInputType.text,")

# Replace _descController
content = content.replace("controller: _descController,\n          hint: 'E.g. Dinner, Rent, Groceries...',\n          onChange: (val) {\n            ref.read(transactionFlowProvider.notifier).updateDescription(val);\n          },", "control: FTextFieldControl.managed(\n            initial: TextEditingValue(text: state.description),\n            onChange: (val) {\n              ref.read(transactionFlowProvider.notifier).updateDescription(val.text);\n            },\n          ),\n          hint: 'E.g. Dinner, Rent, Groceries...',")

# Replace _descController.text = label
content = content.replace("_descController.text = label;", "// Update through provider")

with open('lib/features/transactions/ui/sheets/transaction_flow_sheet.dart', 'w') as f:
    f.write(content)
