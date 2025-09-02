import 'package:dartz/dartz.dart';
import 'package:to_do/common/failure/failure.dart';
import 'package:to_do/domain/todo/entity/todo_entity.dart';

abstract class TodoRepository {
  Future<Either<Failure, List<TodoEntity>>> getTodo();
  Future<Either<Failure, void>> addTodo(TodoEntity todo);
  Future<Either<Failure, void>> updateTodo(String id, TodoEntity todo);
  Future<Either<Failure, void>> deleteTodo(String id);
}