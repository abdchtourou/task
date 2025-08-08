import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:task/core/routing/extensions.dart';
import 'package:task/core/routing/routes.dart';
import '../../domain/entity/product_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/details/product_details_cubit.dart';
import '../screen/product_details_screen.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final ProductItemEntity product;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            context.pushNamed(
              Routes.productDetailsScreen,
              arguments:  product.id,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: const Color(0xFFF3F4F6),
                          ),
                          child: Center(
                            child: CachedNetworkImage(
                              imageUrl: product.image,
                              fit: BoxFit.contain,
                              placeholder:
                                  (context, url) => const Icon(
                                    Icons.image,
                                    size: 48,
                                    color: Color(0xFFA0AEC0),
                                  ),
                              errorWidget:
                                  (context, url, error) => const Icon(
                                    Icons.image,
                                    size: 48,
                                    color: Color(0xFFA0AEC0),
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  product.title,
                  maxLines: 2,

                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _buildStars(product.rate),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF667eea).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Color(0xFF667eea),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStars(double rating) {
    final int fullStars = rating.floor();
    final bool hasHalf = (rating - fullStars) >= 0.5;
    return Row(
      children: [
        for (int i = 0; i < fullStars; i++)
          const Icon(Icons.star, color: Color(0xFFFFC107), size: 14),
        if (hasHalf)
          const Icon(Icons.star_half, color: Color(0xFFFFC107), size: 14),
        for (int i = 0; i < (5 - fullStars - (hasHalf ? 1 : 0)); i++)
          const Icon(Icons.star_border, color: Color(0xFFFFC107), size: 14),
      ],
    );
  }
}
