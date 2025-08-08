import 'package:task/core/network/api_helper.dart';

import '../../model/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<CategoryModel> getCategories();
}

class CategoryRemoteDataSourceImpl extends CategoryRemoteDataSource {
  final ApiHelper apiHelper;

  CategoryRemoteDataSourceImpl({required this.apiHelper});

  @override
  Future<CategoryModel> getCategories() async {
    final response = await apiHelper.get(
      'https://fakestoreapi.com/products/categories',
    );
    return CategoryModel.fromJson(response.data);
  }
}
