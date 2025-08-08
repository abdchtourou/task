import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:task/core/errors/failure.dart';
import 'package:task/core/network/network_helper.dart';
import 'package:task/features/product/data/datasource/local/product_local_data_source.dart';
import 'package:task/features/product/data/datasource/remote/product_remote_data_source.dart';
import 'package:task/features/product/data/model/product_model.dart';
import 'package:task/features/product/domain/entity/product_entity.dart';
import 'package:task/features/product/domain/repository/product_repo.dart';

class ProductRepositoryImpl extends ProductRepo {
  final ProductRemoteDataSource productRemoteDataSource;
  final ProductLocalDataSource productLocalDataSource;

  ProductRepositoryImpl({
    required this.productRemoteDataSource,
    required this.productLocalDataSource,
  });

  @override
  Future<Either<Failure, ProductEntity>> getProducts() async {
    try {
      final isConnected = await NetworkHelper.isConnected;
      final hasStrongConnection = await NetworkHelper.hasStrongConnection;

      final cachedData = await productLocalDataSource.getCachedProducts();

      if (cachedData != null && (!isConnected || !hasStrongConnection)) {
        return Right(cachedData);
      }

      if (cachedData != null && hasStrongConnection) {
        _refreshCacheInBackground();
        return Right(cachedData);
      }

      if (!isConnected) {
        final fallbackData = await _getFallbackCache();
        if (fallbackData != null) {
          return Right(fallbackData);
        }
        return Left(
          ServerFailure('No internet connection and no cached data available'),
        );
      }

      final ProductModel productModel = await _fetchWithTimeout();
      await productLocalDataSource.cacheProducts(productModel);
      return Right(productModel);
    } catch (e) {
      final fallbackData = await _getFallbackCache();
      if (fallbackData != null) {
        return Right(fallbackData);
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductItemEntity>> getProductById(int id) async {
    try {
      // Try local cache first
      final cached = await productLocalDataSource.getCachedProductById(id);
      if (cached != null) {
        // Optionally refresh in background
        _refreshProductDetailsInBackground(id);
        return Right(cached);
      }

      // Fallback to remote
      final item = await productRemoteDataSource.getProductById(id);
      await productLocalDataSource.cacheProductById(item);
      return Right(item);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  void _refreshProductDetailsInBackground(int id) async {
    try {
      final item = await productRemoteDataSource.getProductById(id);
      await productLocalDataSource.cacheProductById(item);
    } catch (_) {}
  }

  void _refreshCacheInBackground() async {
    try {
      final productModel = await productRemoteDataSource.getProducts();
      await productLocalDataSource.cacheProducts(productModel);
    } catch (e) {}
  }

  Future<ProductModel> _fetchWithTimeout() async {
    final hasStrongConnection = await NetworkHelper.hasStrongConnection;
    final timeout =
        hasStrongConnection
            ? const Duration(seconds: 10)
            : const Duration(seconds: 20);
    return await productRemoteDataSource.getProducts().timeout(timeout);
  }

  Future<ProductModel?> _getFallbackCache() async {
    try {
      final box = await Hive.openBox<List>('product_cache');
      final data = box.get('products');
      if (data != null) {
        return ProductModel.fromJson(data);
      }
    } catch (e) {}
    return null;
  }
}
