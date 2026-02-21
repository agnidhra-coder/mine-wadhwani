import 'package:dartz/dartz.dart';
import 'package:mine_wadhwani/core/error/failures.dart';
import 'package:mine_wadhwani/core/usecases/usecase.dart';
import 'package:mine_wadhwani/domain/entities/auth/user_entity.dart';
import 'package:mine_wadhwani/domain/repositories/auth_repository.dart';

// Login

class LoginParams {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});
}

class LoginUseCase extends UseCase<UserEntity, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) {
    return repository.login(email: params.email, password: params.password);
  }
}

// Register

class RegisterParams {
  final String name;
  final String email;
  final String password;
  final String mobilenumber;

  const RegisterParams({
    required this.name,
    required this.email,
    required this.password,
    required this.mobilenumber,
  });
}

class RegisterUseCase extends UseCase<UserEntity, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(RegisterParams params) {
    return repository.register(
      name: params.name,
      email: params.email,
      password: params.password,
      mobilenumber: params.mobilenumber,
    );
  }
}

// Check Auth

class CheckAuthUseCase extends UseCase<bool, NoParams> {
  final AuthRepository repository;

  CheckAuthUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return repository.isLoggedIn();
  }
}

// Logout

class LogoutUseCase extends UseCase<void, NoParams> {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.logout();
  }
}

// Get Cached User

class GetCachedUserUseCase extends UseCase<UserEntity, NoParams> {
  final AuthRepository repository;

  GetCachedUserUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) {
    return repository.getCachedUser();
  }
}
