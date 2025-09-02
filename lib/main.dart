import 'package:flutter/material.dart';
import 'package:to_do/core/service_locator/service_locator.dart';
import 'package:to_do/core/storage/hive_init.dart';
import 'package:to_do/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfig.init();
  await initializeDependencies();

  runApp(const MyAppWrapper());
}
