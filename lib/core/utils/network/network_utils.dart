// import 'package:flutter/widgets.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:scholar_ark/core/utils/ui_utils.dart';

// class NetworkUtils {
//   static Future<bool> isConnected() async {
//     final internet = await InternetConnectionChecker.instance.connectionStatus;
//     return !(internet == InternetConnectionStatus.disconnected);
//   }

//   static Future<void> checkInternetAndShowToast(BuildContext context) async {
//     if (await isConnected()) return;
//     if (context.mounted) {
//       UiUtils.showErrorToast(
//         context,
//         messsage: "You are not connected. Try turning on Mobile data or connecting to a Wifi",
//       );
//     }
//   }

//   static Future<void> persistentInternetConnectionChecker({
//     required Function onConnected,
//     required Function onDisconnected,
//   }) async {
//     InternetConnectionChecker.instance.onStatusChange.listen((status) {
//       final isConnected = status == InternetConnectionStatus.connected;
//       if (isConnected) {
//         onConnected();
//       } else {
//         onDisconnected();
//       }
//     });
//   }
// }
