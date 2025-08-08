import 'package:dartz/dartz.dart';
import 'package:task/core/errors/failure.dart';
import '../entity/auth_user_entity.dart';
import '../repository/auth_repo.dart';

class LoginUseCase {
  final AuthRepo authRepo;
  LoginUseCase({required this.authRepo});

  Future<Either<Failure, AuthUserEntity>> call({
    required String email,
    required String password,
  }) {
    return authRepo.login(email: email, password: password);
  }
}

