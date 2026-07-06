import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:saabi_mobile/features/settings/providers/security_pod.dart';
import 'package:hugeicons_pro/hugeicons.dart';

enum PinMode { setup, verify }

class PinInputScreen extends ConsumerStatefulWidget {
  final PinMode mode;
  final VoidCallback? onSuccess;

  const PinInputScreen({super.key, required this.mode, this.onSuccess});

  @override
  ConsumerState<PinInputScreen> createState() => _PinInputScreenState();
}

class _PinInputScreenState extends ConsumerState<PinInputScreen> {
  String _pin = '';
  String _confirmPin = '';
  bool _isConfirming = false;
  bool _hasError = false;

  void _onKeyPress(String key) {
    if (_hasError) {
      setState(() => _hasError = false);
    }

    if (_pin.length < 4) {
      setState(() {
        _pin += key;
      });

      if (_pin.length == 4) {
        _handlePinComplete();
      }
    }
  }

  void _onBackspace() {
    if (_hasError) {
      setState(() => _hasError = false);
    }

    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  void _handlePinComplete() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      if (widget.mode == PinMode.setup) {
        if (!_isConfirming) {
          // Move to confirm step
          setState(() {
            _confirmPin = _pin;
            _pin = '';
            _isConfirming = true;
          });
        } else {
          if (_pin == _confirmPin) {
            // Success
            ref.read(securityProvider.notifier).setPin(_pin);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PIN Setup Successful')));
            if (widget.onSuccess != null) {
              widget.onSuccess!();
            } else {
              context.pop();
            }
          } else {
            // Mismatch
            setState(() {
              _hasError = true;
              _pin = '';
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: const Text('PINs do not match'), backgroundColor: context.theme.colors.destructive),
            );
          }
        }
      } else {
        // Verification Mode
        final cachedPin = ref.read(securityProvider).cachedPin;
        if (_pin == cachedPin) {
          if (widget.onSuccess != null) {
            widget.onSuccess!();
          } else {
            context.pop(true);
          }
        } else {
          setState(() {
            _hasError = true;
            _pin = '';
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text('Incorrect PIN'), backgroundColor: context.theme.colors.destructive),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.mode == PinMode.setup
        ? (_isConfirming ? 'Confirm your PIN' : 'Create a 4-digit PIN')
        : 'Enter your PIN';

    return FScaffold(
      header: FHeader.nested(
        title: const Text(''),
        prefixes: [FHeaderAction.back(onPress: () => context.pop())],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),
            Icon(HugeIconsStroke.lockKey, size: 48, color: context.theme.colors.primary),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: context.theme.colors.foreground),
            ),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                bool isFilled = index < _pin.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFilled ? context.theme.colors.primary : Colors.transparent,
                    border: Border.all(
                      color: _hasError
                          ? context.theme.colors.destructive
                          : isFilled
                          ? context.theme.colors.primary
                          : context.theme.colors.border,
                      width: 2,
                    ),
                  ),
                );
              }),
            ),
            _buildNumpad(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildNumpad() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [_buildKey('1'), _buildKey('2'), _buildKey('3')],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [_buildKey('4'), _buildKey('5'), _buildKey('6')],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [_buildKey('7'), _buildKey('8'), _buildKey('9')],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (widget.mode == PinMode.verify && ref.read(securityProvider).isBiometricsEnabled)
                _buildBiometricKey()
              else
                const SizedBox(width: 72),
              _buildKey('0'),
              _buildBackspaceKey(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKey(String value) {
    return Expanded(
      child: FButton(
        onPress: () => _onKeyPress(value),
        variant: .ghost,
        child: Container(
          width: 72,
          height: 72,
          alignment: Alignment.center,
          child: Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w500, color: context.theme.colors.foreground),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceKey() {
    return FButton(
      onPress: _onBackspace,
      child: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        child: Icon(HugeIconsStroke.cancel01, size: 28, color: context.theme.colors.foreground),
      ),
    );
  }

  Widget _buildBiometricKey() {
    return FButton(
      onPress: () async {
        final success = await ref.read(securityProvider.notifier).authenticateWithBiometrics('Verify to continue');
        if (success) {
          if (widget.onSuccess != null) {
            widget.onSuccess!();
          } else {
            if (mounted) context.pop(true);
          }
        }
      },
      child: Container(
        width: 72,
        height: 72,
        alignment: Alignment.center,
        child: Icon(Icons.fingerprint, size: 32, color: context.theme.colors.primary),
      ),
    );
  }
}
