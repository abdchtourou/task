// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_list_cache_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductListCacheModelAdapter extends TypeAdapter<ProductListCacheModel> {
  @override
  final int typeId = 3;

  @override
  ProductListCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductListCacheModel(
      products: (fields[0] as List).cast<ProductItemCacheModel>(),
      lastUpdated: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ProductListCacheModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.products)
      ..writeByte(1)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductListCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
