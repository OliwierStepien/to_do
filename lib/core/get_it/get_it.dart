import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/data/datasource/theme_local_datasource.dart';
import 'package:to_do/data/repository_impl/theme_repository_impl.dart';
import 'package:to_do/domain/theme/repository/theme_repository.dart';
import 'package:to_do/domain/theme/usecase/get_theme_usecase.dart';
import 'package:to_do/domain/theme/usecase/save_theme_usecase.dart';
import 'package:to_do/presentation/bloc/theme_bloc.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt.registerSingleton(await SharedPreferences.getInstance());

  getIt.registerSingleton(ThemeLocalDatasource(sharedPreferences: getIt()));

  // 🔹 Rejestracja z interfejsem
  getIt.registerSingleton<ThemeRepository>(
    ThemeRepositoryImpl(themeLocalDatasource: getIt()),
  );

  getIt.registerSingleton(GetThemeUsecase(repository: getIt()));
  getIt.registerSingleton(SaveThemeUsecase(repository: getIt()));

  getIt.registerFactory(
    () => ThemeBloc(
      getThemeUsecase: getIt(),
      saveThemeUsecase: getIt(),
    ),
  );
}