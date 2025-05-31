import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../firebase_options.dart';
import '../models/user_model.dart';
import '../models/identification_data.dart';
import '../models/health_data.dart';
import '../models/medical_data.dart';
import '../models/lifestyle_data.dart';
import '../models/emergency_contact_data.dart';
import '../models/medication_data.dart';
import '../models/symptom_data.dart'; // Importar el nuevo modelo

import 'sync_service.dart';

class InitService {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    print("Inicializando Firebase...");
    try {
      // Inicializar Firebase
      final options = DefaultFirebaseOptions.currentPlatform;
      print("Opciones de Firebase: $options");
      
      final app = await Firebase.initializeApp(
        options: options,
      );
      
      print("Firebase inicializado correctamente: ${app.name}");
      print("Firebase opciones: ${app.options.projectId}");
    } catch (e) {
      print("Error al inicializar Firebase: $e");
    }
    
    // Inicializar Hive
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDirectory.path);
    
    // Registrar adaptadores
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(IdentificationDataAdapter());
    Hive.registerAdapter(HealthDataAdapter());
    Hive.registerAdapter(MedicalDataAdapter());
    Hive.registerAdapter(LifestyleDataAdapter());
    Hive.registerAdapter(EmergencyContactDataAdapter());
    Hive.registerAdapter(MedicationDataAdapter());
    Hive.registerAdapter(SymptomDataAdapter()); // Registrar el nuevo adaptador
    
    // Abrir cajas
    await Hive.openBox<UserModel>('users');
    await Hive.openBox('session');
    await Hive.openBox<IdentificationData>('identification_data');
    await Hive.openBox<HealthData>('health_data');
    await Hive.openBox<MedicalData>('medical_data');
    await Hive.openBox<LifestyleData>('lifestyle_data');
    await Hive.openBox<EmergencyContactData>('emergency_contact_data');
    await Hive.openBox<MedicationData>('medication_data'); // Añadir caja
    
    // Intentar sincronizar usuarios pendientes
    try {
      final syncService = SyncService();
      await syncService.syncAllUsers();
    } catch (e) {
      print("Error al sincronizar usuarios: $e");
    }
  }
}