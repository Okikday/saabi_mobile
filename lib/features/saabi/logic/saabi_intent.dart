import 'package:uuid/uuid.dart';

/// Represents the structured intents that Saabi AI can trigger natively.
sealed class SaabiIntent {
  final String id;
  SaabiIntent() : id = const Uuid().v4();
}

/// Represents an intent to send money to another Saabi/Nomba user.
class SendIntent extends SaabiIntent {
  final String? recipient;
  final double? amount;
  final String? description;

  SendIntent({this.recipient, this.amount, this.description});
}

/// Represents an intent to transfer money to a bank account.
class TransferIntent extends SaabiIntent {
  final String? bankCode;
  final String? accountNumber;
  final double? amount;
  final String? description;

  TransferIntent({this.bankCode, this.accountNumber, this.amount, this.description});
}

/// Represents an intent to query the user's credit score.
class CreditScoreIntent extends SaabiIntent {
  CreditScoreIntent();
}

/// Represents an intent to create a new Savings Circle.
class CreateRoundIntent extends SaabiIntent {
  CreateRoundIntent();
}

/// Represents an intent to check transaction history.
class TransactionHistoryIntent extends SaabiIntent {
  final DateTime? date;
  final String? query;
  TransactionHistoryIntent({this.date, this.query});
}

/// Represents an intent to buy airtime.
class AirtimeIntent extends SaabiIntent {
  final String? phoneNumber;
  final double? amount;
  AirtimeIntent({this.phoneNumber, this.amount});
}

/// Represents an intent to buy data.
class DataIntent extends SaabiIntent {
  final String? phoneNumber;
  DataIntent({this.phoneNumber});
}

/// Represents an intent to pay bills.
class BillsIntent extends SaabiIntent {
  BillsIntent();
}

/// Represents an intent to start an investment.
class InvestmentIntent extends SaabiIntent {
  InvestmentIntent();
}

/// Represents an intent to request a loan.
class LoanIntent extends SaabiIntent {
  LoanIntent();
}

/// Represents an intent to check balance.
class CheckBalanceIntent extends SaabiIntent {
  CheckBalanceIntent();
}

/// Represents an intent to verify a receipt.
class VerifyReceiptIntent extends SaabiIntent {
  final String? imagePath;
  final String? query;
  VerifyReceiptIntent({this.imagePath, this.query});
}

/// Represents an unknown or unsupported intent.
class UnknownIntent extends SaabiIntent {
  final String originalText;
  UnknownIntent(this.originalText);
}
