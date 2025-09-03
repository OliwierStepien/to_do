import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do/domain/todo/entity/todo_entity.dart';
import 'package:to_do/presentation/todo/bloc/todo_cubit.dart';
import 'package:to_do/presentation/todo/widgets/dialog_box.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoTile extends StatelessWidget {
  final TodoEntity todo;
  final ValueChanged<bool?>? onChanged;
  final Function(BuildContext)? deleteFunction;

  const TodoTile({
    super.key,
    required this.todo,
    required this.onChanged,
    required this.deleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: theme.colorScheme.errorContainer,
              foregroundColor: theme.colorScheme.onErrorContainer,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 0,
          margin: EdgeInsets.zero,
          child: InkWell(
            onTap: () => onChanged?.call(!todo.isCompleted),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Checkbox(value: todo.isCompleted, onChanged: onChanged),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      todo.title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: () {
                      final controller = TextEditingController(text: todo.title);

                      showDialog(
                        context: context,
                        builder: (context) {
                          return DialogBox(
                            controller: controller,
                            onSave: () {
                              final updatedTodo = todo.copyWith(title: controller.text);
                              context.read<TodoCubit>().updateTodo(todo.id, updatedTodo);
                              Navigator.pop(context);
                            },
                            onCancel: () => Navigator.pop(context),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}