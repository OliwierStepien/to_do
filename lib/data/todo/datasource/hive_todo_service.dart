import 'package:hive/hive.dart';
import 'package:to_do/data/todo/model/todo_model.dart';

abstract class HiveTodoDatasource {
  Future<List<TodoModel>> getTodo();
  Future<void> addTodo(TodoModel todo);
  Future<void> updateTodo(String id, TodoModel todo);
  Future<void> deleteTodo(String id);
}

class HiveTodoDatasourceImpl implements HiveTodoDatasource {
  Box<TodoModel> get _box => Hive.box<TodoModel>('todoBox');

  @override
  Future<List<TodoModel>> getTodo() async {
    final todos = _box.values.toList();
    return todos;
  }

  @override
  Future<void> addTodo(TodoModel todo) async {
    await _box.put(todo.id, todo);
  }

  @override
  Future<void> updateTodo(String id, TodoModel todo) async {
    await _box.put(id, todo);
  }

  @override
  Future<void> deleteTodo(String id) async {
    await _box.delete(id);
  }
}
