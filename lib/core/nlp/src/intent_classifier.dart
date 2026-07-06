import 'package:saabi_mobile/core/nlp/src/levenshtein.dart';

/// The type of intent that was classified from user input.
enum IntentType {
  transfer,
  send,
  creditScore,
  checkBalance,
  transactionHistory,
  createRound,
  airtime,
  verifyReceipt,
  unknown,
}

/// Result of intent classification — the matched type and a confidence indicator.
class IntentMatch {
  final IntentType type;

  /// How confident the match is (0.0–1.0). 1.0 = exact keyword, lower = fuzzy.
  final double confidence;

  const IntentMatch(this.type, this.confidence);
  const IntentMatch.unknown() : type = IntentType.unknown, confidence = 0.0;
}

/// Pure-Dart, zero-dependency intent classifier.
///
/// Uses keyword matching with Levenshtein fuzzy tolerance to map
/// natural language input to a known set of [IntentType]s.
class IntentClassifier {
  // ──────────────────────────────────────────────────────────────
  // Pattern table: each intent has a list of trigger keywords/phrases
  // ──────────────────────────────────────────────────────────────
  static const _patterns = <IntentType, List<String>>{
    IntentType.transfer: [
      'transfer',
      'bank transfer',
      'send to bank',
      'pay to bank',
      'wire',
    ],
    IntentType.send: [
      'send',
      'pay',
      'give',
      'dash',
      'send money',
      'pay money',
    ],
    IntentType.creditScore: [
      'credit score',
      'credit',
      'score',
      'my score',
      'check credit',
      'credit rating',
    ],
    IntentType.checkBalance: [
      'balance',
      'check balance',
      'how much',
      'my balance',
      'account balance',
      'what is my balance',
    ],
    IntentType.transactionHistory: [
      'transactions',
      'history',
      'transaction history',
      'show transactions',
      'show history',
      'pull up',
      'recent transactions',
    ],
    IntentType.createRound: [
      'create circle',
      'new circle',
      'start ajo',
      'create ajo',
      'start circle',
      'new ajo',
      'create round',
      'start esusu',
    ],
    IntentType.airtime: [
      'airtime',
      'buy airtime',
      'recharge',
      'top up',
      'topup',
      'buy data',
      'data bundle',
    ],
    IntentType.verifyReceipt: [
      'receipt',
      'share receipt',
      'payment proof',
      'proof of payment',
      'show receipt',
      'verify receipt',
    ],
  };

  /// Classify user input into an [IntentMatch].
  ///
  /// First tries exact substring matching (confidence 1.0),
  /// then falls back to fuzzy matching per-word (confidence 0.7).
  IntentMatch classify(String raw) {
    final normalized = _normalize(raw);
    if (normalized.isEmpty) return const IntentMatch.unknown();

    // Phase 1: Exact substring match (full phrases first)
    for (final entry in _patterns.entries) {
      for (final keyword in entry.value) {
        if (normalized.contains(keyword)) {
          return IntentMatch(entry.key, 1.0);
        }
      }
    }

    // Phase 2: Fuzzy per-word match
    final words = normalized.split(RegExp(r'\s+'));
    for (final entry in _patterns.entries) {
      for (final keyword in entry.value) {
        // Only fuzzy-match single keywords (not multi-word phrases)
        if (keyword.contains(' ')) continue;
        for (final word in words) {
          if (word.length >= 3 && fuzzyMatch(word, keyword, maxDistance: 2)) {
            return IntentMatch(entry.key, 0.7);
          }
        }
      }
    }

    return const IntentMatch.unknown();
  }

  /// Normalizes input: lowercase, strip extra whitespace.
  String _normalize(String raw) {
    return raw.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}
