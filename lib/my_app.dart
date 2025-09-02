import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/core/configs/theme/app_theme.dart';
import 'package:to_do/core/service_locator/service_locator.dart';
import 'package:to_do/domain/theme/entity/theme_entity.dart';
import 'package:to_do/presentation/todo/pages/todo_page.dart';
import 'package:to_do/presentation/theme/bloc/theme_cubit.dart';
import 'package:to_do/presentation/todo/bloc/todo_cubit.dart';

class MyAppWrapper extends StatelessWidget {
  const MyAppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
return MultiBlocProvider(
  providers: [
    BlocProvider<ThemeCubit>(
      create: (context) => sl<ThemeCubit>()..getTheme(),
    ),
    BlocProvider<TodoCubit>(
      create: (context) => sl<TodoCubit>()..fetchTodos(),
    ),
  ],
  child: const MyApp(),
);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    final isDark = themeState.themeEntity?.themeType == ThemeType.dark;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: const TodoPage(),
    );
  }
}