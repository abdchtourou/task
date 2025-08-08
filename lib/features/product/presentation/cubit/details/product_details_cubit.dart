import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/features/product/presentation/cubit/details/product_details_state.dart';
import '../../../domain/usecase/get_product_details_use_case.dart';
import '../../../domain/entity/product_entity.dart';


class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final GetProductDetailsUseCase getProductDetailsUseCase;
  ProductDetailsCubit({required this.getProductDetailsUseCase})
    : super(ProductDetailsInitial());

  Future<void> load(int id) async {
    emit(ProductDetailsLoading());
    final result = await getProductDetailsUseCase(id);
    result.fold(
      (failure) => emit(ProductDetailsError(failure.message)),
      (item) => emit(ProductDetailsLoaded(item)),
    );
  }
}
