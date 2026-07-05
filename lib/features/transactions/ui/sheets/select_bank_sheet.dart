import 'package:flutter/material.dart';
import 'package:forui/forui.dart';


class SelectBankSheet extends StatelessWidget {
  const SelectBankSheet({super.key});

  static const _bankNames = [
    'Access Bank',
    'Fidelity Bank',
    'First Bank of Nigeria',
    'Guaranty Trust Bank (GTB)',
    'Moniepoint',
    'Opay',
    'Nomba Bank',
    'United Bank for Africa (UBA)',
    'Zenith Bank',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
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
                  decoration: BoxDecoration(
                    color: context.theme.colors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Select Bank',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: context.theme.colors.foreground,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              ..._bankNames.map(
                (b) => GestureDetector(
                  onTap: () => Navigator.of(context).pop(b),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: context.theme.colors.card,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: context.theme.colors.border),
                          ),
                          child: Icon(Icons.account_balance_rounded, color: context.theme.colors.primary, size: 16),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          b,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: context.theme.colors.foreground,
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
  }
}
