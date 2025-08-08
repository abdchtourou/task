import '../../domain/entity/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({required super.categories});

  factory CategoryModel.fromJson(List<dynamic> json) {
    return CategoryModel(categories: json.cast<String>());
  }

  List<dynamic> toJson() {
    return categories;
  }
}
