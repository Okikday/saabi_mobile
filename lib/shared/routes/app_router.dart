import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saabi_mobile/core/storage/hive/hive_keys.dart';
import 'package:saabi_mobile/shared/components/pages/error_page.dart';
import 'src/splash_route.dart';

export 'package:go_router/go_router.dart';

part 'routes.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final routes = [
  // Splash and Onboarding
  splashRoute.build(),
];

final appRouterProvider = Provider((ref) {
  // Always boot to splash; redirect logic there owns all navigation decisions
  final router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: Routes.splash.path,
    navigatorKey: rootNavigatorKey,
    errorBuilder: (context, state) => const ErrorPage(),
    routes: routes,
  );

  final lifecycleListener = AppLifecycleListener(
    onStateChange: (state) {
      // Only save when the OS truly backgrounds or kills the app.
      // Excluding .inactive; it fires transiently during system overlays and
      // in-app navigation on iOS, which would corrupt the stored route.
      if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
        final currentUrl = router.routerDelegate.currentConfiguration.uri.toString();

        if (currentUrl != '/' && currentUrl != Routes.splash.path) {
          HiveKeys.lastPausedRoute.set(currentUrl);
          log("Storing paused route: $currentUrl");
        }
      }
    },
  );
  ref.onDispose(lifecycleListener.dispose);
  return router;
});
