import 'package:flutter/material.dart';
import '../../domain/entity/product_entity.dart';

import 'product_card.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({super.key, required this.products});

  final List<ProductItemEntity> products;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 10,
          childAspectRatio: 0.70,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => ProductCard(product: products[index]),
          childCount: products.length,
        ),
      ),
    );
  }
}
