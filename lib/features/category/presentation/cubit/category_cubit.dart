import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecase/get_category_use_case.dart';
import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final GetCategoryUseCase getCategoryUseCase;

  CategoryCubit({required this.getCategoryUseCase}) : super(CategoryInitial());

  Future<void> getCategories() async {
    emit(CategoryLoading());

    final result = await getCategoryUseCase.getCategories();

    result.fold(
      (failure) => emit(CategoryError(message: failure.message)),
      (categoryEntity) => emit(CategoryLoaded(categoryEntity: categoryEntity)),
    );
  }
}

