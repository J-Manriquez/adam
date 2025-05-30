import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

import '../models/user_model.dart';

class SyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Box<UserModel> _userBox = Hive.box<UserModel>('users');

  // Sincronizar todos los usuarios locales con Firebase
  Future<void> syncAllUsers() async {
    try {
      final users = _userBox.values.where((user) => user.syncWithFirebase);
      
      for (final user in users) {
        await syncUser(user);
      }
      
      print('Sincronización completada');
    } catch (e) {
      print('Error en sincronización: $e');
    }
  }

  // Sincronizar un usuario específico con Firebase
  Future<void> syncUser(UserModel user) async {
    if (!user.syncWithFirebase) return;
    
    try {
      await _firestore.collection('users').doc(user.id).set(
        user.toFirebaseMap(),
        SetOptions(merge: true), // Usar merge para no sobrescribir datos existentes
      );
      print('Usuario ${user.id} sincronizado con Firebase');
    } catch (e) {
      print('Error al sincronizar usuario ${user.id}: $e');
    }
  }

  // Verificar si un usuario existe en Firebase
  Future<bool> userExistsInFirebase(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.exists;
    } catch (e) {
      print('Error al verificar usuario en Firebase: $e');
      return false;
    }
  }

  // Intentar sincronizar usuarios pendientes
  Future<void> syncPendingUsers() async {
    try {
      final allUsers = _userBox.values.where((user) => user.syncWithFirebase);
      
      for (final user in allUsers) {
        if (user.id != null) {
          final exists = await userExistsInFirebase(user.id!);
          if (!exists) {
            await syncUser(user);
          }
        }
      }
    } catch (e) {
      print('Error al sincronizar usuarios pendientes: $e');
    }
  }
}