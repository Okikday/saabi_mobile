import 'package:go_router/go_router.dart';
import 'package:saabi_mobile/features/settings/ui/screens/security_settings_view.dart';
import 'package:saabi_mobile/features/settings/ui/screens/pin_input_screen.dart';
import '../app_router.dart';

final securitySettingsRoute = GoRoute(
  path: Routes.securitySettings.path,
  name: Routes.securitySettings.name,
  builder: (context, state) => const SecuritySettingsView(),
);

final pinSetupRoute = GoRoute(
  path: Routes.pinSetup.path,
  name: Routes.pinSetup.name,
  builder: (context, state) => const PinInputScreen(mode: PinMode.setup),
);
