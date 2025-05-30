// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'identification_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IdentificationDataAdapter extends TypeAdapter<IdentificationData> {
  @override
  final int typeId = 1;

  @override
  IdentificationData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IdentificationData(
      userId: fields[0] as String?,
      birthDate: fields[1] as DateTime,
      age: fields[2] as int,
      gender: fields[3] as String,
      phone: fields[4] as String,
      address: fields[5] as String,
      createdAt: fields[6] as DateTime?,
      updatedAt: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, IdentificationData obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.birthDate)
      ..writeByte(2)
      ..write(obj.age)
      ..writeByte(3)
      ..write(obj.gender)
      ..writeByte(4)
      ..write(obj.phone)
      ..writeByte(5)
      ..write(obj.address)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IdentificationDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
