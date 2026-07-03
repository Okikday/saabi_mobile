// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:scholar_ark/core/constants/constants.dart';
// import 'package:scholar_ark/shared/components/dialogs/app_dialog.dart';
// import 'package:scholar_ark/shared/components/indicators/app_circular_loading_indicator.dart';
// import 'package:scholar_ark/shared/components/layout/app_text.dart';

// import 'package:kickin_utilities/kickin_utilities.dart';

// import 'package:scholar_ark/shared/theme/src/app_colors.dart';

// class ResultDialog extends StatelessWidget {
//   final String asset;
//   // If set, iconData would be applied instead
//   final IconData? icon;
//   final String title;
//   final String description;

//   final Widget? trailing;

//   /// Make sure to pop if set to true
//   final bool canPop;
//   final bool isError;
//   const ResultDialog({
//     super.key,
//     required this.asset,
//     required this.title,
//     required this.description,
//     this.icon,
//     this.canPop = false,
//     this.trailing = const AppCircularLoadingIndicator(),
//     this.isError = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final textTheme = context.theme.textTheme;
//     return AppDialog(
//       canPop: false,
//       onTapOutside: canPop ? null : () {},
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Builder(
//                 builder: (context) {
//                   final widget = (icon != null
//                       ? Icon(icon, color: isError ? AppColors.red400 : AppColors.primaryColorB600, size: 56)
//                       : asset.toLowerCase().endsWith("svg")
//                       ? SvgPicture.asset(asset)
//                       : Image.asset(asset));
//                   if (isError) return widget.animate().shake(duration: 1.inSeconds);
//                   return widget;
//                 },
//               ),
//               Spacing.md.inColumn,
//               AppText(
//                 title,
//                 textAlign: TextAlign.center,
//                 style: textTheme.titleSmall?.copyWith(
//                   fontWeight: FontWeight.w700,
//                   color: isError ? AppColors.red700 : AppColors.primaryColorA600,
//                 ),
//               ),
//               20.0.inColumn,
//               AppText(
//                 description,
//                 textAlign: TextAlign.center,
//                 style: textTheme.labelSmall?.copyWith(color: AppColors.red900),
//               ),
//               Spacing.xl.inColumn,

//               ?trailing,
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
