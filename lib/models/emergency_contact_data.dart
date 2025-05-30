import 'package:hive/hive.dart';

part 'emergency_contact_data.g.dart';

@HiveType(typeId: 5)
class EmergencyContactData extends HiveObject {
  @HiveField(0)
  String? userId;
  
  @HiveField(1)
  Map<String, String> primaryContact; // Contacto primario (nombre, relación, teléfono)
  
  @HiveField(2)
  List<Map<String, String>> secondaryContacts; // Contactos secundarios
  
  @HiveField(3)
  List<Map<String, String>> emergencyDoctors; // Médicos de emergencia
  
  @HiveField(4)
  DateTime createdAt;
  
  @HiveField(5)
  DateTime updatedAt;
  
  EmergencyContactData({
    this.userId,
    required this.primaryContact,
    required this.secondaryContacts,
    required this.emergencyDoctors,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : 
    this.createdAt = createdAt ?? DateTime.now(),
    this.updatedAt = updatedAt ?? DateTime.now();
  
  // Método para convertir a Map para Firebase
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'primaryContact': primaryContact,
      'secondaryContacts': secondaryContacts,
      'emergencyDoctors': emergencyDoctors,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }
  
  // Método para crear desde Map de Firebase
  factory EmergencyContactData.fromMap(Map<String, dynamic> map) {
    return EmergencyContactData(
      userId: map['userId'],
      primaryContact: Map<String, String>.from(map['primaryContact']),
      secondaryContacts: List<Map<String, String>>.from(
        map['secondaryContacts'].map((contact) => Map<String, String>.from(contact))
      ),
      emergencyDoctors: List<Map<String, String>>.from(
        map['emergencyDoctors'].map((doctor) => Map<String, String>.from(doctor))
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }
}