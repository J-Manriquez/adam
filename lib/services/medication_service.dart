import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../models/medication_data.dart';
import '../models/user_model.dart';

class MedicationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Box<MedicationData> _medicationBox = Hive.box<MedicationData>('medication_data');
  final Box<UserModel> _userBox = Hive.box<UserModel>('users');
  final Box _sessionBox = Hive.box('session');
  final Uuid _uuid = Uuid();

  // Obtener usuario actual
  UserModel? get currentUser {
    final userId = _sessionBox.get('userId');
    if (userId != null) {
      return _userBox.get(userId);
    }
    return null;
  }

  // Verificar si el usuario permite sincronización con Firebase
  bool get canSyncWithFirebase {
    final user = currentUser;
    return user != null && user.syncWithFirebase;
  }

  // Crear/Actualizar medicamento
  Future<bool> saveMedication(MedicationData data) async {
    try {
      // Guardar localmente
      final user = currentUser;
      if (user == null) return false;
      
      // Si es un nuevo medicamento, generar ID
      if (data.id.isEmpty) {
        data.id = _uuid.v4();
      }
      
      data.userId = user.id;
      await _medicationBox.put(data.id, data);
      
      // Guardar en Firebase si está permitido
      if (canSyncWithFirebase) {
        await _firestore
            .collection('users')
            .doc(user.id)
            .collection('medications')
            .doc(data.id)
            .set(data.toMap());
      }
      
      return true;
    } catch (e) {
      print('Error al guardar medicamento: $e');
      return false;
    }
  }
  
  // Obtener todos los medicamentos del usuario
  List<MedicationData> getAllMedications() {
    final user = currentUser;
    if (user == null) return [];
    
    return _medicationBox.values
        .where((medication) => medication.userId == user.id)
        .toList();
  }
  
  // Obtener un medicamento específico
  MedicationData? getMedicationById(String id) {
    return _medicationBox.get(id);
  }
  
  // Eliminar medicamento
  Future<bool> deleteMedication(String id) async {
    try {
      final user = currentUser;
      if (user == null) return false;
      
      // Eliminar localmente
      await _medicationBox.delete(id);
      
      // Eliminar en Firebase si está permitido
      if (canSyncWithFirebase) {
        await _firestore
            .collection('users')
            .doc(user.id)
            .collection('medications')
            .doc(id)
            .delete();
      }
      
      return true;
    } catch (e) {
      print('Error al eliminar medicamento: $e');
      return false;
    }
  }
  
  // Sincronizar medicamentos con Firebase
  Future<void> syncMedications() async {
    try {
      final user = currentUser;
      if (user == null || !canSyncWithFirebase) return;
      
      // Obtener medicamentos de Firebase
      final snapshot = await _firestore
          .collection('users')
          .doc(user.id)
          .collection('medications')
          .get();
      
      // Actualizar medicamentos locales
      for (var doc in snapshot.docs) {
        final medicationData = MedicationData.fromMap(doc.data());
        await _medicationBox.put(medicationData.id, medicationData);
      }
      
      // Subir medicamentos locales que no estén en Firebase
      final localMedications = getAllMedications();
      final firebaseMedicationIds = snapshot.docs.map((doc) => doc.id).toSet();
      
      for (var medication in localMedications) {
        if (!firebaseMedicationIds.contains(medication.id)) {
          await _firestore
              .collection('users')
              .doc(user.id)
              .collection('medications')
              .doc(medication.id)
              .set(medication.toMap());
        }
      }
    } catch (e) {
      print('Error al sincronizar medicamentos: $e');
    }
  }
}