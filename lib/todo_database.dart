import 'package:hive/hive.dart';

class TodoDatabase {
  List toDoList = [];

  final _myBox = Hive.box('todoBox');

  void loadData() {
    toDoList = _myBox.get('TODOLIST') ?? [];
  }

  void updateDatabase() {
    _myBox.put('TODOLIST', toDoList);
  }
}
