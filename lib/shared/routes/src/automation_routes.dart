import 'package:go_router/go_router.dart';
import 'package:saabi_mobile/features/settings/ui/screens/automations_view.dart';
import '../app_router.dart';

final automationsViewRoute = GoRoute(
  path: Routes.automationsView.path,
  name: Routes.automationsView.name,
  builder: (context, state) => const AutomationsView(),
);
