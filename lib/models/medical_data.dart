import 'package:hive/hive.dart';

part 'medical_data.g.dart';

@HiveType(typeId: 3)
class MedicalData extends HiveObject {
  @HiveField(0)
  String? userId;
  
  @HiveField(1)
  String bloodType; // Tipo de sangre
  
  @HiveField(2)
  String rhFactor; // Factor RH
  
  @HiveField(3)
  List<String> allergies; // Alergias conocidas
  
  @HiveField(4)
  List<String> customAllergies; // Alergias personalizadas
  
  @HiveField(5)
  List<String> chronicDiseases; // Enfermedades crónicas
  
  @HiveField(6)
  List<String> customChronicDiseases; // Enfermedades crónicas personalizadas
  
  @HiveField(7)
  List<Map<String, String>> primaryDoctors; // Médicos de cabecera
  
  @HiveField(8)
  String healthInsuranceType; // Fonasa o Isapre
  
  @HiveField(9)
  String healthInsuranceDetail; // Letra Fonasa o nombre Isapre
  
  @HiveField(10)
  DateTime createdAt;
  
  @HiveField(11)
  DateTime updatedAt;
  
  MedicalData({
    this.userId,
    required this.bloodType,
    required this.rhFactor,
    required this.allergies,
    this.customAllergies = const [],
    required this.chronicDiseases,
    this.customChronicDiseases = const [],
    required this.primaryDoctors,
    required this.healthInsuranceType,
    required this.healthInsuranceDetail,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : 
    this.createdAt = createdAt ?? DateTime.now(),
    this.updatedAt = updatedAt ?? DateTime.now();
  
  // Método para convertir a Map para Firebase
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'bloodType': bloodType,
      'rhFactor': rhFactor,
      'allergies': allergies,
      'customAllergies': customAllergies,
      'chronicDiseases': chronicDiseases,
      'customChronicDiseases': customChronicDiseases,
      'primaryDoctors': primaryDoctors,
      'healthInsuranceType': healthInsuranceType,
      'healthInsuranceDetail': healthInsuranceDetail,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }
  
  // Método para crear desde Map de Firebase
  factory MedicalData.fromMap(Map<String, dynamic> map) {
    return MedicalData(
      userId: map['userId'],
      bloodType: map['bloodType'],
      rhFactor: map['rhFactor'],
      allergies: List<String>.from(map['allergies']),
      customAllergies: List<String>.from(map['customAllergies']),
      chronicDiseases: List<String>.from(map['chronicDiseases']),
      customChronicDiseases: List<String>.from(map['customChronicDiseases']),
      primaryDoctors: List<Map<String, String>>.from(
        map['primaryDoctors'].map((doctor) => Map<String, String>.from(doctor))
      ),
      healthInsuranceType: map['healthInsuranceType'],
      healthInsuranceDetail: map['healthInsuranceDetail'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }
}