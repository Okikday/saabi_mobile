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
    // Basic regex to extract purpose/description from phrases like "for dinner" or "for rent"
    String? extractDescription(String text) {
      final forMatch = RegExp(r'\bfor\s+(?:the\s+)?(.+)', caseSensitive: false).firstMatch(text);
      if (forMatch != null) {
        return forMatch.group(1)?.trim();
      }
      return null;
    }
    
    // Basic regex to extract queries from phrases like "receipt for the [xyz] payment"
    String? extractReceiptQuery(String text) {
      final receiptMatch = RegExp(r'\breceipt\s+for\s+(?:the\s+)?(.+)', caseSensitive: false).firstMatch(text);
      if (receiptMatch != null) {
        // remove trailing "payment" if it exists
        return receiptMatch.group(1)?.replaceAll(RegExp(r'\bpayment\b', caseSensitive: false), '').trim();
      }
      return extractDescription(text);
    }

    final description = extractDescription(rawText);

    switch (type) {
      case IntentType.transfer:
        return TransferIntent(
          amount: entities.moneyAmount,
          accountNumber: entities.phoneNumber, // Often phone/account format overlap
          description: description,
        );
      case IntentType.send:
        return SendIntent(amount: entities.moneyAmount, recipient: entities.phoneNumber, description: description);
      case IntentType.creditScore:
        return CreditScoreIntent();
      case IntentType.checkBalance:
        return CheckBalanceIntent();
      case IntentType.transactionHistory:
        return TransactionHistoryIntent(date: entities.date);
      case IntentType.createRound:
        return CreateRoundIntent();
      case IntentType.airtime:
        return AirtimeIntent(amount: entities.moneyAmount, phoneNumber: entities.phoneNumber);
      case IntentType.verifyReceipt:
        return VerifyReceiptIntent(query: extractReceiptQuery(rawText));
      case IntentType.unknown:
        return UnknownIntent(rawText);
    }
  }

  void dispose() {
    _extractor.dispose();
  }
}
