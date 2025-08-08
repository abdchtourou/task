import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/core/di/dependency_injection.dart';
import 'package:task/core/routing/routes.dart';
import 'package:task/features/category/presentation/cubit/category_cubit.dart';
import 'package:task/features/product/presentation/cubit/details/product_details_cubit.dart';

import '../../features/auth/presentation/screen/login_screen.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/category/presentation/screen/category_screen.dart';
import '../../features/product/presentation/screen/product_details_screen.dart';
import '../../features/product/presentation/screen/product_screen.dart';
import '../../features/product/presentation/cubit/product_cubit.dart';
import '../../features/splash/presentation/screen/splash_screen.dart';
import '../../features/splash/presentation/cubit/splash_cubit.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    switch (settings.name) {
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder:
              (context) => BlocProvider(
                create: (_) => getIt<AuthCubit>(),
                child: const LoginScreen(),
              ),
        );
  
      case Routes.categoryScreen:
        return MaterialPageRoute(
          builder:
              (context) => BlocProvider(
                create: (context) => getIt<CategoryCubit>()..getCategories(),
                child: CategoryScreen(),
              ),
        );
      case Routes.splashScreen:
        return MaterialPageRoute(
          builder:
              (context) => BlocProvider(
                create: (_) => getIt<SplashCubit>(),
                child: const SplashScreen(),
              ),
        );
      case Routes.productsScreen:
        return MaterialPageRoute(
          builder:
              (context) => BlocProvider(
                create: (context) => getIt<ProductCubit>()..getProducts(),
                child: const ProductScreen(),
              ),
        );
      case Routes.productDetailsScreen:
        final int id = arguments as int;
        return MaterialPageRoute(
          builder:
              (context) => BlocProvider(
                create: (context) => getIt<ProductDetailsCubit>()..load(id),
                child: ProductDetailsScreen(),
              ),
        );
      default:
    }
    return null;
  }
}
