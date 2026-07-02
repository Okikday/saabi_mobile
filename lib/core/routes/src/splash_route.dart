import 'package:saabi_mobile/core/routes/auto_route.dart';
import 'package:saabi_mobile/features/splash.dart';
import '../routes.dart';

final splashRoute = AutoRoute.route(
  Routes.splash,
  builder: (context, state) => const Splash(),
  // redirect: (context, state) {
  //   log("trying to redirect on splash");

  //   SchedulerBinding.instance.addPostFrameCallback((_) async {
  //     // 1. Delay for 450ms
  //     await 600.inMilliseconds.delay();

  //     // After an async gap the redirect's original context is detached and no
  //     // longer carries a GoRouter ancestor. rootNavigatorKey.currentContext is
  //     // always the live navigator context and is safe to use after any await.
  //     final ctx = rootNavigatorKey.currentContext!;

  //     // 2. Auth is the top gate — unauthenticated users never reach a resume route
  //     if (!AuthSession.instance.isUserSignedIn()) {
  //       log("User is not signed in");
  //       // Discard any stored route — it would point to a protected screen
  //       SharedPrefKeys.lastPausedRoute.remove();
  //       ((SharedPrefKeys.seenOnboardingScreens.get() ?? false) ? Routes.signIn : Routes.onboarding).go(ctx);
  //       return;
  //     }

  //     // 3. Signed in: resume where the user left off (backgrounded / killed by OS)
  //     final resumeRoute = SharedPrefKeys.lastPausedRoute.get();
  //     if (resumeRoute != null) {
  //       log("Resuming paused route: $resumeRoute");
  //       SharedPrefKeys.lastPausedRoute.remove();
  //       ctx.go(resumeRoute);
  //       return;
  //     }

  //     // 4. Signed in, no resume route → go to main
  //     log("User is signed in");
  //     Routes.main.go(ctx);
  //   });
  //   return null;
  // },
);
