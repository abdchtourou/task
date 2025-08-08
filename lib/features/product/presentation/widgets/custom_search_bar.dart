import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/product_cubit.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: TextField(
              controller: controller,
              onChanged:
                  (value) => context.read<ProductCubit>().filterProducts(value),
              decoration: InputDecoration(
                hintText: 'Search products... ',
                hintStyle: const TextStyle(color: Color(0xFFA0AEC0)),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF718096)),
                suffixIcon: IconButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    controller.clear();
                    context.read<ProductCubit>().filterProducts('');
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Color(0xFFCBD5E0),
                  ),
                  tooltip: 'Clear',
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
