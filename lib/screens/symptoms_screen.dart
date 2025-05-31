import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/symptom_data.dart';
import '../services/symptom_service.dart';

class SymptomsScreen extends StatefulWidget {
  const SymptomsScreen({super.key});

  @override
  State<SymptomsScreen> createState() => _SymptomsScreenState();
}

class _SymptomsScreenState extends State<SymptomsScreen> {
  final _symptomService = SymptomService();
  List<SymptomData> _symptoms = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSymptoms();
  }

  Future<void> _loadSymptoms() async {
    // setState(() => _isLoading = true);
    try {
      // Opcional: Sincronizar desde Firebase al cargar la pantalla
      // await _symptomService.syncSymptomsFromFirebase(); 
      final symptoms = _symptomService.getAllSymptoms();
      // Ordenar por fecha de registro descendente
      symptoms.sort((a, b) => b.recordDate.compareTo(a.recordDate));
      if (mounted) {
        setState(() {
          _symptoms = symptoms;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar síntomas: $e')),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _deleteSymptom(String id) async {
    final success = await _symptomService.deleteSymptom(id);
    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Síntoma eliminado correctamente')),
        );
        _loadSymptoms(); // Recargar la lista
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar el síntoma')),
        );
      }
    }
  }

  String _formatDateTime(DateTime dt) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Síntomas y Dolores'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadSymptoms,
        child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final result = await Navigator.pushNamed(context, '/symptom-form');
                          if (result == true) {
                            _loadSymptoms(); // Recargar si se guardó algo
                          }
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('REGISTRAR SÍNTOMA/DOLOR', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: _symptoms.isEmpty
                        ? const Center(
                            child: Text(
                              'No tienes síntomas o dolores registrados.',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.builder(
                            itemCount: _symptoms.length,
                            itemBuilder: (context, index) {
                              final symptom = _symptoms[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(16.0),
                                  title: Text(
                                    symptom.symptomType ?? 'Síntoma no especificado',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text('Nivel: ${symptom.painLevel ?? 'N/A'} / 10'),
                                      const SizedBox(height: 4),
                                      Text('Registrado: ${_formatDateTime(symptom.recordDate)}'),
                                      if (symptom.detailedDescription != null && symptom.detailedDescription!.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4.0),
                                          child: Text(
                                            symptom.detailedDescription!,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                    ],
                                  ),
                                  trailing: PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert),
                                    onSelected: (value) async {
                                      if (value == 'edit') {
                                        final result = await Navigator.pushNamed(
                                          context,
                                          '/symptom-form',
                                          arguments: symptom.id,
                                        );
                                        if (result == true) {
                                          _loadSymptoms();
                                        }
                                      } else if (value == 'delete') {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Eliminar Síntoma'),
                                            content: Text('¿Estás seguro de que deseas eliminar este registro de ${symptom.symptomType ?? 'síntoma'}?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: const Text('Cancelar'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  _deleteSymptom(symptom.id);
                                                },
                                                child: const Text('Eliminar'),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else if (value == 'treatment') {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Tratamiento (próximamente)')),
                                        );
                                      } else if (value == 'evolution') {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Evolución (próximamente)')),
                                        );
                                      } else if (value == 'follow_up') {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Seguimiento (próximamente)')),
                                        );
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem<String>(
                                        value: 'edit',
                                        child: Row(children: [Icon(Icons.edit), SizedBox(width: 8), Text('Editar')]),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: 'delete',
                                        child: Row(children: [Icon(Icons.delete), SizedBox(width: 8), Text('Eliminar')]),
                                      ),
                                      const PopupMenuDivider(),
                                      const PopupMenuItem<String>(
                                        value: 'treatment',
                                        child: Row(children: [Icon(Icons.healing), SizedBox(width: 8), Text('Tratamiento')]),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: 'evolution',
                                        child: Row(children: [Icon(Icons.trending_up), SizedBox(width: 8), Text('Evolución')]),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: 'follow_up',
                                        child: Row(children: [Icon(Icons.assignment), SizedBox(width: 8), Text('Seguimiento')]),
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