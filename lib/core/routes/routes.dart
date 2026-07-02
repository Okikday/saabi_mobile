import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// pattern
/// Route - extra: Arg
/// Path follows subPath
///
enum Routes<In, Out> {
  splash;

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
