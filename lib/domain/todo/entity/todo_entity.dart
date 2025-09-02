import 'package:equatable/equatable.dart';

class TodoEntity extends Equatable {
  final String id;
  final String title;
  final bool isCompleted;
  final int position;

  const TodoEntity({required this.id, required this.title, required this.isCompleted, required this.position});

  TodoEntity copyWith({String? id, String? title, bool? isCompleted, int ? position}) {
    return TodoEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      position: position ?? this.position,
    );
  }

  @override
  List<Object?> get props => [id, title, isCompleted, position];
}
