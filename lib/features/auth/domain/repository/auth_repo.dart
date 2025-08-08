import 'package:dartz/dartz.dart';
import 'package:task/core/errors/failure.dart';
import '../entity/auth_user_entity.dart';

abstract class AuthRepo {
  Future<Either<Failure, AuthUserEntity>> login({
    required String email,
    required String password,
  });
  Future<Either<Failure, bool>> logout();
  Future<Either<Failure, AuthUserEntity?>> getCurrentUser();
}

