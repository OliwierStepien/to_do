import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/common/failure/failure_mapper.dart';
import 'package:to_do/domain/todo/entity/todo_entity.dart';
import 'package:to_do/domain/todo/usecase/add_todo_usecase.dart';
import 'package:to_do/domain/todo/usecase/delete_todo_usecase.dart';
import 'package:to_do/domain/todo/usecase/get_todo_usecase.dart';
import 'package:to_do/domain/todo/usecase/update_todo_usecase.dart';
import 'todo_state.dart';

/// Cubit zarządzający stanem Todo
class TodoCubit extends Cubit<TodoState> {
  final GetTodoUsecase getTodoUsecase;
  final AddTodoUsecase addTodoUsecase;
  final UpdateTodoUsecase updateTodoUsecase;
  final DeleteTodoUsecase deleteTodoUsecase;

  TodoCubit({
    required this.getTodoUsecase,
    required this.addTodoUsecase,
    required this.updateTodoUsecase,
    required this.deleteTodoUsecase,
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
    emit(state.copyWith(status: TodoStatus.loading));

    final result = await deleteTodoUsecase(id);

    result.fold(
      (failure) {
        final message = mapFailureToMessage(failure);
        emit(state.copyWith(status: TodoStatus.error, errorMessage: message));
      },
      (_) {
        final updatedTodos = state.todos
            .where((todo) => todo.id != id)
            .toList();
        emit(state.copyWith(status: TodoStatus.success, todos: updatedTodos));
      },
    );
  }

  /// Aktualizuje istniejące zadanie
  Future<void> updateTodo(String id, TodoEntity updatedTodo) async {
    emit(state.copyWith(status: TodoStatus.loading));

    final result = await updateTodoUsecase(id, updatedTodo);

    result.fold(
      (failure) {
        final message = mapFailureToMessage(failure);
        emit(state.copyWith(status: TodoStatus.error, errorMessage: message));
      },
      (_) {
        final updatedTodos = state.todos.map((todo) {
          return todo.id == id ? updatedTodo : todo;
        }).toList();
        emit(state.copyWith(status: TodoStatus.success, todos: updatedTodos));
      },
    );
  }
/// Zmiana kolejności Todo
void reorderTodos(int oldIndex, int newIndex) async {
  if (oldIndex == newIndex) return;

  print('Reorder: oldIndex=$oldIndex, newIndex=$newIndex');

  final List<TodoEntity> updatedTodos = List.from(state.todos);
  
  // Standardowa logika dla ReorderableListView
  if (oldIndex < newIndex) {
    newIndex -= 1;
  }
  
  final TodoEntity movedTodo = updatedTodos.removeAt(oldIndex);
  
  // Dodatkowe zabezpieczenie przed przekroczeniem zakresu
  if (newIndex > updatedTodos.length) {
    newIndex = updatedTodos.length;
  }
  if (newIndex < 0) {
    newIndex = 0;
  }
  
  updatedTodos.insert(newIndex, movedTodo);
  
  // Zaktualizuj pozycje
  for (int i = 0; i < updatedTodos.length; i++) {
    updatedTodos[i] = updatedTodos[i].copyWith(position: i);
  }

  emit(state.copyWith(todos: updatedTodos));

  // Zapisz zmiany
  for (final todo in updatedTodos) {
    final result = await updateTodoUsecase(todo.id, todo);
    result.fold(
      (failure) => print('❌ Błąd: ${todo.title}'),
      (_) => print('✅ Zapisano: ${todo.title} (pozycja: ${todo.position})'),
    );
  }
}
}
