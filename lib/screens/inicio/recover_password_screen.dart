import 'package:adam/models/user_model.dart';
import 'package:adam/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';


class RecoverPasswordScreen extends StatefulWidget {
  const RecoverPasswordScreen({super.key});

  @override
  State<RecoverPasswordScreen> createState() => _RecoverPasswordScreenState();
}

class _RecoverPasswordScreenState extends State<RecoverPasswordScreen> {
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _secretAnswerController = TextEditingController();
  
  bool _isLoading = false;
  bool _showSecretQuestion = false;
  String? _recoveredPassword;
  String? _secretQuestion;
  
  @override
  void dispose() {
    _emailController.dispose();
    _secretAnswerController.dispose();
    super.dispose();
  }
  
  void _checkSecretQuestion() {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingrese su correo electrónico')),
      );
      return;
    }
    
    // Buscar la pregunta secreta asociada al email
    final users = Hive.box<UserModel>('users').values.where(
      (user) => user.email == _emailController.text.trim()
    );
    
    if (users.isEmpty || users.first.secretQuestion == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se encontró una pregunta secreta para este correo')),
      );
      return;
    }
    
    setState(() {
      _secretQuestion = users.first.secretQuestion;
      _showSecretQuestion = true;
      _recoveredPassword = null;
    });
  }
  
  void _verifySecretAnswer() {
    if (_secretAnswerController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingrese su respuesta')),
      );
      return;
    }
    
    final password = _authService.getPasswordBySecretAnswer(
      _emailController.text.trim(),
      _secretAnswerController.text.trim(),
    );
    
    if (password != null) {
      setState(() {
        _recoveredPassword = password;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Respuesta incorrecta')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar Contraseña'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Ingrese su correo electrónico para recuperar su contraseña:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _checkSecretQuestion,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Buscar pregunta secreta'),
              ),
              if (_showSecretQuestion) ...[  
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),
                Text(
                  'Pregunta secreta: $_secretQuestion',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _secretAnswerController,
                  decoration: const InputDecoration(
                    labelText: 'Respuesta',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _verifySecretAnswer,
                  child: const Text('Verificar respuesta'),
                ),
              ],
              if (_recoveredPassword != null) ...[  
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  'Su contraseña es:',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  _recoveredPassword!,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text('Ir a iniciar sesión'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}