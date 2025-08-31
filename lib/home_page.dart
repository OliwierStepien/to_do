import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/dialog_box.dart';
import 'package:to_do/domain/theme/entity/theme_entity.dart';
import 'package:to_do/presentation/theme/bloc/theme_cubit.dart';
import 'package:to_do/presentation/theme/bloc/theme_state.dart';
import 'package:to_do/todo_database.dart';
import 'package:to_do/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final Box _box = Hive.box('todoBox');
  TodoDatabase db = TodoDatabase();

  @override
  void initState() {
    db.loadData();
    super.initState();
  }

  final TextEditingController _controller = TextEditingController();

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDatabase();
  }

  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDatabase();
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () {
            Navigator.of(context).pop();
            _controller.clear();
          },
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
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
                  state.themeEntity?.themeType == ThemeType.dark
                      ? Icons.dark_mode
                      : Icons.light_mode,
                ),
              ),
            ],
          ),
          body: ListView.builder(
            itemCount: db.toDoList.length,
            itemBuilder: (context, index) {
              return TodoTile(
                taskName: db.toDoList[index][0],
                taskCompleted: db.toDoList[index][1],
                onChanged: (value) => checkBoxChanged(value, index),
                deleteFunction: (context) => deleteTask(index),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: createNewTask,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}