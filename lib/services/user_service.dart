import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Box<UserModel> _userBox = Hive.box<UserModel>('users');
  final Box _sessionBox = Hive.box('session');

  // Guardar datos del usuario localmente
  Future<void> saveUserLocally(UserModel user) async {
    await _userBox.put(user.id, user);
  }

  // Guardar datos del usuario en Firebase
  Future<void> saveUserToFirebase(UserModel user) async {
    if (!user.syncWithFirebase) return;
    
    try {
      final timestamp = user.createdAt.millisecondsSinceEpoch.toString();
      await _firestore.collection('users').doc(timestamp).set(user.toFirebaseMap());
    } catch (e) {
      print('Error al guardar en Firebase: $e');
    }
  }

  // Guardar usuario (local y opcionalmente en Firebase)
  Future<void> saveUser(UserModel user) async {
    await saveUserLocally(user);
    
    if (user.syncWithFirebase) {
      await saveUserToFirebase(user);
    }
  }

  // Obtener usuario por ID
  UserModel? getUserById(String userId) {
    return _userBox.get(userId);
  }

  // Obtener usuario actual
  UserModel? get currentUser {
    final userId = _sessionBox.get('userId');
    if (userId != null) {
      return _userBox.get(userId);
    }
    return null;
  }
}