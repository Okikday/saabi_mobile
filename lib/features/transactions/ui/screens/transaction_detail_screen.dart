import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:saabi_mobile/features/transactions/ui/widgets/txn_tile.dart';

class TransactionDetailScreen extends StatelessWidget {
  final TxnData txn;

  const TransactionDetailScreen({super.key, required this.txn});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: const Text('Transaction Details'),
        prefixes: [FHeaderAction.back(onPress: () => Navigator.of(context).pop())],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: context.theme.colors.card,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: context.theme.colors.border),
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(color: txn.iconColor.withValues(alpha: 0.1), shape: BoxShape.circle),
                    child: Icon(txn.icon, color: txn.iconColor, size: 32),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    txn.amount,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: txn.isDebit ? context.theme.colors.destructive : const Color(0xFF4CAF50),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    txn.title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: context.theme.colors.foreground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    txn.time,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: context.theme.colors.mutedForeground),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),
                  _buildDetailRow(context, 'Status', 'Successful', isStatus: true),
                  _buildDetailRow(context, 'Account', txn.subtitle),
                  _buildDetailRow(context, 'Transaction Ref', 'SAB-${DateTime.now().millisecondsSinceEpoch}'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FButton(onPress: () {}, child: const Text('Share Receipt')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, {bool isStatus = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: context.theme.colors.mutedForeground),
            ),
          ),
          if (isStatus)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: const Color(0xFF4CAF50), fontWeight: FontWeight.bold),
              ),
            )
          else
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
