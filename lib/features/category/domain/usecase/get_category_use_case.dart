import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entity/category_entity.dart';
import '../repository/category_repo.dart';

class GetCategoryUseCase {
  final CategoryRepo categoryRepo;

  GetCategoryUseCase({required this.categoryRepo});

  Future<Either<Failure, CategoryEntity>> getCategories() async {
    try {
      final response = await categoryRepo.getCategories();
      return response;
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
