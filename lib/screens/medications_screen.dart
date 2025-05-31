import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/medication_data.dart';
import '../services/medication_service.dart';

class MedicationsScreen extends StatefulWidget {
  const MedicationsScreen({super.key});

  @override
  State<MedicationsScreen> createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen> {
  final _medicationService = MedicationService();
  List<MedicationData> _medications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMedications();
  }

  Future<void> _loadMedications() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final medications = _medicationService.getAllMedications();
      setState(() {
        _medications = medications;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar medicamentos: $e')),
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

  Future<void> _deleteMedication(String id) async {
    try {
      final success = await _medicationService.deleteMedication(id);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Medicamento eliminado correctamente')),
        );
        _loadMedications();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar el medicamento')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  String _formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  String _formatDoseTimes(MedicationData medication) {
    final times = medication.calculateDoseTimes();
    return times.map((time) => _formatTime(time)).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Medicamentos'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadMedications,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Botón para añadir medicamento
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final result = await Navigator.pushNamed(
                            context,
                            '/medication-form',
                          );
                          if (result == true) {
                            _loadMedications();
                          }
                        },
                        icon: const Icon(Icons.add),
                        label: const Text(
                          'AÑADIR MEDICAMENTO',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ),
                  
                  // Lista de medicamentos
                  Expanded(
                    child: _medications.isEmpty
                        ? const Center(
                            child: Text(
                              'No tienes medicamentos registrados',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _medications.length,
                            itemBuilder: (context, index) {
                              final medication = _medications[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8.0,
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(16.0),
                                  title: Text(
                                    medication.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text(
                                        '${medication.concentration} ${medication.concentrationUnit} - ${medication.form}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time,
                                            size: 16,
                                            color: Colors.blue,
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              _formatDoseTimes(medication),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.blue,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: PopupMenuButton<String>(
                                    padding: EdgeInsets.all(0),
                                    icon: const Icon(Icons.more_vert),
                                    onSelected: (value) async {
                                      if (value == 'edit') {
                                        final result = await Navigator.pushNamed(
                                          context,
                                          '/medication-form',
                                          arguments: medication.id,
                                        );
                                        if (result == true) {
                                          _loadMedications();
                                        }
                                      } else if (value == 'delete') {
                                        // Mostrar diálogo de confirmación
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Eliminar medicamento'),
                                            content: Text(
                                              '¿Estás seguro de que deseas eliminar ${medication.name}?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: const Text('Cancelar'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  _deleteMedication(medication.id);
                                                },
                                                child: const Text('Eliminar'),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else if (value == 'alarms') {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'La función de alarmas estará disponible próximamente',
                                            ),
                                          ),
                                        );
                                      } else if (value == 'history') {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'El historial estará disponible próximamente',
                                            ),
                                          ),
                                        );
                                      } else if (value == 'stock') {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'La gestión de stock estará disponible próximamente',
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem<String>(
                                        value: 'edit',
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit),
                                            SizedBox(width: 8),
                                            Text('Editar'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete),
                                            SizedBox(width: 8),
                                            Text('Eliminar'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: 'alarms',
                                        child: Row(
                                          children: [
                                            Icon(Icons.alarm),
                                            SizedBox(width: 8),
                                            Text('Activar alarmas'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: 'history',
                                        child: Row(
                                          children: [
                                            Icon(Icons.history),
                                            SizedBox(width: 8),
                                            Text('Ver historial'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: 'stock',
                                        child: Row(
                                          children: [
                                            Icon(Icons.inventory),
                                            SizedBox(width: 8),
                                            Text('Gestionar stock'),
                                          ],
                                        ),
                                      ),
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
    );
  }
}