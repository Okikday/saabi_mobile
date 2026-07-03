import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

/// Generates a placeholder provider that must be overridden in a ProviderScope.
Provider<T> createPlaceholderProvider<T>([String? name]) {
  return Provider<T>((ref) {
    throw UnimplementedError(
      name != null
          ? 'The provider [$name] was not overridden in a ProviderScope!'
          : 'A placeholder Provider<$T> was not overridden in a ProviderScope!',
    );
  });
}

Provider<T> createAutoDisposeProvider<T>(String name, {required T value, Iterable<ProviderOrFamily>? dependencies}) =>
    Provider.autoDispose((ref) => value, dependencies: dependencies);

Provider<String> createAutoDisposeStringProvider(
  String name, {
  String defaultValue = "",
  Iterable<ProviderOrFamily>? dependencies,
}) => Provider.autoDispose((ref) => defaultValue, dependencies: dependencies);
