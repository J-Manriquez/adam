import 'package:flutter/material.dart';
import '../../models/lifestyle_data.dart';
import '../../services/form_data_service.dart';

class LifestyleViewScreen extends StatefulWidget {
  const LifestyleViewScreen({super.key});

  @override
  State<LifestyleViewScreen> createState() => _LifestyleViewScreenState();
}

class _LifestyleViewScreenState extends State<LifestyleViewScreen> {
  final _formDataService = FormDataService();
  LifestyleData? _data;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    final data = _formDataService.getLifestyleData();
    setState(() {
      _data = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estilo de Vida'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, '/lifestyle-form').then((_) {
                _loadData();
              });
            },
            tooltip: 'Editar información',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _data == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'No hay información de estilo de vida disponible',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/lifestyle-form')
                              .then((_) {
                            _loadData();
                          });
                        },
                        child: const Text('Agregar información'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoCard(
                        'Actividad Física',
                        [
                          _buildInfoRow('Pasatiempos físicos', 
                              _getHobbiesText(_data!.physicalHobbies, _data!.customPhysicalHobbies)),
                          _buildInfoRow('Frecuencia de actividad', 
                              _data!.physicalActivityFrequency),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        'Actividad Mental',
                        [
                          _buildInfoRow('Pasatiempos mentales', 
                              _getHobbiesText(_data!.mentalHobbies, _data!.customMentalHobbies)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        'Alimentación',
                        [
                          _buildInfoRow('Hábitos alimentarios', 
                              _getHobbiesText(_data!.eatingHabits, _data!.customEatingHabits)),
                          _buildInfoRow('Restricciones dietéticas', 
                              _getHobbiesText(_data!.dietaryRestrictions, _data!.customDietaryRestrictions)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        'Consumo de Sustancias',
                        [
                          _buildInfoRow('Consumo de alcohol', 
                              _data!.alcoholConsumption ? 'Sí' : 'No'),
                          _buildInfoRow('Consumo de tabaco', 
                              _data!.tobaccoConsumption ? 'Sí' : 'No'),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }

  String _getHobbiesText(List<String> hobbies, List<String> customHobbies) {
    if (hobbies.contains('No tiene')) {
      return 'No tiene';
    }
    
    final List<String> allItems = [];
    allItems.addAll(hobbies.where((h) => h != 'Otro'));
    allItems.addAll(customHobbies);
    
    return allItems.join(', ');
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}