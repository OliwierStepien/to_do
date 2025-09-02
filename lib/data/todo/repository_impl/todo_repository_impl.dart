import 'package:dartz/dartz.dart';
import 'package:to_do/common/failure/failure.dart';
import 'package:to_do/common/failure/handle_hive_failure.dart';
import 'package:to_do/data/todo/datasource/hive_todo_service.dart';
import 'package:to_do/data/todo/mapper/todo_mapper.dart';
import 'package:to_do/domain/todo/entity/todo_entity.dart';
import 'package:to_do/domain/todo/repository/todo_repository.dart';

class TodoRepositoryImpl extends TodoRepository {
  final HiveTodoDatasource _hiveTodoDatasource;

  TodoRepositoryImpl({required HiveTodoDatasource hiveTodoDatasource})
    : _hiveTodoDatasource = hiveTodoDatasource;

  @override
  Future<Either<Failure, List<TodoEntity>>> getTodo() async {
    return handleHiveFailure(() async {
      final models = await _hiveTodoDatasource.getTodo();
      final entities = models.map(TodoMapper.toEntity).toList();
      return entities;
    });
  }

  @override
  Future<Either<Failure, void>> addTodo(TodoEntity todo) async {
    return handleHiveFailure(() async {
      final model = TodoMapper.toModel(todo);
      await _hiveTodoDatasource.addTodo(model);
    });
  }

  @override
  Future<Either<Failure, void>> updateTodo(String id, TodoEntity todo) async {
    return handleHiveFailure(() async {
      final model = TodoMapper.toModel(todo);
      await _hiveTodoDatasource.updateTodo(id, model);
    });
  }

  @override
  Future<Either<Failure, void>> deleteTodo(String id) async {
    return handleHiveFailure(() async {
      await _hiveTodoDatasource.deleteTodo(id);
    });
  }
}
