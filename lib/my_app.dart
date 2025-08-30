import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/core/configs/theme/app_theme.dart';
import 'package:to_do/core/get_it/get_it.dart';
import 'package:to_do/domain/theme/entity/theme_entity.dart';
import 'package:to_do/home_page.dart';
import 'package:to_do/presentation/bloc/theme_bloc.dart';
import 'package:to_do/presentation/bloc/theme_events.dart';

class MyAppWrapper extends StatelessWidget {
  const MyAppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create: (context) => getIt<ThemeBloc>()..add(GetThemeEvent()),
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
    final themeState = context.watch<ThemeBloc>().state;
    final isDark = themeState.themeEntity?.themeType == ThemeType.dark;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: const HomePage(),
    );
  }
}