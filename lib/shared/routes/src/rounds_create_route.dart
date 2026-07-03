import 'package:saabi_mobile/features/rounds/ui/screens/create_round_view.dart';
import 'package:saabi_mobile/shared/routes/app_router.dart';

class RoundsCreateRoute {
  GoRoute build() {
    return GoRoute(
      path: Routes.roundsCreate.path,
      name: Routes.roundsCreate.name,
      builder: (context, state) => const CreateRoundView(),
    );
  }
}

final roundsCreateRoute = RoundsCreateRoute();
