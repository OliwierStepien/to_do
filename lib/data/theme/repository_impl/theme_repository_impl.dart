import 'package:dartz/dartz.dart';
import 'package:to_do/common/failure/failure.dart';
import 'package:to_do/data/theme/datasource/theme_local_datasource.dart';
import 'package:to_do/domain/theme/entity/theme_entity.dart';
import 'package:to_do/domain/theme/repository/theme_repository.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocalDatasource themeLocalDatasource;

  ThemeRepositoryImpl({required this.themeLocalDatasource});

  @override
  Future<Either<Failure, ThemeEntity>> getTheme() async {
    try {
      final theme = await themeLocalDatasource.getTheme();
      return Right(theme);
    } catch (_) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveTheme(ThemeEntity theme) async {
    try {
      await themeLocalDatasource.saveTheme(theme);
      return const Right(null);
    } catch (_) {
      return Left(CacheFailure());
    }
  }
}
