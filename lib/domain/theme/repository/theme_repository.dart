import 'package:dartz/dartz.dart';
import 'package:to_do/common/failure/failure.dart';
import 'package:to_do/domain/theme/entity/theme_entity.dart';

abstract class ThemeRepository {
  Future<Either<Failure, ThemeEntity>> getTheme();
  Future<Either<Failure, void>> saveTheme(ThemeEntity theme);
}
