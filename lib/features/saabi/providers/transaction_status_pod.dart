import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TransactionStatus {
  pending,
  successful,
  cancelled,
}

class TransactionStatusPod extends Notifier<Map<String, TransactionStatus>> {
  @override
  Map<String, TransactionStatus> build() {
    return {};
  }

  void setStatus(String id, TransactionStatus status) {
    state = {
      ...state,
      id: status,
    };
  }
}

final transactionStatusProvider = NotifierProvider<TransactionStatusPod, Map<String, TransactionStatus>>(TransactionStatusPod.new);
