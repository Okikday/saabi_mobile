import 'package:kickin_storage/kickin_storage.dart';

enum HiveKeys<T> { isSignedIn<bool>(), lastPausedRoute<String>(), themeMode<bool>(), balanceHidden<bool>() }

extension HiveKeysExtension<T> on HiveKeys<T> {
  T get() => KHive.on.app.getData(key: name);
  Future<void> set(T value) => KHive.on.app.setData(key: name, value: value);
}
