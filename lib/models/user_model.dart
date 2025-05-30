import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String fullName;

  @HiveField(2)
  String email;

  @HiveField(3)
  bool syncWithFirebase;

  @HiveField(4)
  DateTime createdAt;
  
  @HiveField(5)
  String? password;
  
  @HiveField(6)
  String? secretQuestion;
  
  @HiveField(7)
  String? secretAnswer;

  UserModel({
    this.id,
    required this.fullName,
    required this.email,
    this.syncWithFirebase = false,
    this.password,
    this.secretQuestion,
    this.secretAnswer,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Método para convertir a Map para Firebase
  Map<String, dynamic> toFirebaseMap() {
    return {
      'fullName': fullName,
      'email': email,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'secretQuestion': secretQuestion,
      'secretAnswer': secretAnswer,
      // No incluimos la contraseña en Firebase por seguridad
    };
  }

  // Método para crear desde Map de Firebase
  factory UserModel.fromFirebaseMap(Map<String, dynamic> map, String docId) {
    return UserModel(
      id: docId,
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      syncWithFirebase: true,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : DateTime.now(),
    );
  }
}