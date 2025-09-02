import 'package:equatable/equatable.dart';
import 'package:to_do/domain/todo/entity/todo_entity.dart';

enum TodoStatus { initial, loading, success, error }

class TodoState extends Equatable {
  /// Status operacji (initial/loading/success/error)
  final TodoStatus status;

  /// Lista wszystkich TodoEntity (może być pusta)
  final List<TodoEntity> todos;

  /// Opcjonalny komunikat o błędzie (jeśli status == error)
  final String? errorMessage;

  const TodoState._({
    required this.status,
    required this.todos,
    this.errorMessage,
  });

  /// Fabryka początkowego stanu — brak zadań, status = initial
  factory TodoState.initial() => const TodoState._(
        status: TodoStatus.initial,
        todos: [],
      );

  /// Metoda pomocnicza do kopiowania stanu
  TodoState copyWith({
    TodoStatus? status,
    List<TodoEntity>? todos,
    String? errorMessage,
  }) {
    return TodoState._(
      status: status ?? this.status,
      todos: todos ?? this.todos,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, todos, errorMessage];
}