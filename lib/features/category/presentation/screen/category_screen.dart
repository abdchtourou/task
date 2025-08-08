import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/core/routing/routes.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../cubit/category_cubit.dart';
import '../cubit/category_state.dart';
import '../widgets/categories_grid.dart';
import '../widgets/animated_header.dart';
import '../widgets/error_state.dart';
import '../widgets/loading_state.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AnimatedHeader(),
            Expanded(
              child: BlocBuilder<CategoryCubit, CategoryState>(
                builder: (context, state) {
                  if (state is CategoryLoading) {
                    return LoadingState();
                  } else if (state is CategoryLoaded) {
                    return CategoriesGrid(
                      categories: state.categoryEntity.categories,
                    );
                  } else if (state is CategoryError) {
                    return ErrorState(message: state.message);
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
