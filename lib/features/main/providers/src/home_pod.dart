import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saabi_mobile/core/base/src/custom_notifiers.dart';
import 'package:saabi_mobile/core/storage/hive/hive_keys.dart';

/// Persists whether the home balance is hidden across sessions.
/// True = hidden, False = visible.
final balanceHiddenProvider = AsyncNotifierProvider<KCachedNotifier<bool, bool>, bool>(
  () => KCachedNotifier<bool, bool>(
    HiveKeys.balanceHidden.name,
    false, // Default: visible
  ),
);
