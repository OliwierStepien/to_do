import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/data/theme/datasource/theme_local_datasource.dart';
import 'package:to_do/data/theme/repository_impl/theme_repository_impl.dart';
import 'package:to_do/domain/theme/repository/theme_repository.dart';
import 'package:to_do/domain/theme/usecase/get_theme_usecase.dart';
import 'package:to_do/domain/theme/usecase/save_theme_usecase.dart';
import 'package:to_do/presentation/theme/bloc/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // DATASOURCE

  sl.registerSingleton(await SharedPreferences.getInstance());

  sl.registerSingleton<ThemeLocalDatasource>(
    ThemeLocalDatasourceImpl(sharedPreferences: sl()),
  );

  // REPOSITORY

  sl.registerSingleton<ThemeRepository>(
    ThemeRepositoryImpl(themeLocalDatasource: sl()),
  );

  // USECASE

  sl.registerSingleton(GetThemeUsecase(repository: sl()));
  sl.registerSingleton(SaveThemeUsecase(repository: sl()));

  // BLOC

  sl.registerFactory(
    () => ThemeCubit(getThemeUsecase: sl(), saveThemeUsecase: sl()),
  );
}
