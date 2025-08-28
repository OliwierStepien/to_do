import 'package:to_do/domain/theme/entity/theme_entity.dart';
import 'package:to_do/domain/theme/repository/theme_repository.dart';

class GetThemeUsecase {
  final ThemeRepository repository;

  GetThemeUsecase({required this.repository});

  Future<ThemeEntity> call() async {
    return await repository.getTheme();
  }
}
