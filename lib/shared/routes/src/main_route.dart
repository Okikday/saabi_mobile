import 'package:saabi_mobile/features/main/ui/screens/main_screen.dart';
import 'package:saabi_mobile/shared/routes/auto_route.dart';
import 'package:saabi_mobile/shared/routes/app_router.dart';

/// Main route for the application.
/// It uses a standard route to the MainScreen which internally manages tabs.
final mainRoute = AutoRoute.route(Routes.main, builder: (context, state) => const MainScreen());
