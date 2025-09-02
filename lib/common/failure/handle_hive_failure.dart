import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:to_do/common/exception/exception.dart';
import 'package:to_do/common/failure/failure.dart';

Future<Either<Failure, T>> handleHiveFailure<T>(
  Future<T> Function() operation,
) async {
  try {
    final result = await operation();
    return Right(result);
  } on HiveError catch (_) {
    return Left(CacheFailure());
  } on CacheException {
    return Left(CacheFailure());
  } catch (e) {
    return Left(CacheFailure());
  }
}