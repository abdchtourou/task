import 'package:hive/hive.dart';

import '../../model/product_model.dart';
import '../../model/product_item_cache_model.dart';
import '../../model/product_list_cache_model.dart';

abstract class ProductLocalDataSource {
  Future<ProductModel?> getCachedProducts();
  Future<void> cacheProducts(ProductModel productModel);
  Future<void> clearCache();
  Future<ProductItemModel?> getCachedProductById(int id);
  Future<void> cacheProductById(ProductItemModel productItemModel);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  static const String boxName = 'product_cache';
  static const String cacheKey = 'products';
  static const String detailsBoxName = 'product_details_cache';

  @override
  Future<ProductModel?> getCachedProducts() async {
    try {
      final box = await Hive.openBox<ProductListCacheModel>(boxName);
      final cached = box.get(cacheKey);
      if (cached != null && cached.isValid) {
        final items =
            cached.products
                .map(
                  (c) => ProductItemModel(
                    id: c.id,
                    title: c.title,
                    price: c.price,
                    description: c.description,
                    category: c.category,
                    image: c.image,
                    rate: c.rate,
                    count: c.count,
                  ),
                )
                .toList();
        return ProductModel(products: items);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheProducts(ProductModel productModel) async {
    try {
      final box = await Hive.openBox<ProductListCacheModel>(boxName);
      final list =
          productModel.products
              .map(
                (p) => ProductItemCacheModel(
                  id: p.id,
                  title: p.title,
                  price: p.price,
                  description: p.description,
                  category: p.category,
                  image: p.image,
                  rate: p.rate,
                  count: p.count,
                ),
              )
              .toList();
      await box.put(
        cacheKey,
        ProductListCacheModel(products: list, lastUpdated: DateTime.now()),
      );
    } catch (e) {}
  }

  @override
  Future<void> clearCache() async {
    try {
      final box = await Hive.openBox<ProductListCacheModel>(boxName);
      await box.clear();
    } catch (e) {}
  }

  @override
  Future<ProductItemModel?> getCachedProductById(int id) async {
    try {
      final box = await Hive.openBox<ProductItemCacheModel>(detailsBoxName);
      final data = box.get(id.toString());
      if (data != null) {
        return ProductItemModel(
          id: data.id,
          title: data.title,
          price: data.price,
          description: data.description,
          category: data.category,
          image: data.image,
          rate: data.rate,
          count: data.count,
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheProductById(ProductItemModel productItemModel) async {
    try {
      final box = await Hive.openBox<ProductItemCacheModel>(detailsBoxName);
      await box.put(
        productItemModel.id.toString(),
        ProductItemCacheModel(
          id: productItemModel.id,
          title: productItemModel.title,
          price: productItemModel.price,
          description: productItemModel.description,
          category: productItemModel.category,
          image: productItemModel.image,
          rate: productItemModel.rate,
          count: productItemModel.count,
        ),
      );
    } catch (e) {}
  }
}
