import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:saabi_mobile/core/storage/hive/hive_keys.dart';

class SecurityState {
  final bool isPinEnabled;
  final String? cachedPin;
  final bool isBiometricsEnabled;
  final bool isBiometricsSupported;

  const SecurityState({
    this.isPinEnabled = false,
    this.cachedPin,
    this.isBiometricsEnabled = false,
    this.isBiometricsSupported = false,
  });

  SecurityState copyWith({
    bool? isPinEnabled,
    String? cachedPin,
    bool? isBiometricsEnabled,
    bool? isBiometricsSupported,
  }) {
    return SecurityState(
      isPinEnabled: isPinEnabled ?? this.isPinEnabled,
      cachedPin: cachedPin ?? this.cachedPin,
      isBiometricsEnabled: isBiometricsEnabled ?? this.isBiometricsEnabled,
      isBiometricsSupported: isBiometricsSupported ?? this.isBiometricsSupported,
    );
  }
}

class SecurityPod extends Notifier<SecurityState> {
  final LocalAuthentication _auth = LocalAuthentication();

  @override
  SecurityState build() {
    _init();
    return const SecurityState();
  }

  Future<void> _init() async {
    // We should use secure storage for the pin in production, but for now we'll mock it or use Hive if not critical.
    // For this prototype, we just store it in memory or Hive. Let's use a mocked HiveKey or memory.
    // We'll mock the persisted values for the prototype.
    final bool canCheckBiometrics = await _auth.canCheckBiometrics;
    final bool isSupported = canCheckBiometrics || await _auth.isDeviceSupported();

    // In a real app we'd load this from secure storage.
    state = state.copyWith(isBiometricsSupported: isSupported);
  }

  void setPin(String pin) {
    state = state.copyWith(isPinEnabled: true, cachedPin: pin);
  }

  void removePin() {
    state = state.copyWith(isPinEnabled: false, cachedPin: null, isBiometricsEnabled: false);
  }

  void setBiometricsEnabled(bool enabled) {
    if (state.isPinEnabled) {
      state = state.copyWith(isBiometricsEnabled: enabled);
    }
  }

  Future<bool> authenticateWithBiometrics(String reason) async {
    if (!state.isBiometricsSupported || !state.isBiometricsEnabled) return false;

    try {
      final authenticated = await _auth.authenticate(
        localizedReason: reason,
      );
      return authenticated;
    } catch (e) {
      return false;
    }
  }
}

final securityProvider = NotifierProvider<SecurityPod, SecurityState>(SecurityPod.new);
