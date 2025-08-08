// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_item_cache_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductItemCacheModelAdapter extends TypeAdapter<ProductItemCacheModel> {
  @override
  final int typeId = 2;

  @override
  ProductItemCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductItemCacheModel(
      id: fields[0] as int,
      title: fields[1] as String,
      price: fields[2] as double,
      description: fields[3] as String,
      category: fields[4] as String,
      image: fields[5] as String,
      rate: fields[6] as double,
      count: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ProductItemCacheModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.image)
      ..writeByte(6)
      ..write(obj.rate)
      ..writeByte(7)
      ..write(obj.count);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductItemCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
