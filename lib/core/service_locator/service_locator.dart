import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/data/theme/datasource/theme_local_datasource.dart';
import 'package:to_do/data/theme/repository_impl/theme_repository_impl.dart';
import 'package:to_do/data/todo/datasource/hive_todo_service.dart';
import 'package:to_do/data/todo/repository_impl/todo_repository_impl.dart';
import 'package:to_do/domain/theme/repository/theme_repository.dart';
import 'package:to_do/domain/theme/usecase/get_theme_usecase.dart';
import 'package:to_do/domain/theme/usecase/save_theme_usecase.dart';
import 'package:to_do/domain/todo/repository/todo_repository.dart';
import 'package:to_do/domain/todo/usecase/add_todo_usecase.dart';
import 'package:to_do/domain/todo/usecase/delete_todo_usecase.dart';
import 'package:to_do/domain/todo/usecase/get_todo_usecase.dart';
import 'package:to_do/domain/todo/usecase/update_todo_usecase.dart';
import 'package:to_do/presentation/theme/bloc/theme_cubit.dart';
import 'package:to_do/presentation/todo/bloc/todo_cubit.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // DATASOURCE

  // Theme datasource

  sl.registerSingleton(await SharedPreferences.getInstance());

  sl.registerSingleton<ThemeLocalDatasource>(
    ThemeLocalDatasourceImpl(sharedPreferences: sl()),
  );

  // Todo datasource
  sl.registerSingleton<HiveTodoDatasource>(HiveTodoDatasourceImpl());

  // REPOSITORY

  // Theme repository

  sl.registerSingleton<ThemeRepository>(
    ThemeRepositoryImpl(themeLocalDatasource: sl()),
  );

  // Todo repository

  sl.registerSingleton<TodoRepository>(
    TodoRepositoryImpl(hiveTodoDatasource: sl()),
  );  

  // USECASE

  // Theme usecase

  sl.registerSingleton(GetThemeUsecase(repository: sl()));
  sl.registerSingleton(SaveThemeUsecase(repository: sl()));

  // Todo usecase

    sl.registerSingleton(GetTodoUsecase(repository: sl()));
    sl.registerSingleton(AddTodoUsecase(repository: sl()));
    sl.registerSingleton(UpdateTodoUsecase(repository: sl()));
    sl.registerSingleton(DeleteTodoUsecase(repository: sl()));


  // BLOC

  // Theme bloc

  sl.registerFactory(
    () => ThemeCubit(getThemeUsecase: sl(), saveThemeUsecase: sl()),
  );

  // Todo bloc
  sl.registerFactory(
    () => TodoCubit(
      getTodoUsecase: sl(),
      addTodoUsecase: sl(),
      updateTodoUsecase: sl(),
      deleteTodoUsecase: sl(),
    ),
  );
}
