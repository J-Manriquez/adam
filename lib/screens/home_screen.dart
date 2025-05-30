import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/form_data_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final FormDataService _formDataService = FormDataService();
  bool _showNotifications = true;
  List<_PendingNotification> _pendingNotifications = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPendingNotifications();
    });
  }

  void _checkPendingNotifications() {
    final List<_PendingNotification> notifications = [];
    if (_formDataService.getIdentificationData() == null) {
      notifications.add(_PendingNotification(
        mensaje: 'Faltan tus datos de identificación',
        onTap: () {
          Navigator.of(context).pushNamed('/identification-form');
        },
      ));
    }
    if (_formDataService.getHealthData() == null) {
      notifications.add(_PendingNotification(
        mensaje: 'Faltan tus datos de salud',
        onTap: () {
          Navigator.of(context).pushNamed('/health-form');
        },
      ));
    }
    setState(() {
      _pendingNotifications = notifications;
      _showNotifications = notifications.isNotEmpty;
    });
    if (_showNotifications) {
      _showPendingNotificationsModal();
    }
  }

  void _showPendingNotificationsModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Notificaciones pendientes',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        ..._pendingNotifications.map((notif) => GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                notif.onTap();
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.orange[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.warning, color: Colors.orange),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(notif.mensaje)),
                                    const Icon(Icons.arrow_forward_ios, size: 16),
                                  ],
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          _showNotifications = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? currentUser = _authService.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/');
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bienvenido, ${currentUser?.fullName ?? 'Usuario'}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Esta es la pantalla de inicio de la aplicación.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PendingNotification {
  final String mensaje;
  final VoidCallback onTap;
  _PendingNotification({required this.mensaje, required this.onTap});
}