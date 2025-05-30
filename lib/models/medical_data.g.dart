// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedicalDataAdapter extends TypeAdapter<MedicalData> {
  @override
  final int typeId = 3;

  @override
  MedicalData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedicalData(
      userId: fields[0] as String?,
      bloodType: fields[1] as String,
      rhFactor: fields[2] as String,
      allergies: (fields[3] as List).cast<String>(),
      customAllergies: (fields[4] as List).cast<String>(),
      chronicDiseases: (fields[5] as List).cast<String>(),
      customChronicDiseases: (fields[6] as List).cast<String>(),
      primaryDoctors: (fields[7] as List)
          .map((dynamic e) => (e as Map).cast<String, String>())
          .toList(),
      healthInsuranceType: fields[8] as String,
      healthInsuranceDetail: fields[9] as String,
      createdAt: fields[10] as DateTime?,
      updatedAt: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, MedicalData obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.bloodType)
      ..writeByte(2)
      ..write(obj.rhFactor)
      ..writeByte(3)
      ..write(obj.allergies)
      ..writeByte(4)
      ..write(obj.customAllergies)
      ..writeByte(5)
      ..write(obj.chronicDiseases)
      ..writeByte(6)
      ..write(obj.customChronicDiseases)
      ..writeByte(7)
      ..write(obj.primaryDoctors)
      ..writeByte(8)
      ..write(obj.healthInsuranceType)
      ..writeByte(9)
      ..write(obj.healthInsuranceDetail)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicalDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
