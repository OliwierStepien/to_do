import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/domain/theme/entity/theme_entity.dart';

abstract class ThemeLocalDatasource {
  Future<ThemeEntity> getTheme();
  Future<void> saveTheme(ThemeEntity theme);
}

class ThemeLocalDatasourceImpl implements ThemeLocalDatasource {
  final SharedPreferences sharedPreferences;

  ThemeLocalDatasourceImpl({required this.sharedPreferences});

@override
  Future<void> saveTheme(ThemeEntity theme) async {
    final themeValue = theme.themeType == ThemeType.dark ? 'dark' : 'light';
    await sharedPreferences.setString('theme_key', themeValue);
  }

@override
  Future<ThemeEntity> getTheme() async {
    final themeValue = sharedPreferences.getString('theme_key');
    if (themeValue == 'dark') {
      return ThemeEntity(themeType: ThemeType.dark);
    }
    return ThemeEntity(themeType: ThemeType.light);
  }
}
