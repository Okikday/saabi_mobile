import 'package:flutter/material.dart';
import 'package:saabi_mobile/features/saabi/logic/saabi_intent.dart';
import 'package:saabi_mobile/features/transactions/ui/sheets/transaction_flow_sheet.dart';
import 'package:saabi_mobile/shared/routes/app_router.dart';

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
      case TransactionHistoryIntent(query: final query):
        Routes.transactionHistory.push(context, extra: query);
        break;
      case VerifyReceiptIntent():
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Navigating to Transactions...')));
        break;
      case AirtimeIntent():
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening Airtime Sheet...')));
        break;
      case DataIntent():
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening Data Sheet...')));
        break;
      case BillsIntent():
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening Bills Sheet...')));
        break;
      case InvestmentIntent():
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening Investment Page...')));
        break;
      case LoanIntent():
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening Loans Page...')));
        break;
      case CheckBalanceIntent():
        // handled internally by chat
        break;
      case UnknownIntent():
        break;
    }
  }
}
