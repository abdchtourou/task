import 'package:hive/hive.dart';

part 'product_item_cache_model.g.dart';

@HiveType(typeId: 2)
class ProductItemCacheModel extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String title;

  @HiveField(2)
  double price;

  @HiveField(3)
  String description;

  @HiveField(4)
  String category;

  @HiveField(5)
  String image;

  @HiveField(6)
  double rate;

  @HiveField(7)
  int count;

  ProductItemCacheModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rate,
    required this.count,
  });
}
