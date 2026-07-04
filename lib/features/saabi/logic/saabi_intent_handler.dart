import 'package:flutter/material.dart';
import 'package:saabi_mobile/features/saabi/logic/saabi_intent.dart';
import 'package:saabi_mobile/features/transactions/ui/sheets/transaction_flow_sheet.dart';

/// Handles executing [SaabiIntent] actions natively.
class SaabiIntentHandler {
  /// Executes the given [intent].
  ///
  /// For example, if it's a [SendIntent], it natively opens the Send bottom sheet
  /// and pre-fills the extracted values.
  static Future<void> execute(BuildContext context, SaabiIntent intent) async {
    switch (intent) {
      case SendIntent():
      case TransferIntent():
        // Both Send and Transfer trigger the unified transaction sheet
        await showTransactionSheet(context, initialIntent: intent);
        break;
      case CreditScoreIntent():
        // Could open the credit score route directly
        // Routes.creditDetail.push(context);
        break;
      case CreateRoundIntent():
        // Could trigger create round sheet
        break;
      case TransactionHistoryIntent():
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Navigating to Transactions...')));
        break;
      case AirtimeIntent():
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening Airtime Sheet...')));
        break;
      case CheckBalanceIntent():
        // handled internally by chat
        break;
      case UnknownIntent():
        break;
    }
  }
}
