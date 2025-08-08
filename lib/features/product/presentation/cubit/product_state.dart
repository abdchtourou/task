import 'package:equatable/equatable.dart';
import '../../domain/entity/product_entity.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final ProductEntity productEntity;

  const ProductLoaded({required this.productEntity});

  @override
  List<Object?> get props => [productEntity];
}

class ProductError extends ProductState {
  final String message;

  const ProductError({required this.message});

  @override
  List<Object?> get props => [message];
}

