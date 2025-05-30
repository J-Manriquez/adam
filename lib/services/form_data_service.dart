import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

import '../models/user_model.dart';
import '../models/identification_data.dart';
import '../models/health_data.dart';
import '../models/medical_data.dart';
import '../models/lifestyle_data.dart';
import '../models/emergency_contact_data.dart';

class FormDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Box<IdentificationData> _identificationBox = Hive.box<IdentificationData>('identification_data');
  final Box<HealthData> _healthBox = Hive.box<HealthData>('health_data');
  final Box<MedicalData> _medicalBox = Hive.box<MedicalData>('medical_data');
  final Box<LifestyleData> _lifestyleBox = Hive.box<LifestyleData>('lifestyle_data');
  final Box<EmergencyContactData> _emergencyContactBox = Hive.box<EmergencyContactData>('emergency_contact_data');
  final Box<UserModel> _userBox = Hive.box<UserModel>('users');
  final Box _sessionBox = Hive.box('session');

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

  // CRUD para Datos de Identificación
  
  // Crear/Actualizar datos de identificación
  Future<bool> saveIdentificationData(IdentificationData data) async {
    try {
      // Guardar localmente
      final user = currentUser;
      if (user == null) return false;
      
      data.userId = user.id;
      await _identificationBox.put(user.id, data);
      
      // Guardar en Firebase si está permitido
      if (canSyncWithFirebase) {
        await _firestore
            .collection('users')
            .doc(user.id)
            .collection('identification_data')
            .doc(user.id)
            .set(data.toMap());
      }
      
      return true;
    } catch (e) {
      print('Error al guardar datos de identificación: $e');
      return false;
    }
  }
  
  // Obtener datos de identificación
  IdentificationData? getIdentificationData() {
    final user = currentUser;
    if (user == null) return null;
    
    return _identificationBox.get(user.id);
  }
  
  // Eliminar datos de identificación
  Future<bool> deleteIdentificationData() async {
    try {
      final user = currentUser;
      if (user == null) return false;
      
      // Eliminar localmente
      await _identificationBox.delete(user.id);
      
      // Eliminar en Firebase si está permitido
      if (canSyncWithFirebase) {
        await _firestore
            .collection('users')
            .doc(user.id)
            .collection('identification_data')
            .doc(user.id)
            .delete();
      }
      
      return true;
    } catch (e) {
      print('Error al eliminar datos de identificación: $e');
      return false;
    }
  }
  
  // CRUD para Datos de Salud
  
  // Crear/Actualizar datos de salud
  Future<bool> saveHealthData(HealthData data) async {
    try {
      // Guardar localmente
      final user = currentUser;
      if (user == null) return false;
      
      data.userId = user.id;
      await _healthBox.put(user.id, data);
      
      // Guardar en Firebase si está permitido
      if (canSyncWithFirebase) {
        await _firestore
            .collection('users')
            .doc(user.id)
            .collection('health_data')
            .doc(user.id)
            .set(data.toMap());
      }
      
      return true;
    } catch (e) {
      print('Error al guardar datos de salud: $e');
      return false;
    }
  }
  
  // Obtener datos de salud
  HealthData? getHealthData() {
    final user = currentUser;
    if (user == null) return null;
    
    return _healthBox.get(user.id);
  }
  
  // Eliminar datos de salud
  Future<bool> deleteHealthData() async {
    try {
      final user = currentUser;
      if (user == null) return false;
      
      // Eliminar localmente
      await _healthBox.delete(user.id);
      
      // Eliminar en Firebase si está permitido
      if (canSyncWithFirebase) {
        await _firestore
            .collection('users')
            .doc(user.id)
            .collection('health_data')
            .doc(user.id)
            .delete();
      }
      
      return true;
    } catch (e) {
      print('Error al eliminar datos de salud: $e');
      return false;
    }
  }
  
  // CRUD para Datos Médicos
  
  // Crear/Actualizar datos médicos
  Future<bool> saveMedicalData(MedicalData data) async {
    try {
      // Guardar localmente
      final user = currentUser;
      if (user == null) return false;
      
      data.userId = user.id;
      await _medicalBox.put(user.id, data);
      
      // Guardar en Firebase si está permitido
      if (canSyncWithFirebase) {
        await _firestore
            .collection('users')
            .doc(user.id)
            .collection('medical_data')
            .doc(user.id)
            .set(data.toMap());
      }
      
      return true;
    } catch (e) {
      print('Error al guardar datos médicos: $e');
      return false;
    }
  }
  
  // Obtener datos médicos
  MedicalData? getMedicalData() {
    final user = currentUser;
    if (user == null) return null;
    
    return _medicalBox.get(user.id);
  }
  
  // Eliminar datos médicos
  Future<bool> deleteMedicalData() async {
    try {
      final user = currentUser;
      if (user == null) return false;
      
      // Eliminar localmente
      await _medicalBox.delete(user.id);
      
      // Eliminar en Firebase si está permitido
      if (canSyncWithFirebase) {
        await _firestore
            .collection('users')
            .doc(user.id)
            .collection('medical_data')
            .doc(user.id)
            .delete();
      }
      
      return true;
    } catch (e) {
      print('Error al eliminar datos médicos: $e');
      return false;
    }
  }

  // CRUD para Datos de Estilo de Vida
  
  // Crear/Actualizar datos de estilo de vida
  Future<bool> saveLifestyleData(LifestyleData data) async {
    try {
      // Guardar localmente
      final user = currentUser;
      if (user == null) return false;
      
      data.userId = user.id;
      await _lifestyleBox.put(user.id, data);
      
      // Guardar en Firebase si está permitido
      if (canSyncWithFirebase) {
        await _firestore
            .collection('users')
            .doc(user.id)
            .collection('lifestyle_data')
            .doc(user.id)
            .set(data.toMap());
      }
      
      return true;
    } catch (e) {
      print('Error al guardar datos de estilo de vida: $e');
      return false;
    }
  }
  
  // Obtener datos de estilo de vida
  LifestyleData? getLifestyleData() {
    final user = currentUser;
    if (user == null) return null;
    
    return _lifestyleBox.get(user.id);
  }
  
  // Eliminar datos de estilo de vida
  Future<bool> deleteLifestyleData() async {
    try {
      final user = currentUser;
      if (user == null) return false;
      
      // Eliminar localmente
      await _lifestyleBox.delete(user.id);
      
      // Eliminar en Firebase si está permitido
      if (canSyncWithFirebase) {
        await _firestore
            .collection('users')
            .doc(user.id)
            .collection('lifestyle_data')
            .doc(user.id)
            .delete();
      }
      
      return true;
    } catch (e) {
      print('Error al eliminar datos de estilo de vida: $e');
      return false;
    }
  }

  // CRUD para Datos de Contactos de Emergencia
  
  // Crear/Actualizar datos de contactos de emergencia
  Future<bool> saveEmergencyContactData(EmergencyContactData data) async {
    try {
      // Guardar localmente
      final user = currentUser;
      if (user == null) return false;
      
      data.userId = user.id;
      await _emergencyContactBox.put(user.id, data);
      
      // Guardar en Firebase si está permitido
      if (canSyncWithFirebase) {
        await _firestore
            .collection('users')
            .doc(user.id)
            .collection('emergency_contact_data')
            .doc(user.id)
            .set(data.toMap());
      }
      
      return true;
    } catch (e) {
      print('Error al guardar datos de contactos de emergencia: $e');
      return false;
    }
  }
  
  // Obtener datos de contactos de emergencia
  EmergencyContactData? getEmergencyContactData() {
    final user = currentUser;
    if (user == null) return null;
    
    return _emergencyContactBox.get(user.id);
  }
  
  // Eliminar datos de contactos de emergencia
  Future<bool> deleteEmergencyContactData() async {
    try {
      final user = currentUser;
      if (user == null) return false;
      
      // Eliminar localmente
      await _emergencyContactBox.delete(user.id);
      
      // Eliminar en Firebase si está permitido
      if (canSyncWithFirebase) {
        await _firestore
            .collection('users')
            .doc(user.id)
            .collection('emergency_contact_data')
            .doc(user.id)
            .delete();
      }
      
      return true;
    } catch (e) {
      print('Error al eliminar datos de contactos de emergencia: $e');
      return false;
    }
  }
  
  // Sincronizar todos los datos con Firebase
  Future<bool> syncAllData() async {
    if (!canSyncWithFirebase) return false;
    
    try {
      final user = currentUser;
      if (user == null) return false;
      
      // Sincronizar datos de identificación
      final identificationData = getIdentificationData();
      if (identificationData != null) {
        await _firestore
            .collection('users')
            .doc(user.id)
            .collection('identification_data')
            .doc(user.id)
            .set(identificationData.toMap());
      }
      
      // Sincronizar datos de salud
      final healthData = getHealthData();
      if (healthData != null) {
        await _firestore
            .collection('users')
            .doc(user.id)
            .collection('health_data')
            .doc(user.id)
            .set(healthData.toMap());
      }
      
      // Sincronizar datos médicos
      final medicalData = getMedicalData();
      if (medicalData != null) {
        await _firestore
            .collection('users')
            .doc(user.id)
            .collection('medical_data')
            .doc(user.id)
            .set(medicalData.toMap());
      }
      
      // Sincronizar datos de estilo de vida
      final lifestyleData = getLifestyleData();
      if (lifestyleData != null) {
        await _firestore
            .collection('users')
            .doc(user.id)
            .collection('lifestyle_data')
            .doc(user.id)
            .set(lifestyleData.toMap());
      }
      
      // Sincronizar datos de contactos de emergencia
      final emergencyContactData = getEmergencyContactData();
      if (emergencyContactData != null) {
        await _firestore
            .collection('users')
            .doc(user.id)
            .collection('emergency_contact_data')
            .doc(user.id)
            .set(emergencyContactData.toMap());
      }
      
      return true;
    } catch (e) {
      print('Error al sincronizar datos: $e');
      return false;
    }
  }
}