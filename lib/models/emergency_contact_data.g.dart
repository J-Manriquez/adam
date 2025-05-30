// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emergency_contact_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmergencyContactDataAdapter extends TypeAdapter<EmergencyContactData> {
  @override
  final int typeId = 5;

  @override
  EmergencyContactData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EmergencyContactData(
      userId: fields[0] as String?,
      primaryContact: (fields[1] as Map).cast<String, String>(),
      secondaryContacts: (fields[2] as List)
          .map((dynamic e) => (e as Map).cast<String, String>())
          .toList(),
      emergencyDoctors: (fields[3] as List)
          .map((dynamic e) => (e as Map).cast<String, String>())
          .toList(),
      createdAt: fields[4] as DateTime?,
      updatedAt: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, EmergencyContactData obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.primaryContact)
      ..writeByte(2)
      ..write(obj.secondaryContacts)
      ..writeByte(3)
      ..write(obj.emergencyDoctors)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmergencyContactDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
