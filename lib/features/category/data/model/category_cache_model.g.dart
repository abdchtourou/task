// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_cache_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoryCacheModelAdapter extends TypeAdapter<CategoryCacheModel> {
  @override
  final int typeId = 0;

  @override
  CategoryCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoryCacheModel(
      categories: (fields[0] as List).cast<String>(),
      lastUpdated: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CategoryCacheModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.categories)
      ..writeByte(1)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
