import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/common/failure/failure_mapper.dart';
import 'package:to_do/domain/todo/entity/todo_entity.dart';
import 'package:to_do/domain/todo/usecase/add_todo_usecase.dart';
import 'package:to_do/domain/todo/usecase/delete_todo_usecase.dart';
import 'package:to_do/domain/todo/usecase/get_todo_usecase.dart';
import 'package:to_do/domain/todo/usecase/reorder_todo_usecase.dart';
import 'package:to_do/domain/todo/usecase/update_todo_usecase.dart';
import 'todo_state.dart';

/// Cubit zarządzający stanem Todo
class TodoCubit extends Cubit<TodoState> {
  final GetTodoUsecase getTodoUsecase;
  final AddTodoUsecase addTodoUsecase;
  final UpdateTodoUsecase updateTodoUsecase;
  final DeleteTodoUsecase deleteTodoUsecase;
  final ReorderTodosUsecase reorderTodosUsecase;

  TodoCubit({
    required this.getTodoUsecase,
    required this.addTodoUsecase,
    required this.updateTodoUsecase,
    required this.deleteTodoUsecase,
    required this.reorderTodosUsecase,
  }) : super(TodoState.initial());

  /// Pobiera wszystkie zadania
  Future<void> fetchTodos() async {
    emit(state.copyWith(status: TodoStatus.loading));

    final result = await getTodoUsecase();

    result.fold(
      (failure) {
        final message = mapFailureToMessage(failure);
        emit(state.copyWith(status: TodoStatus.error, errorMessage: message));
      },
      (todos) {
        emit(state.copyWith(status: TodoStatus.success, todos: todos));
      },
    );
  }

  /// Dodaje nowe zadanie
  Future<void> addTodo(TodoEntity todo) async {
    emit(state.copyWith(status: TodoStatus.loading));

    final result = await addTodoUsecase(todo);

    result.fold(
      (failure) {
        final message = mapFailureToMessage(failure);
        emit(state.copyWith(status: TodoStatus.error, errorMessage: message));
      },
      (_) {
        final updatedTodos = List<TodoEntity>.from(state.todos)..add(todo);
        emit(state.copyWith(status: TodoStatus.success, todos: updatedTodos));
      },
    );
  }

  /// Usuwa zadanie
  Future<void> deleteTodo(String id) async {
    final previousTodos = state.todos;
    final updatedTodos = previousTodos.where((todo) => todo.id != id).toList();

    emit(state.copyWith(status: TodoStatus.success, todos: updatedTodos));

    final result = await deleteTodoUsecase(id);

    result.fold(
      (failure) {
        final message = mapFailureToMessage(failure);
        // Przy błędzie przywracamy poprzedni stan
        emit(state.copyWith(
          status: TodoStatus.error,
          errorMessage: message,
          todos: previousTodos,
        ));
      },
      (_) {},
    );
  }

  /// Aktualizuje istniejące zadanie
  Future<void> updateTodo(String id, TodoEntity updatedTodo) async {
    final previousTodos = state.todos;
    final updatedTodos = previousTodos.map((todo) {
      return todo.id == id ? updatedTodo : todo;
    }).toList();

    emit(state.copyWith(status: TodoStatus.success, todos: updatedTodos));

    final result = await updateTodoUsecase(id, updatedTodo);

    result.fold(
      (failure) {
        final message = mapFailureToMessage(failure);
        // Przy błędzie przywracamy poprzedni stan
        emit(state.copyWith(
          status: TodoStatus.error,
          errorMessage: message,
          todos: previousTodos,
        ));
      },
      (_) {},
    );
  }

  /// Zmiana kolejności Todo
  Future<void> reorderTodos(int oldIndex, int newIndex) async {
    final result = await reorderTodosUsecase(
      todos: state.todos,
      oldIndex: oldIndex,
      newIndex: newIndex,
    );

    result.fold(
      (failure) {
        final message = mapFailureToMessage(failure);
        emit(state.copyWith(status: TodoStatus.error, errorMessage: message));
      },
      (updatedTodos) {
        emit(state.copyWith(status: TodoStatus.success, todos: updatedTodos));
      },
    );
  }
}
