// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quantity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FoodQuantityAdapter extends TypeAdapter<FoodQuantity> {
  @override
  final int typeId = 2;

  @override
  FoodQuantity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FoodQuantity(
      id: fields[0] as String,
      food: fields[1] as Food,
      weight: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, FoodQuantity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.food)
      ..writeByte(2)
      ..write(obj.weight);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodQuantityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
