import 'package:flutter/widgets.dart';
import 'package:kickin_storage/kickin_storage.dart';
import 'package:saabi_mobile/app.dart';

void main() async {
  await KHive.on.initialize(initApp: true);
  runApp(const App());
}
