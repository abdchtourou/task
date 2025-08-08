import 'package:dartz/dartz.dart';
import 'package:task/core/errors/failure.dart';
import 'package:task/features/auth/data/datasource/local/auth_local_data_source.dart';
import 'package:task/features/auth/data/model/auth_user_model.dart';
import 'package:task/features/auth/domain/entity/auth_user_entity.dart';
import 'package:task/features/auth/domain/repository/auth_repo.dart';

class AuthRepositoryImpl extends AuthRepo {
  final AuthLocalDataSource authLocalDataSource;
  AuthRepositoryImpl({required this.authLocalDataSource});

  @override
  Future<Either<Failure, AuthUserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        return Left(ServerFailure('Email and password are required'));
      }
      final user = AuthUserModel(
        id: email.hashCode.toString(),
        name: email.split('@').first,
        email: email,
      );
      await authLocalDataSource.saveUser(user);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await authLocalDataSource.clearUser();
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthUserEntity?>> getCurrentUser() async {
    try {
      final user = await authLocalDataSource.getUser();
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

