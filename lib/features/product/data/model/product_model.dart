import '../../domain/entity/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({required super.products});

  factory ProductModel.fromJson(List<dynamic> json) {
    final items =
        json
            .map((e) => ProductItemModel.fromMap(e as Map<String, dynamic>))
            .toList();
    return ProductModel(products: items);
  }
}

class ProductItemModel extends ProductItemEntity {
  const ProductItemModel({
    required super.id,
    required super.title,
    required super.price,
    required super.description,
    required super.category,
    required super.image,
    required super.rate,
    required super.count,
  });

  factory ProductItemModel.fromMap(Map<String, dynamic> map) {
    final rating = map['rating'] as Map<String, dynamic>?;
    return ProductItemModel(
      id: (map['id'] as num).toInt(),
      title: map['title'] as String? ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      description: map['description'] as String? ?? '',
      category: map['category'] as String? ?? '',
      image: map['image'] as String? ?? '',
      rate: (rating?['rate'] as num?)?.toDouble() ?? 0.0,
      count: (rating?['count'] as num?)?.toInt() ?? 0,
    );
  }
}

