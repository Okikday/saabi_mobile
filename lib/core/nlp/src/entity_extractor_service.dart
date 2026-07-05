import 'dart:developer';
import 'dart:io';

import 'package:google_mlkit_entity_extraction/google_mlkit_entity_extraction.dart';

/// Container for extracted entities from user text.
class ExtractedEntities {
  final double? moneyAmount;
  final String? phoneNumber;
  final DateTime? date;

  const ExtractedEntities({this.moneyAmount, this.phoneNumber, this.date});

  @override
  String toString() =>
      'ExtractedEntities(money: $moneyAmount, phone: $phoneNumber, date: $date)';
}

/// Service that wraps Google ML Kit Entity Extraction.
class EntityExtractorService {
  late final EntityExtractor _extractor;
  final EntityExtractorModelManager _modelManager = EntityExtractorModelManager();
  bool _isInitialized = false;
  bool _initFailed = false;

  /// Ensures the English model is downloaded and initializes the extractor.
  Future<void> init() async {
    if (_isInitialized || _initFailed) return;
    
    if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      log('ML Kit is not supported on desktop platforms. Bypassing EntityExtractor initialization.');
      _isInitialized = true;
      return;
    }
    
    try {
      final modelName = EntityExtractorLanguage.english.name;
      final isDownloaded = await _modelManager.isModelDownloaded(modelName);
      if (!isDownloaded) {
        log('Downloading ML Kit entity extraction model...');
        await _modelManager.downloadModel(modelName);
      }
      _extractor = EntityExtractor(language: EntityExtractorLanguage.english);
      _isInitialized = true;
    } catch (e, st) {
      log('Failed to initialize EntityExtractorService: $e', stackTrace: st);
      _initFailed = true; // Prevents retrying on every prompt
    }
  }

  /// Extracts entities (money, phone, date) from [text].
  Future<ExtractedEntities> extract(String text) async {
    if (!_isInitialized && !_initFailed) {
      log('EntityExtractorService not initialized, calling init()...');
      await init();
    }

    if (!_isInitialized) {
      return const ExtractedEntities();
    }

    if (Platform.isMacOS || Platform.isWindows || Platform.isLinux || _initFailed) {
      // Lightweight regex fallback for desktop testing
      double? money;
      String? phone;

      // Extract 10-digit account/phone numbers, possibly prefixed by "to "
      final toAccountMatch = RegExp(r'to\s+(\d{10})', caseSensitive: false).firstMatch(text);
      if (toAccountMatch != null) {
        phone = toAccountMatch.group(1);
      } else {
        final accountMatch = RegExp(r'\b(\d{10})\b').firstMatch(text);
        if (accountMatch != null) {
          phone = accountMatch.group(1);
        }
      }

      // Extract amount: find a number that isn't the phone/account number we just found
      final allNumbers = RegExp(r'\b\d+(?:\.\d+)?\b').allMatches(text);
      for (final match in allNumbers) {
        final val = match.group(0);
        if (val != null && val != phone) {
          money = double.tryParse(val);
          if (money != null) break;
        }
      }

      return ExtractedEntities(moneyAmount: money, phoneNumber: phone, date: null);
    }

    try {
      final annotations = await _extractor.annotateText(text);

      double? money;
      String? phone;
      DateTime? date;

      for (final annotation in annotations) {
        for (final entity in annotation.entities) {
          if (entity is MoneyEntity && money == null) {
            try {
              money = double.tryParse(entity.unnormalizedCurrency) ?? double.tryParse(entity.rawValue);
            } catch (_) {
               // Fallback if needed
            }
          } else if (entity is PhoneEntity && phone == null) {
            phone = entity.rawValue;
          } else if (entity is DateTimeEntity && date == null) {
             date = DateTime.fromMillisecondsSinceEpoch(entity.timestamp);
          }
        }
      }

      return ExtractedEntities(moneyAmount: money, phoneNumber: phone, date: date);
    } catch (e, st) {
      log('Error during entity extraction: $e', stackTrace: st);
      return const ExtractedEntities();
    }
  }

  void dispose() {
    if (_isInitialized) {
      _extractor.close();
    }
  }
}
