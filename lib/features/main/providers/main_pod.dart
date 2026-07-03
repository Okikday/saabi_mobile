import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:saabi_mobile/features/main/providers/main_state.dart';

final _mainProvider = NotifierProvider(
  () => MainPod.create(),
  name: 'MainPod',
);

/// Manages the main shell state — active tab index and initialization.
class MainPod extends Notifier<MainState> {
  static final me = _mainProvider;

  MainPod.create();

  @override
  MainState build() => MainState();

  /// Updates the active tab index (no-op if already at [value]).
  void setTabIndex(int value) {
    if (state.tabIndex == value) return;
    state = state.copyWith(tabIndex: value);
  }

  /// Sets the loading flag (no-op if already at [value]).
  void setLoading(bool value) {
    if (state.isLoading == value) return;
    state = state.copyWith(isLoading: value);
  }

  /// Marks initialization as complete (no-op if already initialized).
  void setInitialized(bool value) {
    if (state.hasInitialized == value) return;
    state = state.copyWith(hasInitialized: value);
  }
}
