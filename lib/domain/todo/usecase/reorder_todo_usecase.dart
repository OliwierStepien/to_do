import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:to_do/common/failure/failure.dart';
import 'package:to_do/domain/todo/entity/todo_entity.dart';
import 'package:to_do/domain/todo/repository/todo_repository.dart';

class ReorderTodosUsecase {
  final TodoRepository repository;

  ReorderTodosUsecase({required this.repository});

  Future<Either<Failure, List<TodoEntity>>> call({
    required List<TodoEntity> todos,
    required int oldIndex,
    required int newIndex,
  }) async {
    if (oldIndex == newIndex) {
      return Right(todos);
    }

    final updatedTodos = List<TodoEntity>.from(todos);

    if (oldIndex < newIndex) newIndex -= 1;
    final movedTodo = updatedTodos.removeAt(oldIndex);

    if (newIndex > updatedTodos.length) newIndex = updatedTodos.length;
    if (newIndex < 0) newIndex = 0;

    updatedTodos.insert(newIndex, movedTodo);

    // Nadaj nowe pozycje
    for (int i = 0; i < updatedTodos.length; i++) {
      updatedTodos[i] = updatedTodos[i].copyWith(position: i);
    }

    // Zapisz w repozytorium
    for (final todo in updatedTodos) {
      final result = await repository.updateTodo(todo.id, todo);
      result.fold(
        (failure) => debugPrint('❌ Nie udało się zapisać: ${todo.title}'),
        (_) => debugPrint('✅ Zapisano: ${todo.title} (pos: ${todo.position})'),
      );
    }

    return Right(updatedTodos);
  }
}