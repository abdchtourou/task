import 'package:hive/hive.dart';
import '../../model/category_cache_model.dart';
import '../../model/category_model.dart';

abstract class CategoryLocalDataSource {
  Future<CategoryModel?> getCachedCategories();
  Future<void> cacheCategories(CategoryModel categoryModel);
  Future<void> clearCache();
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  static const String boxName = 'category_cache';
  static const String cacheKey = 'categories';

  @override
  Future<CategoryModel?> getCachedCategories() async {
    try {
      final box = await Hive.openBox<CategoryCacheModel>(boxName);
      final cachedData = box.get(cacheKey);

      if (cachedData != null && cachedData.isValid) {
        return CategoryModel(categories: cachedData.categories);
      }

      if (cachedData != null && !cachedData.isValid) {
        await box.delete(cacheKey);
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheCategories(CategoryModel categoryModel) async {
    try {
      final box = await Hive.openBox<CategoryCacheModel>(boxName);
      final cacheModel = CategoryCacheModel.fromCategoryList(
        categoryModel.categories,
      );
      await box.put(cacheKey, cacheModel);
    } catch (e) {
      print('Failed to cache categories: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final box = await Hive.openBox<CategoryCacheModel>(boxName);
      await box.clear();
    } catch (e) {
      print('Failed to clear cache: $e');
    }
  }
}

