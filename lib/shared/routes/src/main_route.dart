import 'package:saabi_mobile/features/main/providers/main_pod.dart';
import 'package:saabi_mobile/features/main/ui/screens/main_screen.dart';
import 'package:saabi_mobile/shared/routes/auto_route.dart';

const _mainScreen = MainScreen();
final mainRoute = AutoRoute.shell(
  builder: (context, state, child) => child,
  routes: [
    .route(
      .main,
      overrider: (_, state, [extra, id]) => [MainPod.me.overrideWith(() => .create(0))],
      builder: (context, state) => _mainScreen,
    ),
    .route(
      .homeTab,
      overrider: (_, state, [extra, id]) => [MainPod.me.overrideWith(() => .create(0))],
      builder: (context, state) => _mainScreen,
    ),
    .route(
      .saabiTab,
      overrider: (_, state, [extra, id]) => [MainPod.me.overrideWith(() => .create(1))],
      builder: (context, state) => _mainScreen,
    ),
  ],
);
