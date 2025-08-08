import 'package:dartz/dartz.dart';
import 'package:task/core/errors/failure.dart';
import '../repository/auth_repo.dart';

class LogoutUseCase {
  final AuthRepo authRepo;
  LogoutUseCase({required this.authRepo});

  Future<Either<Failure, bool>> call() {
    return authRepo.logout();
  }
}

