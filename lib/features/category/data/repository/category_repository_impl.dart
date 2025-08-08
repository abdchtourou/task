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
      // Check network connectivity
      final isConnected = await NetworkHelper.isConnected;
      final hasStrongConnection = await NetworkHelper.hasStrongConnection;

      // Always try cache first for better performance
      final cachedData = await categoryLocalDataSource.getCachedCategories();

      // If we have valid cache and weak/no connection, return cache
      if (cachedData != null && (!isConnected || !hasStrongConnection)) {
        return Right(cachedData);
      }

      // If we have valid cache and strong connection, return cache but refresh in background
      if (cachedData != null && hasStrongConnection) {
        // Return cached data immediately for better UX
        _refreshCacheInBackground();
        return Right(cachedData);
      }

      // No valid cache, need to fetch from remote
      if (!isConnected) {
        // No connection and no cache, try to get any expired cache as fallback
        final fallbackData = await _getFallbackCache();
        if (fallbackData != null) {
          return Right(fallbackData);
        }
        return Left(
          ServerFailure('No internet connection and no cached data available'),
        );
      }

      // Fetch from remote with connectivity-aware timeout
      final CategoryModel categoryModel = await _fetchWithTimeout();

      // Cache the new data for future use
      await categoryLocalDataSource.cacheCategories(categoryModel);

      return Right(categoryModel);
    } catch (e) {
      // If remote fails, try to get any cached data (even if expired)
      final fallbackData = await _getFallbackCache();
      if (fallbackData != null) {
        return Right(fallbackData);
      }

      return Left(ServerFailure(e.toString()));
    }
  }


  /// Refresh cache in background without affecting current UI
  void _refreshCacheInBackground() async {
    try {
      final categoryModel = await categoryRemoteDataSource.getCategories();
      await categoryLocalDataSource.cacheCategories(categoryModel);
    } catch (e) {
      // Silently fail background refresh
      print('Background cache refresh failed: $e');
    }
  }

  /// Fetch data with appropriate timeout based on connection quality
  Future<CategoryModel> _fetchWithTimeout() async {
    final hasStrongConnection = await NetworkHelper.hasStrongConnection;
    final timeout =
        hasStrongConnection
            ? const Duration(seconds: 10)
            : const Duration(seconds: 20);

    return await categoryRemoteDataSource.getCategories().timeout(timeout);
  }

  /// Get fallback cache data (even if expired)
  Future<CategoryModel?> _getFallbackCache() async {
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
