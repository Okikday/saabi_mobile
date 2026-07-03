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
