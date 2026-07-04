import 'package:flutter/widgets.dart';
import 'package:kickin_storage/kickin_storage.dart';
import 'package:saabi_mobile/app.dart';
import 'package:saabi_mobile/core/storage/isar/isar_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await KHive.on.initialize(initApp: true);
  await IsarData.initializeDefault();
  runApp(const App());
}
