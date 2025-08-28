import 'package:to_do/data/datasource/theme_local_datasource.dart';
import 'package:to_do/domain/theme/entity/theme_entity.dart';
import 'package:to_do/domain/theme/repository/theme_repository.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocalDatasource themeLocalDatasource;

  ThemeRepositoryImpl({required this.themeLocalDatasource});

  @override
  Future<ThemeEntity> getTheme() async {
    return await themeLocalDatasource.getTheme();
  }

  @override
  Future saveTheme(ThemeEntity theme) async {
    await themeLocalDatasource.saveTheme(theme);
  }
}
