part of 'app_router.dart';

/// pattern
/// Route - extra: Arg
/// Path follows subPath
///
enum Routes<In, Out> {
  splash,

  onboarding,
  
  // Main screen with PageView tabs
  main,

  // Feature detail screens
  creditDetail,
  settings,
  roundsCreate,
  circleDetail,

  // ============================================================================
  // MISC
  // ============================================================================
  emptyState,
  testScreen;

  String get path => name.withSlashPrefix;
  String get subPath => name;

  Future<Out?> push(BuildContext context, {In? extra, String? id}) =>
      context.pushNamed<Out>(name, queryParameters: id != null ? {'id': id} : const <String, String>{}, extra: extra);

  void pushReplacement(BuildContext context, {In? extra, String? id}) => context.pushReplacementNamed(
    name,
    queryParameters: id != null ? {'id': id} : const <String, String>{},
    extra: extra,
  );

  void go(BuildContext context, {In? extra, String? id}) =>
      context.goNamed(name, queryParameters: id != null ? {'id': id} : const <String, String>{}, extra: extra);
}

extension RoutesHelper on String {
  String get lastRoutePath => substring(lastIndexOf('/') + 1);
  String get withSlashPrefix => startsWith('/') ? this : '/$this';
}
