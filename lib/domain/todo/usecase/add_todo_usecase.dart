import 'package:dartz/dartz.dart';
import 'package:to_do/common/failure/failure.dart';
import 'package:to_do/domain/todo/entity/todo_entity.dart';
import 'package:to_do/domain/todo/repository/todo_repository.dart';

class AddTodoUsecase {
  final TodoRepository repository;

  AddTodoUsecase({required this.repository});

  Future<Either<Failure, void>> call(TodoEntity todo) async {
    return await repository.addTodo(todo);
  }
}