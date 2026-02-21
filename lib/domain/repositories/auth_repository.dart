import 'package:dartz/dartz.dart';
import 'package:mine_wadhwani/core/error/failures.dart';
import 'package:mine_wadhwani/domain/entities/auth/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String email,
    required String password,
    required String mobilenumber,
  });

  Future<Either<Failure, bool>> isLoggedIn();

  Future<Either<Failure, UserEntity>> getCachedUser();

  Future<Either<Failure, void>> logout();
}
