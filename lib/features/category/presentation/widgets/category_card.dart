import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task/core/routing/extensions.dart';

import '../../../../core/routing/routes.dart';

class CategoryCard extends StatelessWidget {
  final String categoryName;
  final VoidCallback? onTap;

  const CategoryCard({super.key, required this.categoryName, this.onTap});

  @override
  Widget build(BuildContext context) {
    final categoryData = _getCategoryData(categoryName);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: categoryData['gradientColors'],
        ),
        boxShadow: [
          BoxShadow(
            color: categoryData['gradientColors'][0].withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            context.pushNamed(Routes.productsScreen);
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    categoryData['icon'],
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  categoryName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  Map<String, dynamic> _getCategoryData(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'electronics':
        return {
          'icon': Icons.devices,
          'gradientColors': [const Color(0xFF667eea), const Color(0xFF764ba2)],
        };
      case 'jewelery':
        return {
          'icon': Icons.diamond_outlined,
          'gradientColors': [const Color(0xFFf093fb), const Color(0xFFf5576c)],
        };
      case "men's clothing":
        return {
          'icon': Icons.checkroom,
          'gradientColors': [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
        };
      case "women's clothing":
        return {
          'icon': Icons.woman,
          'gradientColors': [const Color(0xFFfa709a), const Color(0xFFfee140)],
        };
      default:
        return {
          'icon': Icons.category,
          'gradientColors': [const Color(0xFF6c757d), const Color(0xFF495057)],
        };
    }
  }

}
