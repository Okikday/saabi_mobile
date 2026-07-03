import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saabi_mobile/core/base/src/custom_notifiers.dart';
import 'package:saabi_mobile/core/storage/hive/hive_keys.dart';

/// Provider for the theme mode. Uses [KCachedNotifier] to automatically
/// persist the state using the [HiveKeys.themeMode] key.
/// True = Dark Mode, False = Light Mode.
final themeModeProvider = AsyncNotifierProvider<KCachedNotifier<bool, bool>, bool>(
  () => KCachedNotifier<bool, bool>(
    HiveKeys.themeMode.name,
    true, // Default to true (dark mode)
  ),
);
