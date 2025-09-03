import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/domain/todo/entity/todo_entity.dart';
import 'package:to_do/presentation/todo/widgets/dialog_box.dart';
import 'package:to_do/presentation/todo/widgets/todo_tile.dart';
import 'package:to_do/presentation/todo/bloc/todo_cubit.dart';
import 'package:to_do/presentation/todo/bloc/todo_state.dart';
import 'package:to_do/presentation/theme/bloc/theme_cubit.dart';
import 'package:to_do/presentation/theme/bloc/theme_state.dart';
import 'package:to_do/domain/theme/entity/theme_entity.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return Scaffold(
          appBar: AppBar(
            title: BlocBuilder<TodoCubit, TodoState>(
              builder: (context, todoState) {
                final count = todoState.todos.length;
                return Text('To-Do List ($count)');
              },
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () => context.read<ThemeCubit>().toggleTheme(),
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
                  child: Text(
                    todoState.errorMessage ?? "Ups, coś poszło nie tak!",
                  ),
                );
              }
              if (todoState.todos.isEmpty) {
                return const Center(child: Text("Brak zadań. Dodaj nowe!"));
              }

              return ReorderableListView.builder(
                itemCount: todoState.todos.length,
                onReorder: (oldIndex, newIndex) {
                  context.read<TodoCubit>().reorderTodos(oldIndex, newIndex);
                },
                itemBuilder: (context, index) {
                  final todo = todoState.todos[index];
                  return ReorderableDragStartListener(
                    key: ValueKey(todo.id),
                    index: index,
                    child: TodoTile(
                      key: ValueKey(todo.id),
                      todo: todo,
                      onChanged: (_) => _checkBoxChanged(context, todo),
                      deleteFunction: (_) => _deleteTask(context, todo.id),
                    ),
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

    final cubit = context.read<TodoCubit>();

    final newTodo = TodoEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: controller.text.trim(),
      isCompleted: false,
      position: cubit.state.todos.length, // nowa pozycja na końcu listy
    );

    cubit.addTodo(newTodo);
    Navigator.of(context).pop();
  }
}
