// import 'package:kickin_utilities/kickin_utilities.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:saabi_mobile/shared/components/dialogs/app_dialog.dart';
// import 'package:saabi_mobile/shared/components/dialogs/src/loading_dialog.dart';

// class UiUtils {
//   /// Returns a [SystemUiOverlayStyle] based on the provided [theme].
//   static SystemUiOverlayStyle systemUiOverlayStyle(ThemeData theme) {
//     final brightness = theme.brightness == Brightness.dark ? Brightness.light : Brightness.dark;
//     return SystemUiOverlayStyle(
//       systemNavigationBarColor: theme.scaffoldBackgroundColor,
//       systemNavigationBarIconBrightness: brightness,
//       statusBarColor: theme.scaffoldBackgroundColor,
//       statusBarIconBrightness: brightness,
//     );
//   }

//   /// Shows a loading dialog.
//   static Future<void> showLoadingDialog(BuildContext context, {bool canPop = false}) =>
//       showAppDialog(context, builder: (context) => LoadingDialog(canPop: canPop));

//   static Future<void> showToast(BuildContext context, {required String messsage, bool? isError}) async {
//     toastification.dismissAll();
//     _showDefaultAppToast(context, isError, messsage);
//   }

//   static Future<void> showErrorToast(BuildContext context, {required String message}) =>
//       showToast(context, messsage: message, isError: true);

//   ///Enters fullscreen mode for video playback.
//   static void enterFullscreenForVideo() {
//     // Allow all orientations
//     SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
//   }

//   /// Sets the default UI orientation.
//   static void setDefaultUiOrientation() {
//     // Restrict to portrait up orientation
//     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//   }
// }

// /// Displays a default styled toast notification.
// void _showDefaultAppToast(BuildContext context, bool? isError, String messsage) {
//   toastification.show(
//     context: context,
//     icon: DecoratedBox(
//       decoration: BoxDecoration(
//         color: isError == true ? AppColors.red50 : AppColors.primaryColorB50,
//         border: Border.all(width: 0.7, color: isError == true ? AppColors.red200 : AppColors.primaryColorB100),
//         borderRadius: BorderRadius.circular(6),
//       ),
//       child: SizedBox.square(
//         dimension: 40,
//         child: Icon(
//           isError == true
//               ? IconsaxPlusLinear.danger
//               : (isError == false ? IconsaxPlusLinear.info_circle : IconsaxPlusLinear.tick_circle),
//           color: isError == true ? AppColors.red500 : AppColors.primaryColorA500,
//           size: 17,
//         ),
//       ),
//     ),
//     animationBuilder: (context, animation, alignment, child) {
//       return FadeTransition(
//         opacity: animation,
//         child: child.animate().scaleXY(begin: 0.9, end: 1.0, curve: KCurves.defaultIosSpring, duration: 700.inMs),
//       );
//     },
//     boxShadow: [
//       BoxShadow(
//         color: Colors.black.withValues(alpha: 0.05),
//         blurRadius: 32,
//         spreadRadius: -11,
//         offset: const Offset(0, 21.45),
//       ),
//       BoxShadow(
//         color: Colors.black.withValues(alpha: 0.1),
//         blurRadius: 80,
//         spreadRadius: -16,
//         offset: const Offset(0, 53.64),
//       ),
//     ],
//     borderSide: BorderSide(color: isError == true ? AppColors.red50 : AppColors.primaryColorA50, width: 1),
//     borderRadius: BorderRadius.circular(8),
//     animationDuration: 100.inMs,
//     autoCloseDuration: 2.inSeconds,
//     // duration: 10.inSeconds,
//     backgroundColor: AppColors.neutralWhite300,
//     // maxWidth: 328,
//     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 11),
//     alignment: Alignment.topCenter,
//     description: AppText(
//       messsage,
//       fontSize: 14,
//       fontWeight: FontWeight.w600,
//       color: isError == true ? AppColors.red900 : AppColors.primaryColorA900,
//     ),
//   );
// }
