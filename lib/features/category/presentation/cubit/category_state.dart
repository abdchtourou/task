import 'package:equatable/equatable.dart';
import '../../domain/entity/category_entity.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final CategoryEntity categoryEntity;

  const CategoryLoaded({required this.categoryEntity});

  @override
  List<Object?> get props => [categoryEntity];
}

class CategoryError extends CategoryState {
  final String message;

  const CategoryError({required this.message});

  @override
  List<Object?> get props => [message];
}

