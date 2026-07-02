import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'routes.dart';
import 'src/splash_route.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class RouteManager {
  static final GoRouter mainRouter = _router;

  static final GoRouter _router = GoRouter(
    initialLocation: Routes.splash.path,
    navigatorKey: rootNavigatorKey,
    routes: [splashRoute.build()],
    // observers: [HeroineController()],
    debugLogDiagnostics: true,
    onException: (context, state, exception) {
      Routes.splash.go(context);
    },
  );
}
