// import 'package:flutter/material.dart';
// import 'package:saabi_mobile/core/constants/constants.dart';
// import 'package:saabi_mobile/shared/components/buttons/app_button.dart';
// import 'package:saabi_mobile/shared/components/dialogs/app_dialog.dart';

// class AppAlertDialog extends StatelessWidget {
//   final String title;
//   final String content;
//   final Widget? contentWidget;
//   final IconData? leadingIcon;
//   final List<Widget> actions;
//   final void Function()? onCancel;
//   final void Function()? onConfirm;
//   final String? cancelLabel;
//   final String? confirmLabel;
//   final bool canPop;
//   final Color? backgroundColor;
//   final bool isDestructive;

//   const AppAlertDialog({
//     super.key,
//     required this.title,
//     required this.content,
//     this.contentWidget,
//     this.canPop = true,
//     this.actions = const [],
//     required this.onCancel,
//     this.onConfirm,
//     this.backgroundColor,
//     this.leadingIcon,
//     this.isDestructive = false,
//     this.cancelLabel,
//     this.confirmLabel,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AppDialog(
//       canPop: canPop,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (leadingIcon != null)
//             DecoratedBox(
//               decoration: BoxDecoration(
//                 color: isDestructive ? AppColors.red50 : AppColors.primaryColorA50,
//                 borderRadius: BorderRadius.circular(50),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Icon(
//                   leadingIcon,
//                   size: 32,
//                   color: isDestructive ? AppColors.red500 : AppColors.primaryColorA500,
//                 ),
//               ),
//             ),

//           if (leadingIcon != null) 8.inColumn,

//           AppText(
//             title,
//             fontWeight: FontWeight.w700,
//             fontSize: 14,
//             color: isDestructive ? AppColors.red500 : Colors.black,
//           ),

//           8.inColumn,

//           contentWidget ?? AppText(content, fontSize: 12, color: Colors.black, fontWeight: FontWeight.w600),

//           24.inColumn,

//           Row(
//             spacing: 24.0,
//             children: [
//               ...actions.map((e) => Flexible(child: e)),
//               if (actions.isEmpty)
//                 ...[
//                   if (onCancel != null)
//                     AppButton(
//                       size: const Size.fromHeight(44),
//                       label: cancelLabel ?? "Cancel",
//                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                       labelColor: AppColors.neutralWhite300,
//                       color: isDestructive ? AppColors.red400 : AppColors.primaryColorB600,
//                       overlayColor: isDestructive ? AppColors.red600 : null,
//                       borderRadius: 100,
//                       onPressed: () {
//                         if (onCancel != null) onCancel!();
//                       },
//                     ),
//                   AppButton(
//                     size: const Size.fromHeight(44),
//                     label: confirmLabel ?? "Confirm",
//                     labelSize: 12,
//                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                     color: isDestructive ? AppColors.red50 : AppColors.primaryColorA50,
//                     labelColor: isDestructive ? AppColors.red500 : AppColors.primaryColorA500,
//                     borderRadius: 100,
//                     overlayColor: isDestructive ? AppColors.red100 : null,
//                     onPressed: () {
//                       if (onConfirm != null) onConfirm!();
//                     },
//                   ),
//                 ].map((e) => Flexible(child: e)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
