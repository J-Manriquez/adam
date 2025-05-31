// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedicationDataAdapter extends TypeAdapter<MedicationData> {
  @override
  final int typeId = 6;

  @override
  MedicationData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedicationData(
      id: fields[0] as String,
      userId: fields[1] as String?,
      name: fields[2] as String,
      concentration: fields[3] as String,
      concentrationUnit: fields[4] as String,
      form: fields[5] as String,
      frequency: fields[6] as int,
      startTime: fields[7] as DateTime,
      isIndefinite: fields[8] as bool,
      durationDays: fields[9] as int?,
      startDate: fields[10] as DateTime,
      endDate: fields[11] as DateTime?,
      specialInstructions: fields[12] as String,
      createdAt: fields[13] as DateTime?,
      updatedAt: fields[14] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, MedicationData obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.concentration)
      ..writeByte(4)
      ..write(obj.concentrationUnit)
      ..writeByte(5)
      ..write(obj.form)
      ..writeByte(6)
      ..write(obj.frequency)
      ..writeByte(7)
      ..write(obj.startTime)
      ..writeByte(8)
      ..write(obj.isIndefinite)
      ..writeByte(9)
      ..write(obj.durationDays)
      ..writeByte(10)
      ..write(obj.startDate)
      ..writeByte(11)
      ..write(obj.endDate)
      ..writeByte(12)
      ..write(obj.specialInstructions)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicationDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
