import 'package:hive/hive.dart';

part 'health_data.g.dart';

@HiveType(typeId: 2)
class HealthData extends HiveObject {
  @HiveField(0)
  String? userId;
  
  @HiveField(1)
  double weight; // en kg
  
  @HiveField(2)
  double height; // en cm
  
  @HiveField(3)
  String? bloodPressure; // Ejemplo: "120/80"
  
  @HiveField(4)
  String mobilityLevel; // "independiente", "con ayuda", "silla de ruedas"
  
  @HiveField(5)
  String? physicalLimitations;
  
  @HiveField(6)
  List<String> supportDevices; // Lista de dispositivos de apoyo
  
  @HiveField(7)
  DateTime createdAt;
  
  @HiveField(8)
  DateTime updatedAt;
  
  HealthData({
    this.userId,
    required this.weight,
    required this.height,
    this.bloodPressure,
    required this.mobilityLevel,
    this.physicalLimitations,
    required this.supportDevices,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : 
    this.createdAt = createdAt ?? DateTime.now(),
    this.updatedAt = updatedAt ?? DateTime.now();
  
  // Método para convertir a Map para Firebase
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'weight': weight,
      'height': height,
      'bloodPressure': bloodPressure,
      'mobilityLevel': mobilityLevel,
      'physicalLimitations': physicalLimitations,
      'supportDevices': supportDevices,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }
  
  // Método para crear desde Map de Firebase
  factory HealthData.fromMap(Map<String, dynamic> map) {
    return HealthData(
      userId: map['userId'],
      weight: map['weight'].toDouble(),
      height: map['height'].toDouble(),
      bloodPressure: map['bloodPressure'],
      mobilityLevel: map['mobilityLevel'],
      physicalLimitations: map['physicalLimitations'],
      supportDevices: List<String>.from(map['supportDevices']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }
}