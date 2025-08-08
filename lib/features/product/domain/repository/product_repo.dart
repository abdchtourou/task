import 'package:dartz/dartz.dart';
import 'package:task/core/errors/failure.dart';
import '../entity/product_entity.dart';

abstract class ProductRepo {
  Future<Either<Failure, ProductEntity>> getProducts();
  Future<Either<Failure, ProductItemEntity>> getProductById(int id);
}
