import 'package:flutter/material.dart';
import 'package:kickin_utilities/kickin_utilities.dart';
import 'package:saabi_mobile/shared/components/layout/app_padding.dart';
import 'package:saabi_mobile/shared/theme/src/app_colors.dart';

class AppBottomSheet extends StatelessWidget {
  final Widget? header;
  final Widget? leading;
  final Widget? title;
  final Widget? trailing;
  final Widget child;
  final bool applyHeaderPadding;
  // When set to true, adds bottom padding to avoid system intrusions
  final bool applyBottomPadding;
  final bool showDragHandle;

  // Only applied when [applyBottomPadding] is true
  final double? bottomPaddingHeight;
  const AppBottomSheet({
    super.key,
    this.header,
    this.leading,
    this.title,
    this.trailing,
    required this.child,
    this.applyHeaderPadding = true,
    this.applyBottomPadding = true,
    this.showDragHandle = false,
    this.bottomPaddingHeight,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      curve: KCurves.defaultIosSpring,
      duration: 400.inMs,
      reverseDuration: 200.inMs,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showDragHandle)
            SizedBox(
              height: 24,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: const ColoredBox(color: AppColors.neutralBlack300, child: SizedBox(width: 75, height: 4)),
                ),
              ),
            ),
          if (header != null)
            Padding(
              padding: applyHeaderPadding ? const EdgeInsets.symmetric(horizontal: 24) : EdgeInsets.zero,
              child: header!,
            )
          else
            Padding(
              padding: applyHeaderPadding ? const EdgeInsets.symmetric(horizontal: 24) : EdgeInsets.zero,
              child: Row(
                children: [
                  ?leading,
                  Expanded(child: title != null ? title! : const SizedBox()),
                  ?trailing,
                ],
              ),
            ),

          Flexible(child: child),
          if (applyBottomPadding)
            bottomPaddingHeight == null ? const BottomPadding() : BottomPadding(withHeight: bottomPaddingHeight),
        ],
      ),
    );
  }
}

Future<T?> showAppBottomSheet<T>(
  BuildContext context, {
  required Widget child,
  bool? enableDrag,
  double? scrollControlDisabledMaxHeightRatio,
  Color? backgroundColor,
}) {
  return showModalBottomSheet<T>(
    context: context,
    enableDrag: enableDrag ?? false,
    scrollControlDisabledMaxHeightRatio: scrollControlDisabledMaxHeightRatio ?? _calcScrollMaxHeight(context),
    sheetAnimationStyle: AnimationStyle(duration: 400.inMs, curve: KCurves.decelerate),
    shape: const RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.vertical(top: Radius.circular(20))),
    backgroundColor: backgroundColor ?? Colors.white,
    showDragHandle: false,
    builder: (context) => child,
  );
}

double _calcScrollMaxHeight(BuildContext context) {
  final deviceHeight = context.deviceHeight;
  final maxChildSize = ((deviceHeight - context.topPadding - 4) / deviceHeight).clamp(0.0, 0.99);
  return maxChildSize;
}
