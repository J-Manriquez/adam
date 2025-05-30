import 'package:hive/hive.dart';

part 'lifestyle_data.g.dart';

@HiveType(typeId: 4)
class LifestyleData extends HiveObject {
  @HiveField(0)
  String? userId;
  
  @HiveField(1)
  List<String> physicalHobbies; // Pasatiempos físicos
  
  @HiveField(2)
  List<String> customPhysicalHobbies; // Pasatiempos físicos personalizados
  
  @HiveField(3)
  String physicalActivityFrequency; // Frecuencia de actividad física
  
  @HiveField(4)
  List<String> mentalHobbies; // Pasatiempos mentales
  
  @HiveField(5)
  List<String> customMentalHobbies; // Pasatiempos mentales personalizados
  
  @HiveField(6)
  List<String> eatingHabits; // Hábitos alimentarios
  
  @HiveField(7)
  List<String> customEatingHabits; // Hábitos alimentarios personalizados
  
  @HiveField(8)
  List<String> dietaryRestrictions; // Restricciones dietéticas
  
  @HiveField(9)
  List<String> customDietaryRestrictions; // Restricciones dietéticas personalizadas
  
  @HiveField(10)
  bool alcoholConsumption; // Consumo de alcohol
  
  @HiveField(11)
  bool tobaccoConsumption; // Consumo de tabaco
  
  @HiveField(12)
  DateTime createdAt;
  
  @HiveField(13)
  DateTime updatedAt;
  
  LifestyleData({
    this.userId,
    required this.physicalHobbies,
    this.customPhysicalHobbies = const [],
    required this.physicalActivityFrequency,
    required this.mentalHobbies,
    this.customMentalHobbies = const [],
    required this.eatingHabits,
    this.customEatingHabits = const [],
    required this.dietaryRestrictions,
    this.customDietaryRestrictions = const [],
    required this.alcoholConsumption,
    required this.tobaccoConsumption,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : 
    this.createdAt = createdAt ?? DateTime.now(),
    this.updatedAt = updatedAt ?? DateTime.now();
  
  // Método para convertir a Map para Firebase
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'physicalHobbies': physicalHobbies,
      'customPhysicalHobbies': customPhysicalHobbies,
      'physicalActivityFrequency': physicalActivityFrequency,
      'mentalHobbies': mentalHobbies,
      'customMentalHobbies': customMentalHobbies,
      'eatingHabits': eatingHabits,
      'customEatingHabits': customEatingHabits,
      'dietaryRestrictions': dietaryRestrictions,
      'customDietaryRestrictions': customDietaryRestrictions,
      'alcoholConsumption': alcoholConsumption,
      'tobaccoConsumption': tobaccoConsumption,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }
  
  // Método para crear desde Map de Firebase
  factory LifestyleData.fromMap(Map<String, dynamic> map) {
    return LifestyleData(
      userId: map['userId'],
      physicalHobbies: List<String>.from(map['physicalHobbies']),
      customPhysicalHobbies: List<String>.from(map['customPhysicalHobbies']),
      physicalActivityFrequency: map['physicalActivityFrequency'],
      mentalHobbies: List<String>.from(map['mentalHobbies']),
      customMentalHobbies: List<String>.from(map['customMentalHobbies']),
      eatingHabits: List<String>.from(map['eatingHabits']),
      customEatingHabits: List<String>.from(map['customEatingHabits']),
      dietaryRestrictions: List<String>.from(map['dietaryRestrictions']),
      customDietaryRestrictions: List<String>.from(map['customDietaryRestrictions']),
      alcoholConsumption: map['alcoholConsumption'],
      tobaccoConsumption: map['tobaccoConsumption'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }
}