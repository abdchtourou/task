import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';

import 'package:task/core/errors/failure.dart';
import 'package:task/core/network/network_helper.dart';
import 'package:task/features/category/data/datasource/remote/category_remote_data_source.dart';
import 'package:task/features/category/data/datasource/local/category_local_data_source.dart';
import 'package:task/features/category/data/model/category_model.dart';
import 'package:task/features/category/data/model/category_cache_model.dart';
import '../../domain/entity/category_entity.dart';
import '../../domain/repository/category_repo.dart';

class CategoryRepositoryImpl extends CategoryRepo {
  final CategoryRemoteDataSource categoryRemoteDataSource;
  final CategoryLocalDataSource categoryLocalDataSource;

  CategoryRepositoryImpl({
    required this.categoryRemoteDataSource,
    required this.categoryLocalDataSource,
  });

  @override
  Future<Either<Failure, CategoryEntity>> getCategories() async {
    try {
      final isConnected = await NetworkHelper.isConnected;
      final hasStrongConnection = await NetworkHelper.hasStrongConnection;

      final cachedData = await categoryLocalDataSource.getCachedCategories();

      if (cachedData != null && (!isConnected || !hasStrongConnection)) {
        return Right(cachedData);
      }

      if (cachedData != null && hasStrongConnection) {
        refreshCacheInBackground();
        return Right(cachedData);
      }

      if (!isConnected) {
        final fallbackData = await getFallbackCache();
        if (fallbackData != null) {
          return Right(fallbackData);
        }
        return Left(
          ServerFailure('No internet connection and no cached data available'),
        );
      }

      final CategoryModel categoryModel = await fetchWithTimeout();

      await categoryLocalDataSource.cacheCategories(categoryModel);

      return Right(categoryModel);
    } catch (e) {
      final fallbackData = await getFallbackCache();
      if (fallbackData != null) {
        return Right(fallbackData);
      }

      return Left(ServerFailure(e.toString()));
    }
  }


  void refreshCacheInBackground() async {
    try {
      final categoryModel = await categoryRemoteDataSource.getCategories();
      await categoryLocalDataSource.cacheCategories(categoryModel);
    } catch (e) {
      print('Background cache refresh failed: $e');
    }
  }

  Future<CategoryModel> fetchWithTimeout() async {
    final hasStrongConnection = await NetworkHelper.hasStrongConnection;
    final timeout =
        hasStrongConnection
            ? const Duration(seconds: 10)
            : const Duration(seconds: 20);

    return await categoryRemoteDataSource.getCategories().timeout(timeout);
  }

  Future<CategoryModel?> getFallbackCache() async {
    try {
      final box = await Hive.openBox<CategoryCacheModel>('category_cache');
      final fallbackData = box.get('categories');
      if (fallbackData != null) {
        return CategoryModel(categories: fallbackData.categories);
      }
    } catch (e) {
      print('Failed to get fallback cache: $e');
    }
    return null;
  }
}
