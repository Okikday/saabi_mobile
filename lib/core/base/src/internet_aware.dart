// import 'dart:async';
// import 'package:flutter/foundation.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';

// mixin class InternetAwareMixin {
//   StreamSubscription<InternetConnectionStatus>? _subscription;
//   Timer? _offlineTimer;

//   bool _isOffline = false;
//   bool get isOffline => _isOffline;

//   /// Call in constructor
//   void startInternetListener({
//     Duration offlineDelay = const Duration(seconds: 5),
//     required VoidCallback onOfflineTimeout,
//     VoidCallback? onBackOnline,
//   }) {
//     _subscription = InternetConnectionChecker.instance.onStatusChange.listen((status) {
//       final hasInternet = status == InternetConnectionStatus.connected;

//       if (!hasInternet) {
//         _offlineTimer ??= Timer(offlineDelay, () {
//           _isOffline = true;
//           onOfflineTimeout();
//         });
//       } else {
//         _offlineTimer?.cancel();
//         _offlineTimer = null;

//         if (_isOffline) {
//           _isOffline = false;
//           onBackOnline?.call();
//         }
//       }
//     });
//   }

//   /// Call in dispose()
//   void disposeInternetListener() {
//     _offlineTimer?.cancel();
//     _subscription?.cancel();
//   }
// }
