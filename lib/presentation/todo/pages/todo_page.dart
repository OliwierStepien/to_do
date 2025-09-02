import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/domain/theme/entity/theme_entity.dart';
import 'package:to_do/presentation/todo/widgets/dialog_box.dart';
import 'package:to_do/domain/todo/entity/todo_entity.dart';
import 'package:to_do/presentation/theme/bloc/theme_cubit.dart';
import 'package:to_do/presentation/theme/bloc/theme_state.dart';
import 'package:to_do/presentation/todo/bloc/todo_cubit.dart';
import 'package:to_do/presentation/todo/bloc/todo_state.dart';
import 'package:to_do/presentation/todo/widgets/todo_tile.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('To-Do List'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  context.read<ThemeCubit>().toggleTheme();
                },
                icon: Icon(
                  themeState.themeEntity?.themeType == ThemeType.dark
                      ? Icons.dark_mode
                      : Icons.light_mode,
                ),
              ),
            ],
          ),
          body: BlocBuilder<TodoCubit, TodoState>(
            builder: (context, todoState) {
              if (todoState.status == TodoStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (todoState.status == TodoStatus.error) {
                return Center(
                  child: Text(todoState.errorMessage ??
                      "Ups, coś poszło nie tak!"),
                );
              }
              if (todoState.todos.isEmpty) {
                return const Center(child: Text("Brak zadań. Dodaj nowe!"));
              }

              return ListView.builder(
                itemCount: todoState.todos.length,
                itemBuilder: (context, index) {
                  final todo = todoState.todos[index];
                  return TodoTile(
                    todo: todo,
                    onChanged: (_) => _checkBoxChanged(context, todo),
                    deleteFunction: (_) => _deleteTask(context, todo.id),
                  );
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _createNewTask(context),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _checkBoxChanged(BuildContext context, TodoEntity todo) {
    final updatedTodo = todo.copyWith(isCompleted: !todo.isCompleted);
    context.read<TodoCubit>().updateTodo(todo.id, updatedTodo);
  }

  void _deleteTask(BuildContext context, String id) {
    context.read<TodoCubit>().deleteTodo(id);
  }

void _createNewTask(BuildContext context) {
  final controller = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return DialogBox(
        controller: controller,
        onSave: () => _saveNewTask(context, controller),
        onCancel: () => Navigator.of(context).pop(),
      );
    },
  );
}

void _saveNewTask(BuildContext context, TextEditingController controller) {
  if (controller.text.trim().isEmpty) return;

  final newTodo = TodoEntity(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    title: controller.text.trim(),
    isCompleted: false,
  );

  context.read<TodoCubit>().addTodo(newTodo);
  Navigator.of(context).pop();
}
}