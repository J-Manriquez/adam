// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'symptom_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SymptomDataAdapter extends TypeAdapter<SymptomData> {
  @override
  final int typeId = 7;

  @override
  SymptomData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SymptomData(
      id: fields[0] as String,
      recordDate: fields[1] as DateTime,
      symptomType: fields[2] as String?,
      detailedDescription: fields[3] as String?,
      painLevel: fields[4] as int?,
      painLocation: (fields[5] as List?)?.cast<String>(),
      startTime: fields[6] as DateTime?,
      estimatedDuration: fields[7] as int?,
      durationUnit: fields[8] as String?,
      frequency: fields[9] as String?,
      activityAtOnset: fields[10] as String?,
      triggers: fields[11] as String?,
      vitalSignChanges: (fields[12] as List?)?.cast<String>(),
      otherVitalSignChange: fields[13] as String?,
      affectedFunctionality: fields[14] as String?,
      userId: fields[15] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SymptomData obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.recordDate)
      ..writeByte(2)
      ..write(obj.symptomType)
      ..writeByte(3)
      ..write(obj.detailedDescription)
      ..writeByte(4)
      ..write(obj.painLevel)
      ..writeByte(5)
      ..write(obj.painLocation)
      ..writeByte(6)
      ..write(obj.startTime)
      ..writeByte(7)
      ..write(obj.estimatedDuration)
      ..writeByte(8)
      ..write(obj.durationUnit)
      ..writeByte(9)
      ..write(obj.frequency)
      ..writeByte(10)
      ..write(obj.activityAtOnset)
      ..writeByte(11)
      ..write(obj.triggers)
      ..writeByte(12)
      ..write(obj.vitalSignChanges)
      ..writeByte(13)
      ..write(obj.otherVitalSignChange)
      ..writeByte(14)
      ..write(obj.affectedFunctionality)
      ..writeByte(15)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SymptomDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
