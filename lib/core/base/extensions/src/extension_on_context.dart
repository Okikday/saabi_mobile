part of '../extensions.dart';

BuildContext? get usableContext => rootNavigatorKey.currentContext ?? rootNavigatorKey.currentState?.context;

extension BuildContextExtension on BuildContext {
  void rootPop() => NavUtils.popGlobal();
  OverlayState? get rootOverlayState => NavUtils.overlay;
  bool get isRootAvailable => NavUtils.isAvailable;
  BuildContext? get usableContext {
    if (mounted) return this;
    return (rootNavigatorKey.currentContext ?? rootNavigatorKey.currentState?.context);
  }
}
