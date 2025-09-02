import 'package:to_do/data/todo/model/todo_model.dart';
import 'package:to_do/domain/todo/entity/todo_entity.dart';

class TodoMapper {
  static TodoEntity toEntity(TodoModel model) {
    return TodoEntity(
      id: model.id,
      title: model.title,
      isCompleted: model.isCompleted,
    );
  }

  static TodoModel toModel(TodoEntity entity) {
    return TodoModel(
      id: entity.id,
      title: entity.title,
      isCompleted: entity.isCompleted,
    );
  }
}
