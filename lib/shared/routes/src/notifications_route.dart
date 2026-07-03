import 'package:saabi_mobile/features/notifications/ui/screens/notifications_view.dart';
import 'package:saabi_mobile/shared/routes/auto_route.dart';
import 'package:saabi_mobile/shared/routes/app_router.dart';

final notificationsRoute = AutoRoute.route(
  Routes.notifications,
  builder: (context, state) => const NotificationsView(),
);
