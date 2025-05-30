import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Box<UserModel> _userBox = Hive.box<UserModel>('users');
  final Box _sessionBox = Hive.box('session');

  // Verificar si hay sesión activa
  bool get isLoggedIn => _sessionBox.get('isLoggedIn', defaultValue: false);

  // Obtener usuario actual
  UserModel? get currentUser {
    final userId = _sessionBox.get('userId');
    if (userId != null) {
      return _userBox.get(userId);
    }
    return null;
  }

  // Registrar usuario
  Future<UserModel?> registerUser({
    required String fullName,
    required String email,
    required String password,
    String? secretQuestion,
    String? secretAnswer,
  }) async {
    try {
      print("Iniciando registro de usuario: $email");

      // Verificar si ya existe un usuario con el mismo correo o nombre
      final existingUserByEmail = _userBox.values.any((user) => user.email == email);
      final existingUserByName = _userBox.values.any((user) => user.fullName == fullName);

      if (existingUserByEmail) {
        print("Ya existe un usuario con este correo electrónico");
        return null;
      }

      if (existingUserByName) {
        print("Ya existe un usuario con este nombre");
        return null;
      }

      // Crear usuario en Firebase Auth
      UserCredential? userCredential;
      try {
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        print("Usuario creado en Firebase Auth: ${userCredential.user?.uid}");
      } catch (firebaseError) {
        print("Error al crear usuario en Firebase Auth: $firebaseError");
        // Continuamos con el registro local aunque falle Firebase Auth
        userCredential = null;
      }

      // Generar un ID único para el usuario (preferiblemente usar el UID de Firebase)
      final userId = userCredential?.user?.uid ?? DateTime.now().millisecondsSinceEpoch.toString();
      
      // Crear el modelo de usuario
      final userModel = UserModel(
        id: userId,
        fullName: fullName,
        email: email,
        syncWithFirebase: true, // Activamos la sincronización con Firebase
        password: password,
        secretQuestion: secretQuestion,
        secretAnswer: secretAnswer,
      );

      // Guardar localmente
      await _userBox.put(userModel.id, userModel);

      // Guardar en Firestore
      try {
        await _firestore.collection('users').doc(userId).set(userModel.toFirebaseMap());
        print("Datos de usuario guardados en Firestore");
      } catch (firestoreError) {
        print("Error al guardar datos en Firestore: $firestoreError");
        // Continuamos aunque falle Firestore
      }

      // Guardar sesión
      await _sessionBox.put('isLoggedIn', true);
      await _sessionBox.put('userId', userModel.id);

      return userModel;
    } catch (e) {
      print('Error general al registrar usuario: $e');
      return null;
    }
  }

  // Iniciar sesión con correo electrónico
  Future<UserModel?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      // Buscar usuario en la base de datos local por correo
      final users = _userBox.values.where((user) => 
        user.email == email && user.password == password
      );

      if (users.isNotEmpty) {
        final userModel = users.first;
        
        // Guardar sesión
        await _sessionBox.put('isLoggedIn', true);
        await _sessionBox.put('userId', userModel.id);
        return userModel;
      }

      return null;
    } catch (e) {
      print('Error al iniciar sesión: $e');
      return null;
    }
  }

  // Iniciar sesión con nombre completo
  Future<UserModel?> signInWithFullName({
    required String fullName,
    required String password,
  }) async {
    try {
      // Buscar usuario en la base de datos local por nombre completo
      final users = _userBox.values.where((user) => 
        user.fullName == fullName && user.password == password
      );

      if (users.isNotEmpty) {
        final userModel = users.first;
        
        // Guardar sesión
        await _sessionBox.put('isLoggedIn', true);
        await _sessionBox.put('userId', userModel.id);
        return userModel;
      }

      return null;
    } catch (e) {
      print('Error al iniciar sesión: $e');
      return null;
    }
  }

  // Verificar pregunta secreta
  bool verifySecretAnswer(String email, String answer) {
    final users = _userBox.values.where((user) => user.email == email);
    if (users.isEmpty) return false;

    final user = users.first;
    return user.secretAnswer?.toLowerCase() == answer.toLowerCase();
  }

  // Obtener contraseña por pregunta secreta
  String? getPasswordBySecretAnswer(String email, String answer) {
    final users = _userBox.values.where((user) => user.email == email);
    if (users.isEmpty) return null;

    final user = users.first;
    if (user.secretAnswer?.toLowerCase() == answer.toLowerCase()) {
      return user.password;
    }
    return null;
  }

  // Actualizar contraseña local
  Future<bool> updateLocalPassword(String email, String newPassword) async {
    try {
      final users = _userBox.values.where((user) => user.email == email);
      if (users.isEmpty) return false;

      final user = users.first;
      user.password = newPassword;
      await _userBox.put(user.id, user);
      return true;
    } catch (e) {
      print('Error al actualizar contraseña local: $e');
      return false;
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await _sessionBox.put('isLoggedIn', false);
    await _sessionBox.delete('userId');
  }
}
