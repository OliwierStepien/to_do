import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do/core/service_locator/service_locator.dart';
import 'package:to_do/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  await Hive.initFlutter();
  await Hive.openBox('todoBox');

  runApp(const MyAppWrapper());
}