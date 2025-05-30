import 'package:adam/services/auth_service.dart';
import 'package:flutter/material.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  
  final _emailOrNameController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = false;
  bool _useEmail = true; // Por defecto, usar correo electrónico

  @override
  void dispose() {
    _emailOrNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final user = _useEmail 
        ? await _authService.signInWithEmail(
            email: _emailOrNameController.text.trim(),
            password: _passwordController.text,
          )
        : await _authService.signInWithFullName(
            fullName: _emailOrNameController.text.trim(),
            password: _passwordController.text,
          );
      
      if (user != null) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Credenciales incorrectas')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                // Selector de método de inicio de sesión
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _useEmail = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _useEmail 
                            ? Theme.of(context).primaryColor 
                            : Theme.of(context).primaryColor.withOpacity(0.5),
                        ),
                        child: const Text('Usar Correo'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _useEmail = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: !_useEmail 
                            ? Theme.of(context).primaryColor 
                            : Theme.of(context).primaryColor.withOpacity(0.5),
                        ),
                        child: const Text('Usar Nombre'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailOrNameController,
                  decoration: InputDecoration(
                    labelText: _useEmail ? 'Correo electrónico' : 'Nombre completo',
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: _useEmail ? TextInputType.emailAddress : TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return _useEmail 
                        ? 'Por favor ingrese su correo electrónico'
                        : 'Por favor ingrese su nombre completo';
                    }
                    if (_useEmail && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Por favor ingrese un correo electrónico válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su contraseña';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Iniciar Sesión'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/recover-password');
                  },
                  child: const Text('¿Olvidaste tu contraseña?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}