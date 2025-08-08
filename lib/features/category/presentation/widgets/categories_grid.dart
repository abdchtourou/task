import 'package:flutter/material.dart';

import 'category_card.dart';

class CategoriesGrid extends StatelessWidget {
  const CategoriesGrid({super.key, required this.categories});
  final List<String> categories;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 0.9,
        ),
        itemBuilder: (context, index) {
          return CategoryCard(
            categoryName: categories[index],
            onTap: () => _onCategoryTap(context, categories[index]),
          );
        },
      ),
    );
  }
}
void _onCategoryTap(BuildContext context, String categoryName) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Selected: $categoryName'),
      backgroundColor: const Color(0xFF667eea),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    ),
  );
}
