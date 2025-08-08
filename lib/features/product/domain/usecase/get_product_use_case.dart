import 'package:dartz/dartz.dart';
import 'package:task/core/errors/failure.dart';
import '../entity/product_entity.dart';
import '../repository/product_repo.dart';

class GetProductUseCase {
  final ProductRepo productRepo;

  GetProductUseCase({required this.productRepo});

  Future<Either<Failure, ProductEntity>> getProducts() async {
    try {
      return await productRepo.getProducts();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

