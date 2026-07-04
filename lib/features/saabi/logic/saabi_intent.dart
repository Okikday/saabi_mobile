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
  const TransactionHistoryIntent({this.date});
}

/// Represents an intent to buy airtime/data.
class AirtimeIntent extends SaabiIntent {
  final String? phoneNumber;
  final double? amount;
  const AirtimeIntent({this.phoneNumber, this.amount});
}

/// Represents an intent to check balance.
class CheckBalanceIntent extends SaabiIntent {
  const CheckBalanceIntent();
}

/// Represents an unknown or unsupported intent.
class UnknownIntent extends SaabiIntent {
  final String originalText;
  const UnknownIntent(this.originalText);
}
