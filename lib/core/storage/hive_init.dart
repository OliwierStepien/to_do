import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do/data/todo/model/todo_model.dart';

class HiveConfig {
  static Future<void> init() async {
    await Hive.initFlutter();

    _registerAdapters();
    // await _clearSpecificBoxes(); // <- DODANO

    await _openBoxes();
  }

  static void _registerAdapters() {
    Hive.registerAdapter(TodoModelAdapter());
  }

  // / 🧹 Czyści tylko wybrane boxy (przed otwarciem)
  // static Future<void> _clearSpecificBoxes() async {
  //   await Future.wait([
  //     Hive.deleteBoxFromDisk('todoBox'),
  //   ]);
  // }

  static Future<void> _openBoxes() async {
    await Hive.openBox<TodoModel>('todoBox');
  }

  static Future<void> close() async {
    await Hive.close();
  }
}
