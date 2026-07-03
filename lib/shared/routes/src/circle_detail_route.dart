import 'package:saabi_mobile/features/rounds/ui/screens/circle_detail_view.dart';
import 'package:saabi_mobile/shared/routes/app_router.dart';

class CircleDetailRoute {
  GoRoute build() {
    return GoRoute(
      path: Routes.circleDetail.path,
      name: Routes.circleDetail.name,
      builder: (context, state) => const CircleDetailView(),
    );
  }
}

final circleDetailRoute = CircleDetailRoute();
