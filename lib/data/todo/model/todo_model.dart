// lib/data/todo/model/todo_model.dart
import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)
class TodoModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final bool isCompleted;

  TodoModel({required this.id, required this.title, required this.isCompleted});
}
