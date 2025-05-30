// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lifestyle_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LifestyleDataAdapter extends TypeAdapter<LifestyleData> {
  @override
  final int typeId = 4;

  @override
  LifestyleData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LifestyleData(
      userId: fields[0] as String?,
      physicalHobbies: (fields[1] as List).cast<String>(),
      customPhysicalHobbies: (fields[2] as List).cast<String>(),
      physicalActivityFrequency: fields[3] as String,
      mentalHobbies: (fields[4] as List).cast<String>(),
      customMentalHobbies: (fields[5] as List).cast<String>(),
      eatingHabits: (fields[6] as List).cast<String>(),
      customEatingHabits: (fields[7] as List).cast<String>(),
      dietaryRestrictions: (fields[8] as List).cast<String>(),
      customDietaryRestrictions: (fields[9] as List).cast<String>(),
      alcoholConsumption: fields[10] as bool,
      tobaccoConsumption: fields[11] as bool,
      createdAt: fields[12] as DateTime?,
      updatedAt: fields[13] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, LifestyleData obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.physicalHobbies)
      ..writeByte(2)
      ..write(obj.customPhysicalHobbies)
      ..writeByte(3)
      ..write(obj.physicalActivityFrequency)
      ..writeByte(4)
      ..write(obj.mentalHobbies)
      ..writeByte(5)
      ..write(obj.customMentalHobbies)
      ..writeByte(6)
      ..write(obj.eatingHabits)
      ..writeByte(7)
      ..write(obj.customEatingHabits)
      ..writeByte(8)
      ..write(obj.dietaryRestrictions)
      ..writeByte(9)
      ..write(obj.customDietaryRestrictions)
      ..writeByte(10)
      ..write(obj.alcoholConsumption)
      ..writeByte(11)
      ..write(obj.tobaccoConsumption)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LifestyleDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
