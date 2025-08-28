import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do/core/configs/theme/app_theme.dart';
import 'package:to_do/core/get_it/get_it.dart';
import 'package:to_do/domain/theme/entity/theme_entity.dart';
import 'package:to_do/home_page.dart';
import 'package:to_do/presentation/bloc/theme_bloc.dart';
import 'package:to_do/presentation/bloc/theme_events.dart';
import 'package:to_do/presentation/bloc/theme_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  await Hive.initFlutter();

  await Hive.openBox('todoBox');

  runApp(
    BlocProvider(
      create: (context) => getIt<ThemeBloc>()..add(GetThemeEvent()),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MyApp(state: state);
        },
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final ThemeState state;

  const MyApp({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final isDark = state.themeEntity?.themeType == ThemeType.dark;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: const HomePage(),
    );
  }
}
