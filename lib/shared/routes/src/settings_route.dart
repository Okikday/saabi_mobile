import 'package:saabi_mobile/features/settings/ui/screens/settings_view.dart';
import 'package:saabi_mobile/shared/routes/auto_route.dart';
import 'package:saabi_mobile/shared/routes/app_router.dart';

final settingsRoute = AutoRoute.route(
  Routes.settings,
  builder: (context, state) => const SettingsView(),
);
