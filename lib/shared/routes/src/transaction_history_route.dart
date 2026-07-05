import 'package:flutter/material.dart';
import 'package:saabi_mobile/features/transactions/ui/screens/transaction_history_screen.dart';
import 'package:saabi_mobile/shared/routes/app_router.dart';

final transactionHistoryRoute = GoRoute(
  path: Routes.transactionHistory.path,
  name: Routes.transactionHistory.name,
  builder: (context, state) {
    // The query can be passed via extra if provided
    final query = state.extra as String?;
    return TransactionHistoryScreen(initialSearchQuery: query);
  },
);
