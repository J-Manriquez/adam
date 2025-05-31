import 'package:flutter/material.dart';
import '../services/form_data_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final FormDataService _formDataService = FormDataService();
  List<PendingNotification> _pendingNotifications = [];

  @override
  void initState() {
    super.initState();
    _checkPendingNotifications();
  }

  void _checkPendingNotifications() {
    final List<PendingNotification> notifications = [];
    
    // Verificar datos de identificación
    if (_formDataService.getIdentificationData() == null) {
      notifications.add(PendingNotification(
        mensaje: 'Faltan tus datos de identificación',
        onTap: () {
          Navigator.of(context).pushNamed('/identification-form');
        },
      ));
    }
    
    // Verificar datos de salud
    if (_formDataService.getHealthData() == null) {
      notifications.add(PendingNotification(
        mensaje: 'Faltan tus datos de salud',
        onTap: () {
          Navigator.of(context).pushNamed('/health-form');
        },
      ));
    }
    
    // Verificar datos médicos
    if (_formDataService.getMedicalData() == null) {
      notifications.add(PendingNotification(
        mensaje: 'Faltan tus datos médicos',
        onTap: () {
          Navigator.of(context).pushNamed('/medical-form');
        },
      ));
    }
    
    // Verificar datos de estilo de vida
    if (_formDataService.getLifestyleData() == null) {
      notifications.add(PendingNotification(
        mensaje: 'Faltan tus datos de estilo de vida',
        onTap: () {
          Navigator.of(context).pushNamed('/lifestyle-form');
        },
      ));
    }
    
    setState(() {
      _pendingNotifications = notifications;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Notificaciones pendientes',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _pendingNotifications.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Text(
                          'No tienes notificaciones pendientes',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: _pendingNotifications.length,
                        itemBuilder: (context, index) {
                          final notif = _pendingNotifications[index];
                          return GestureDetector(
                            onTap: notif.onTap,
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
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

// Hacemos la clase pública para poder reutilizarla en HomeScreen
class PendingNotification {
  final String mensaje;
  final VoidCallback onTap;
  PendingNotification({required this.mensaje, required this.onTap});
}