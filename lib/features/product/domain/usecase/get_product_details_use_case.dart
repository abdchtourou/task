import 'package:dartz/dartz.dart';
import 'package:task/core/errors/failure.dart';
import '../entity/product_entity.dart';
import '../repository/product_repo.dart';

class GetProductDetailsUseCase {
  final ProductRepo productRepo;
  GetProductDetailsUseCase({required this.productRepo});

  Future<Either<Failure, ProductItemEntity>> call(int id) async {
    try {
      return await productRepo.getProductById(id);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
