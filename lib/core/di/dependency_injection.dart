import 'package:get_it/get_it.dart';
import 'package:task/core/network/api_helper.dart';
import 'package:task/core/storage/hive_helper.dart';
import 'package:task/core/network/network_helper.dart';
import 'package:task/features/category/data/datasource/remote/category_remote_data_source.dart';
import 'package:task/features/category/data/datasource/local/category_local_data_source.dart';
import 'package:task/features/category/data/repository/category_repository_impl.dart';
import 'package:task/features/category/domain/repository/category_repo.dart';
import 'package:task/features/category/domain/usecase/get_category_use_case.dart';
import 'package:task/features/category/presentation/cubit/category_cubit.dart';
import 'package:task/features/product/data/datasource/local/product_local_data_source.dart';
import 'package:task/features/product/data/datasource/remote/product_remote_data_source.dart';
import 'package:task/features/product/data/repository/product_repository_impl.dart';
import 'package:task/features/product/domain/repository/product_repo.dart';
import 'package:task/features/product/domain/usecase/get_product_use_case.dart';
import 'package:task/features/product/domain/usecase/get_product_details_use_case.dart';
import 'package:task/features/product/presentation/cubit/details/product_details_cubit.dart';
import 'package:task/features/product/presentation/cubit/product_cubit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:task/features/auth/data/datasource/local/auth_local_data_source.dart';
import 'package:task/features/auth/data/repository/auth_repository_impl.dart';
import 'package:task/features/auth/domain/repository/auth_repo.dart';
import 'package:task/features/auth/domain/usecase/get_current_user_use_case.dart';
import 'package:task/features/auth/domain/usecase/login_use_case.dart';
import 'package:task/features/auth/domain/usecase/logout_use_case.dart';
import 'package:task/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:task/features/splash/presentation/cubit/splash_cubit.dart';

final getIt = GetIt.instance;

Future<void> setUpGetIt() async {
  await HiveHelper.init();

  await NetworkHelper.initialize();

  getIt.registerLazySingleton<ApiHelper>(() {
    final apiHelper = ApiHelper();
    apiHelper.init();
    return apiHelper;
  });

  getIt.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(apiHelper: getIt()),
  );
  getIt.registerLazySingleton<CategoryLocalDataSource>(
    () => CategoryLocalDataSourceImpl(),
  );
  getIt.registerLazySingleton<CategoryRepo>(
    () => CategoryRepositoryImpl(
      categoryRemoteDataSource: getIt(),
      categoryLocalDataSource: getIt(),
    ),
  );
  getIt.registerLazySingleton<GetCategoryUseCase>(
    () => GetCategoryUseCase(categoryRepo: getIt()),
  );
  getIt.registerFactory<CategoryCubit>(
    () => CategoryCubit(getCategoryUseCase: getIt()),
  );

  getIt.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(apiHelper: getIt()),
  );
  getIt.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(),
  );
  getIt.registerLazySingleton<ProductRepo>(
    () => ProductRepositoryImpl(
      productRemoteDataSource: getIt(),
      productLocalDataSource: getIt(),
    ),
  );
  getIt.registerLazySingleton<GetProductUseCase>(
    () => GetProductUseCase(productRepo: getIt()),
  );
  getIt.registerFactory<ProductCubit>(
    () => ProductCubit(getProductUseCase: getIt()),
  );
  getIt.registerLazySingleton<GetProductDetailsUseCase>(
    () => GetProductDetailsUseCase(productRepo: getIt()),
  );
  getIt.registerFactory<ProductDetailsCubit>(
    () => ProductDetailsCubit(getProductDetailsUseCase: getIt()),
  );

  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(secureStorage: getIt()),
  );
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepositoryImpl(authLocalDataSource: getIt()),
  );
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(authRepo: getIt()),
  );
  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(authRepo: getIt()),
  );
  getIt.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(authRepo: getIt()),
  );
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(
      loginUseCase: getIt(),
      logoutUseCase: getIt(),
      getCurrentUserUseCase: getIt(),
    ),
  );

  getIt.registerLazySingleton<SplashCubit>(
    () => SplashCubit(getCurrentUserUseCase: getIt()),
  );
}
