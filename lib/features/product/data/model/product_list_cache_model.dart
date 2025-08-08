import 'package:hive/hive.dart';
import 'product_item_cache_model.dart';

part 'product_list_cache_model.g.dart';

@HiveType(typeId: 3)
class ProductListCacheModel extends HiveObject {
  @HiveField(0)
  List<ProductItemCacheModel> products;

  @HiveField(1)
  DateTime lastUpdated;

  ProductListCacheModel({required this.products, required this.lastUpdated});

  bool get isValid => DateTime.now().difference(lastUpdated).inHours < 24;
}
