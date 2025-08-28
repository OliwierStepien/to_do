import 'package:to_do/domain/theme/entity/theme_entity.dart';

abstract class ThemeRepository {
  Future<ThemeEntity> getTheme();
  Future saveTheme(ThemeEntity theme);
}
