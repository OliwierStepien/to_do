import 'package:flutter/material.dart';
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
    todos.sort((a, b) => a.position.compareTo(b.position));
    debugPrint('📦 [HiveTodoDatasource] getTodo -> total todos: ${todos.length}');
    return todos;
  }

  @override
  Future<void> addTodo(TodoModel todo) async {
    await _box.put(todo.id, todo);
    debugPrint(
      '➕ [HiveTodoDatasource] addTodo -> added id=${todo.id}, total todos=${_box.length}',
    );
  }

  @override
  Future<void> updateTodo(String id, TodoModel todo) async {
    await _box.put(id, todo);
    debugPrint('✏️ [HiveTodoDatasource] updateTodo -> updated id=$id');
  }

  @override
  Future<void> deleteTodo(String id) async {
    await _box.delete(id);
    debugPrint(
      '🗑️ [HiveTodoDatasource] deleteTodo -> deleted id=$id, total todos=${_box.length}',
    );
  }
}
