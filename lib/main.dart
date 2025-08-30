import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do/core/get_it/get_it.dart';
import 'package:to_do/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  await Hive.initFlutter();
  await Hive.openBox('todoBox');

  runApp(const MyAppWrapper());
}