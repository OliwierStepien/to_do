import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/common/failure/failure_mapper.dart';
import 'package:to_do/domain/todo/entity/todo_entity.dart';
import 'package:to_do/domain/todo/usecase/add_todo_usecase.dart';
import 'package:to_do/domain/todo/usecase/delete_todo_usecase.dart';
import 'package:to_do/domain/todo/usecase/get_todo_usecase.dart';
import 'package:to_do/domain/todo/usecase/update_todo_usecase.dart';
import 'todo_state.dart';

/// Cubit zarządzający stanem Todo
/// Odpowiada za pobieranie, dodawanie, usuwanie i aktualizowanie zadań
class TodoCubit extends Cubit<TodoState> {
  final GetTodoUsecase getTodoUsecase;
  final AddTodoUsecase addTodoUsecase;
  final UpdateTodoUsecase updateTodoUsecase;
  final DeleteTodoUsecase deleteTodoUsecase;

  /// Konstruktor Cubita z wymaganymi UseCase
  /// Początkowy stan to [TodoState.initial()]
  TodoCubit({
    required this.getTodoUsecase,
    required this.addTodoUsecase,
    required this.updateTodoUsecase,
    required this.deleteTodoUsecase,
  }) : super(TodoState.initial());

  /// Pobiera wszystkie zadania z repozytorium
  /// Ustawia status na loading, następnie na success lub error
  Future<void> fetchTodos() async {
    emit(state.copyWith(status: TodoStatus.loading));

    final result = await getTodoUsecase();

    result.fold(
      (failure) {
        // Jeśli pojawił się błąd, ustaw status error i komunikat
        final message = mapFailureToMessage(failure);
        emit(state.copyWith(
          status: TodoStatus.error,
          errorMessage: message,
        ));
      },
      (todos) {
        // Jeśli pobranie się powiodło, ustaw status success i nowe dane
        emit(state.copyWith(
          status: TodoStatus.success,
          todos: todos,
        ));
      },
    );
  }

  /// Dodaje nowe zadanie
  /// Ustawia status na loading, następnie success lub error
  Future<void> addTodo(TodoEntity todo) async {
    emit(state.copyWith(status: TodoStatus.loading));

    final result = await addTodoUsecase(todo);

    result.fold(
      (failure) {
        final message = mapFailureToMessage(failure);
        emit(state.copyWith(
          status: TodoStatus.error,
          errorMessage: message,
        ));
      },
      (_) {
        // Aktualizujemy listę lokalnie po dodaniu nowego zadania
        final updatedTodos = List<TodoEntity>.from(state.todos)..add(todo);
        emit(state.copyWith(
          status: TodoStatus.success,
          todos: updatedTodos,
        ));
      },
    );
  }

  /// Usuwa zadanie po id
  /// Ustawia status na loading, następnie success lub error
  Future<void> deleteTodo(String id) async {
    emit(state.copyWith(status: TodoStatus.loading));

    final result = await deleteTodoUsecase(id);

    result.fold(
      (failure) {
        final message = mapFailureToMessage(failure);
        emit(state.copyWith(
          status: TodoStatus.error,
          errorMessage: message,
        ));
      },
      (_) {
        // Aktualizujemy listę lokalnie po usunięciu zadania
        final updatedTodos = state.todos.where((todo) => todo.id != id).toList();
        emit(state.copyWith(
          status: TodoStatus.success,
          todos: updatedTodos,
        ));
      },
    );
  }

  /// Aktualizuje istniejące zadanie
  /// Ustawia status na loading, następnie success lub error
  Future<void> updateTodo(String id, TodoEntity updatedTodo) async {
    emit(state.copyWith(status: TodoStatus.loading));

    final result = await updateTodoUsecase(id, updatedTodo);

    result.fold(
      (failure) {
        final message = mapFailureToMessage(failure);
        emit(state.copyWith(
          status: TodoStatus.error,
          errorMessage: message,
        ));
      },
      (_) {
        // Zaktualizuj listę lokalnie po zmianie zadania
        final updatedTodos = state.todos.map((todo) {
          return todo.id == id ? updatedTodo : todo;
        }).toList();
        emit(state.copyWith(
          status: TodoStatus.success,
          todos: updatedTodos,
        ));
      },
    );
  }
}