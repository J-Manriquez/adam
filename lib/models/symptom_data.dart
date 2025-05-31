import 'package:hive/hive.dart';

part 'symptom_data.g.dart';

@HiveType(typeId: 7) // Cambiado de 6 a 7
class SymptomData extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime recordDate;

  @HiveField(2)
  String? symptomType;

  @HiveField(3)
  String? detailedDescription;

  @HiveField(4)
  int? painLevel; // Escala 1-10

  @HiveField(5)
  List<String>? painLocation;

  @HiveField(6)
  DateTime? startTime;

  @HiveField(7)
  int? estimatedDuration;

  @HiveField(8)
  String? durationUnit; // "minuto(s)", "hora(s)", "dia(s)"

  @HiveField(9)
  String? frequency; // "primera vez", "ocasional", "frecuente"

  @HiveField(10)
  String? activityAtOnset;

  @HiveField(11)
  String? triggers;

  @HiveField(12)
  List<String>? vitalSignChanges;

  @HiveField(13)
  String? otherVitalSignChange;

  @HiveField(14)
  String? affectedFunctionality; // "puede caminar", "necesita ayuda", "no aplica"

  @HiveField(15)
  String userId; // Para asociar con el usuario

  SymptomData({
    required this.id,
    required this.recordDate,
    this.symptomType,
    this.detailedDescription,
    this.painLevel,
    this.painLocation,
    this.startTime,
    this.estimatedDuration,
    this.durationUnit,
    this.frequency,
    this.activityAtOnset,
    this.triggers,
    this.vitalSignChanges,
    this.otherVitalSignChange,
    this.affectedFunctionality,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'recordDate': recordDate.toIso8601String(),
      'symptomType': symptomType,
      'detailedDescription': detailedDescription,
      'painLevel': painLevel,
      'painLocation': painLocation,
      'startTime': startTime?.toIso8601String(),
      'estimatedDuration': estimatedDuration,
      'durationUnit': durationUnit,
      'frequency': frequency,
      'activityAtOnset': activityAtOnset,
      'triggers': triggers,
      'vitalSignChanges': vitalSignChanges,
      'otherVitalSignChange': otherVitalSignChange,
      'affectedFunctionality': affectedFunctionality,
      'userId': userId,
    };
  }

  factory SymptomData.fromMap(Map<String, dynamic> map, String id) {
    return SymptomData(
      id: id,
      recordDate: DateTime.parse(map['recordDate']),
      symptomType: map['symptomType'],
      detailedDescription: map['detailedDescription'],
      painLevel: map['painLevel'],
      painLocation: List<String>.from(map['painLocation'] ?? []),
      startTime: map['startTime'] != null ? DateTime.parse(map['startTime']) : null,
      estimatedDuration: map['estimatedDuration'],
      durationUnit: map['durationUnit'],
      frequency: map['frequency'],
      activityAtOnset: map['activityAtOnset'],
      triggers: map['triggers'],
      vitalSignChanges: List<String>.from(map['vitalSignChanges'] ?? []),
      otherVitalSignChange: map['otherVitalSignChange'],
      affectedFunctionality: map['affectedFunctionality'],
      userId: map['userId'],
    );
  }
}