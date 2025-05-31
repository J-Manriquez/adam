import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../models/symptom_data.dart';
import 'auth_service.dart'; // Para obtener el userId

class SymptomService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  final Uuid _uuid = const Uuid();

  Future<Box<SymptomData>> get _symptomBox async {
    if (!Hive.isBoxOpen('symptoms')) {
      return await Hive.openBox<SymptomData>('symptoms');
    }
    return Hive.box<SymptomData>('symptoms');
  }

  String? get _userId => _authService.currentUser?.id;

  // Guardar síntoma (local y Firebase)
  Future<bool> saveSymptom(SymptomData symptom) async {
    if (_userId == null) return false;
    final box = await _symptomBox;
    try {
      symptom.userId = _userId!;
      await box.put(symptom.id, symptom);
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('symptoms')
          .doc(symptom.id)
          .set(symptom.toMap());
      return true;
    } catch (e) {
      print('Error saving symptom: $e');
      return false;
    }
  }

  // Obtener un síntoma por ID (local)
  Future<SymptomData?> getSymptomById(String id) async {
    final box = await _symptomBox;
    return box.get(id);
  }

  // Obtener todos los síntomas del usuario (local)
  List<SymptomData> getAllSymptoms() {
    if (_userId == null) return [];
    final box = Hive.box<SymptomData>('symptoms'); // Asumimos que ya está abierta
    return box.values.where((symptom) => symptom.userId == _userId).toList();
  }

  // Eliminar síntoma (local y Firebase)
  Future<bool> deleteSymptom(String id) async {
    if (_userId == null) return false;
    final box = await _symptomBox;
    try {
      await box.delete(id);
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('symptoms')
          .doc(id)
          .delete();
      return true;
    } catch (e) {
      print('Error deleting symptom: $e');
      return false;
    }
  }

  // Sincronizar síntomas desde Firebase (opcional, para carga inicial o recuperación)
  Future<void> syncSymptomsFromFirebase() async {
    if (_userId == null) return;
    final box = await _symptomBox;
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('symptoms')
          .get();

      for (var doc in snapshot.docs) {
        final symptom = SymptomData.fromMap(doc.data(), doc.id);
        await box.put(symptom.id, symptom);
      }
    } catch (e) {
      print('Error syncing symptoms from Firebase: $e');
    }
  }

  String generateId() => _uuid.v4();
}