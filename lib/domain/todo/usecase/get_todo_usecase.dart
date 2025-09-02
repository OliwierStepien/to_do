import 'package:dartz/dartz.dart';
import 'package:to_do/common/failure/failure.dart';
import 'package:to_do/domain/todo/entity/todo_entity.dart';
import 'package:to_do/domain/todo/repository/todo_repository.dart';

class GetTodoUsecase {
  final TodoRepository repository;

  GetTodoUsecase({required this.repository});

  Future<Either<Failure, List<TodoEntity>>> call() async {
    return await repository.getTodo();
  }
}