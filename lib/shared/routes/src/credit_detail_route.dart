import 'package:saabi_mobile/features/credit_details/ui/screens/credit_detail_view.dart';
import 'package:saabi_mobile/shared/routes/auto_route.dart';
import 'package:saabi_mobile/shared/routes/app_router.dart';

final creditDetailRoute = AutoRoute.route(Routes.creditDetail, builder: (context, state) => const CreditDetailView());
