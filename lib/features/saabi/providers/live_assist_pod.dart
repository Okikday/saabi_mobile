import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saabi_mobile/core/storage/hive/hive_keys.dart';

class LiveAssistState {
  final bool isEnabled;
  final bool isOfflineOnly;
  final bool isListening;

  const LiveAssistState({
    this.isEnabled = false,
    this.isOfflineOnly = false,
    this.isListening = false,
  });

  LiveAssistState copyWith({
    bool? isEnabled,
    bool? isOfflineOnly,
    bool? isListening,
  }) {
    return LiveAssistState(
      isEnabled: isEnabled ?? this.isEnabled,
      isOfflineOnly: isOfflineOnly ?? this.isOfflineOnly,
      isListening: isListening ?? this.isListening,
    );
  }
}

class LiveAssistPod extends Notifier<LiveAssistState> {
  @override
  LiveAssistState build() {
    return LiveAssistState(
      isEnabled: HiveKeys.liveAssistEnabled.get() ?? false,
      isOfflineOnly: HiveKeys.liveAssistOffline.get() ?? false,
    );
  }

  void toggleEnabled(bool value) {
    HiveKeys.liveAssistEnabled.set(value);
    state = state.copyWith(isEnabled: value);
  }

  void toggleOfflineOnly(bool value) {
    HiveKeys.liveAssistOffline.set(value);
    state = state.copyWith(isOfflineOnly: value);
  }

  void startListening() {
    state = state.copyWith(isListening: true);
    // TODO: Implement actual speech recognition start here
    Future.delayed(const Duration(seconds: 3), () {
      stopListening();
    });
  }

  void stopListening() {
    state = state.copyWith(isListening: false);
    // TODO: Implement actual speech recognition stop here
  }
}

final liveAssistProvider = NotifierProvider<LiveAssistPod, LiveAssistState>(
  LiveAssistPod.new,
);
