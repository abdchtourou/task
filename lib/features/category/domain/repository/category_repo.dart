import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entity/category_entity.dart';

abstract class CategoryRepo {
  Future<Either<Failure, CategoryEntity>> getCategories();
}
