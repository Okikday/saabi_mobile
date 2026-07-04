import 'package:saabi_mobile/core/nlp/src/entity_extractor_service.dart';
import 'package:saabi_mobile/core/nlp/src/intent_classifier.dart';
import 'package:saabi_mobile/features/saabi/logic/saabi_intent.dart';

/// Glues together the pure-Dart intent classification and Google ML Kit entity extraction
/// to produce a fully populated [SaabiIntent].
class SaabiNlp {
  final _classifier = IntentClassifier();
  final _extractor = EntityExtractorService();

  /// Must be called before use (downloads ML Kit model if needed).
  Future<void> init() => _extractor.init();

  /// Parses raw user input into a structured [SaabiIntent].
  Future<SaabiIntent> parse(String rawText) async {
    // 1. Classify intent locally
    final match = _classifier.classify(rawText);

    if (match.type == IntentType.unknown) {
      return UnknownIntent(rawText);
    }

    // 2. Extract entities using ML Kit
    final entities = await _extractor.extract(rawText);

    // 3. Map to SaabiIntent
    return _mapToSaabiIntent(rawText, match.type, entities);
  }

  SaabiIntent _mapToSaabiIntent(String rawText, IntentType type, ExtractedEntities entities) {
    switch (type) {
      case IntentType.transfer:
        return TransferIntent(
          amount: entities.moneyAmount,
          accountNumber: entities.phoneNumber, // Often phone/account format overlap
        );
      case IntentType.send:
        return SendIntent(amount: entities.moneyAmount, recipient: entities.phoneNumber);
      case IntentType.creditScore:
        return const CreditScoreIntent();
      case IntentType.checkBalance:
        return const CheckBalanceIntent();
      case IntentType.transactionHistory:
        return TransactionHistoryIntent(date: entities.date);
      case IntentType.createRound:
        return const CreateRoundIntent();
      case IntentType.airtime:
        return AirtimeIntent(amount: entities.moneyAmount, phoneNumber: entities.phoneNumber);
      case IntentType.unknown:
        return UnknownIntent(rawText);
    }
  }

  void dispose() {
    _extractor.dispose();
  }
}
