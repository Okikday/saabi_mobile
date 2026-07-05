/// Represents the structured intents that Saabi AI can trigger natively.
sealed class SaabiIntent {
  const SaabiIntent();
}

/// Represents an intent to send money to another Saabi/Nomba user.
class SendIntent extends SaabiIntent {
  final String? recipient;
  final double? amount;

  const SendIntent({this.recipient, this.amount});
}

/// Represents an intent to transfer money to a bank account.
class TransferIntent extends SaabiIntent {
  final String? bankCode;
  final String? accountNumber;
  final double? amount;

  const TransferIntent({this.bankCode, this.accountNumber, this.amount});
}

/// Represents an intent to query the user's credit score.
class CreditScoreIntent extends SaabiIntent {
  const CreditScoreIntent();
}

/// Represents an intent to create a new Savings Circle.
class CreateRoundIntent extends SaabiIntent {
  const CreateRoundIntent();
}

/// Represents an intent to check transaction history.
class TransactionHistoryIntent extends SaabiIntent {
  final DateTime? date;
  final String? query;
  const TransactionHistoryIntent({this.date, this.query});
}

/// Represents an intent to buy airtime.
class AirtimeIntent extends SaabiIntent {
  final String? phoneNumber;
  final double? amount;
  const AirtimeIntent({this.phoneNumber, this.amount});
}

/// Represents an intent to buy data.
class DataIntent extends SaabiIntent {
  final String? phoneNumber;
  const DataIntent({this.phoneNumber});
}

/// Represents an intent to pay bills.
class BillsIntent extends SaabiIntent {
  const BillsIntent();
}

/// Represents an intent to start an investment.
class InvestmentIntent extends SaabiIntent {
  const InvestmentIntent();
}

/// Represents an intent to request a loan.
class LoanIntent extends SaabiIntent {
  const LoanIntent();
}

/// Represents an intent to check balance.
class CheckBalanceIntent extends SaabiIntent {
  const CheckBalanceIntent();
}

/// Represents an intent to verify a receipt.
class VerifyReceiptIntent extends SaabiIntent {
  final String? imagePath;
  const VerifyReceiptIntent({this.imagePath});
}

/// Represents an unknown or unsupported intent.
class UnknownIntent extends SaabiIntent {
  final String originalText;
  const UnknownIntent(this.originalText);
}
