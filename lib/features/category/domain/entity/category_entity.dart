import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final List<String> categories;

  const CategoryEntity({required this.categories});

  @override
  List<Object?> get props => [categories];
}
