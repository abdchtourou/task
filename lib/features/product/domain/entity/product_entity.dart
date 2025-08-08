import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final List<ProductItemEntity> products;

  const ProductEntity({required this.products});

  @override
  List<Object?> get props => [products];
}

class ProductItemEntity extends Equatable {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final double rate;
  final int count;

  const ProductItemEntity({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rate,
    required this.count,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    price,
    description,
    category,
    image,
    rate,
    count,
  ];
}

