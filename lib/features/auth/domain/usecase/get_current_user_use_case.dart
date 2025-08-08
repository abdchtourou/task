import 'package:dartz/dartz.dart';
import 'package:task/core/errors/failure.dart';
import '../entity/auth_user_entity.dart';
import '../repository/auth_repo.dart';

class GetCurrentUserUseCase {
  final AuthRepo authRepo;
  GetCurrentUserUseCase({required this.authRepo});

  Future<Either<Failure, AuthUserEntity?>> call() {
    return authRepo.getCurrentUser();
  }
}

