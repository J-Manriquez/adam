import 'package:adam/screens/forms/health_form_screen.dart';
import 'package:adam/screens/forms/identification_form_screen.dart';
import 'package:adam/screens/forms/medical_form_screen.dart';
import 'package:adam/screens/forms/lifestyle_form_screen.dart';
import 'package:adam/screens/inicio/login_screen.dart';
import 'package:adam/screens/inicio/recover_password_screen.dart';
import 'package:adam/screens/notification_screen.dart';
import 'package:adam/screens/personal_data_screen.dart';
import 'package:adam/screens/views/health_view_screen.dart';
import 'package:adam/screens/views/identification_view_screen.dart';
import 'package:adam/screens/views/lifestyle_view_screen.dart';
import 'package:adam/screens/views/medical_view_screen.dart';
import 'package:flutter/material.dart';

import 'services/init_service.dart';
import 'screens/inicio/welcome_screen.dart';
import 'screens/inicio/register_screen.dart';
import 'screens/home_screen.dart';
import 'services/auth_service.dart';

void main() async {
  // Inicializar servicios
  await InitService.initialize();
  
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final initialRoute = authService.isLoggedIn ? '/home' : '/';
    
    return MaterialApp(
      title: 'Adam App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => const LoginScreen(),
        '/recover-password': (context) => const RecoverPasswordScreen(),
        '/home': (context) => const HomeScreen(),
        '/health-form': (context) => const HealthFormScreen(),
        '/identification-form': (context) => const IdentificationFormScreen(),
        '/medical-form': (context) => const MedicalFormScreen(),
        '/lifestyle-form': (context) => const LifestyleFormScreen(),
        '/notifications': (context) => const NotificationScreen(),
        // Nuevas rutas para las pantallas de visualización
        '/personal-data': (context) => const PersonalDataScreen(),
        '/identification-view': (context) => const IdentificationViewScreen(),
        '/health-view': (context) => const HealthViewScreen(),
        '/medical-view': (context) => const MedicalViewScreen(),
        '/lifestyle-view': (context) => const LifestyleViewScreen(),
      },
    );
  }
}
