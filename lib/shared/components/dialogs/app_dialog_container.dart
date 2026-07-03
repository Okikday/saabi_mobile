import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDialogContainer extends StatelessWidget {
  /// child can be Positioned
  final Widget child;
  final Alignment? alignment;

  final void Function()? onTapOutside;
  final bool canPop;
  final void Function(bool, dynamic)? onPop;
  final Color? backgroundColor;
  const AppDialogContainer({
    super.key,
    this.alignment,
    required this.child,
    this.onTapOutside,
    this.canPop = true,
    this.onPop,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: onPop,
      child: Stack(
        alignment: alignment ?? Alignment.center,
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned.fill(
            child: ColoredBox(
              color: backgroundColor ?? Colors.transparent,
              child: GestureDetector(
                onTap: () {
                  if (onTapOutside != null) {
                    onTapOutside!();
                  } else {
                    context.pop();
                  }
                },
                // child: SizedBox.expand(),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
