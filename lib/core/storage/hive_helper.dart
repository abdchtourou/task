import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import '../../features/category/data/model/category_cache_model.dart';
import '../../features/product/data/model/product_item_cache_model.dart';
import '../../features/product/data/model/product_list_cache_model.dart';

class HiveHelper {
  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(CategoryCacheModelAdapter());
    Hive.registerAdapter(ProductItemCacheModelAdapter());
    Hive.registerAdapter(ProductListCacheModelAdapter());
  }

  static Future<void> clearAllCache() async {
    try {
      await Hive.deleteBoxFromDisk('category_cache');
      await Hive.deleteBoxFromDisk('product_cache');
      await Hive.deleteBoxFromDisk('product_details_cache');
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }
}
