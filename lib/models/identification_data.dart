import 'package:hive/hive.dart';

part 'identification_data.g.dart';

@HiveType(typeId: 1)
class IdentificationData extends HiveObject {
  @HiveField(0)
  String? userId;
  
  @HiveField(1)
  DateTime birthDate;
  
  @HiveField(2)
  int age;
  
  @HiveField(3)
  String gender;
  
  @HiveField(4)
  String phone;
  
  @HiveField(5)
  String address;
  
  @HiveField(6)
  DateTime createdAt;
  
  @HiveField(7)
  DateTime updatedAt;
  
  IdentificationData({
    this.userId,
    required this.birthDate,
    required this.age,
    required this.gender,
    required this.phone,
    required this.address,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : 
    this.createdAt = createdAt ?? DateTime.now(),
    this.updatedAt = updatedAt ?? DateTime.now();
  
  // Método para convertir a Map para Firebase
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'birthDate': birthDate.millisecondsSinceEpoch,
      'age': age,
      'gender': gender,
      'phone': phone,
      'address': address,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }
  
  // Método para crear desde Map de Firebase
  factory IdentificationData.fromMap(Map<String, dynamic> map) {
    return IdentificationData(
      userId: map['userId'],
      birthDate: DateTime.fromMillisecondsSinceEpoch(map['birthDate']),
      age: map['age'],
      gender: map['gender'],
      phone: map['phone'],
      address: map['address'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }
}