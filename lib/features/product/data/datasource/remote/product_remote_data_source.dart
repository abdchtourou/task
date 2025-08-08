import 'package:task/core/network/api_helper.dart';

import '../../model/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<ProductModel> getProducts();
  Future<ProductItemModel> getProductById(int id);
}

class ProductRemoteDataSourceImpl extends ProductRemoteDataSource {
  final ApiHelper apiHelper;

  ProductRemoteDataSourceImpl({required this.apiHelper});

  @override
  Future<ProductModel> getProducts() async {
    final response = await apiHelper.get('https://fakestoreapi.com/products');
    return ProductModel.fromJson(response.data as List<dynamic>);
  }

  @override
  Future<ProductItemModel> getProductById(int id) async {
    final response = await apiHelper.get(
      'https://fakestoreapi.com/products/$id',
    );
    return ProductItemModel.fromMap(response.data as Map<String, dynamic>);
  }
}
