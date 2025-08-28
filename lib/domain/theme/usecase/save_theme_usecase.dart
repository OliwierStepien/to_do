import 'package:to_do/domain/theme/entity/theme_entity.dart';
import 'package:to_do/domain/theme/repository/theme_repository.dart';

class SaveThemeUsecase {
  final ThemeRepository repository;

  SaveThemeUsecase({required this.repository});

  Future call(ThemeEntity themeEntity) async {
    return await repository.saveTheme(themeEntity);
  }
}
