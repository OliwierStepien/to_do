import 'package:dartz/dartz.dart';
import 'package:to_do/common/failure/failure.dart';
import 'package:to_do/domain/todo/repository/todo_repository.dart';

class DeleteTodoUsecase {
  final TodoRepository repository;

  DeleteTodoUsecase({required this.repository});

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteTodo(id);
  }
}
