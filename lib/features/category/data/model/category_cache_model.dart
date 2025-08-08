import 'package:hive/hive.dart';

part 'category_cache_model.g.dart';

@HiveType(typeId: 0)
class CategoryCacheModel extends HiveObject {
  @HiveField(0)
  List<String> categories;

  @HiveField(1)
  DateTime lastUpdated;

  CategoryCacheModel({required this.categories, required this.lastUpdated});

  bool get isValid {
    final now = DateTime.now();
    final difference = now.difference(lastUpdated);
    return difference.inHours < 24;
  }

  Map<String, dynamic> toJson() {
    return {
      'categories': categories,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  static CategoryCacheModel fromCategoryList(List<String> categories) {
    return CategoryCacheModel(
      categories: categories,
      lastUpdated: DateTime.now(),
    );
  }
}

