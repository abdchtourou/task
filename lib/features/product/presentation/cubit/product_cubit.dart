import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecase/get_product_use_case.dart';
import '../../domain/entity/product_entity.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetProductUseCase getProductUseCase;

  ProductCubit({required this.getProductUseCase}) : super(ProductInitial());

  List<ProductItemEntity> _allProducts = [];

  Future<void> getProducts() async {
    emit(ProductLoading());
    final result = await getProductUseCase.getProducts();
    result.fold((failure) => emit(ProductError(message: failure.message)), (
      productEntity,
    ) {
      _allProducts = productEntity.products;
      emit(ProductLoaded(productEntity: productEntity));
    });
  }

  void filterProducts(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      emit(ProductLoaded(productEntity: ProductEntity(products: _allProducts)));
      return;
    }
    final lowered = trimmed.toLowerCase();
    final filtered =
        _allProducts
            .where((p) => p.title.toLowerCase().contains(lowered))
            .toList();
    emit(ProductLoaded(productEntity: ProductEntity(products: filtered)));
  }
}
