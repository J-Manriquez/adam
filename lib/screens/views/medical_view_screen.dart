import 'package:flutter/material.dart';
import '../../models/medical_data.dart';
import '../../services/form_data_service.dart';

class MedicalViewScreen extends StatefulWidget {
  const MedicalViewScreen({super.key});

  @override
  State<MedicalViewScreen> createState() => _MedicalViewScreenState();
}

class _MedicalViewScreenState extends State<MedicalViewScreen> {
  final _formDataService = FormDataService();
  MedicalData? _data;
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

    final data = _formDataService.getMedicalData();
    setState(() {
      _data = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información Médica'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, '/medical-form').then((_) {
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
                        'No hay información médica disponible',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/medical-form')
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
                        'Tipo de Sangre',
                        [
                          _buildInfoRow('Grupo sanguíneo', 
                              '${_data!.bloodType} ${_data!.rhFactor}'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        'Alergias',
                        [
                          _buildInfoRow('Alergias conocidas', 
                              _getAllergiesText(_data!)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        'Enfermedades Crónicas',
                        [
                          _buildInfoRow('Enfermedades diagnosticadas', 
                              _getChronicDiseasesText(_data!)),
                        ],
                      ),
                      if (_data!.primaryDoctors.isNotEmpty) ...[  
                        const SizedBox(height: 16),
                        _buildDoctorsCard('Médicos de Cabecera', _data!.primaryDoctors),
                      ],
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        'Seguro de Salud',
                        [
                          _buildInfoRow('Tipo de seguro', _data!.healthInsuranceType),
                          _buildInfoRow('Detalle', _data!.healthInsuranceDetail),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }

  String _getAllergiesText(MedicalData data) {
    if (data.allergies.contains('No tiene')) {
      return 'No tiene alergias conocidas';
    }
    
    final List<String> allAllergies = [];
    allAllergies.addAll(data.allergies.where((a) => a != 'Otro'));
    allAllergies.addAll(data.customAllergies);
    
    return allAllergies.join(', ');
  }

  String _getChronicDiseasesText(MedicalData data) {
    if (data.chronicDiseases.contains('No tiene')) {
      return 'No tiene enfermedades crónicas diagnosticadas';
    }
    
    final List<String> allDiseases = [];
    allDiseases.addAll(data.chronicDiseases.where((d) => d != 'Otro'));
    allDiseases.addAll(data.customChronicDiseases);
    
    return allDiseases.join(', ');
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

  Widget _buildDoctorsCard(String title, List<Map<String, String>> doctors) {
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
            ...doctors.map((doctor) => ListTile(
                  title: Text(doctor['name'] ?? ''),
                  subtitle: Text('${doctor['specialty'] ?? ''} - ${doctor['phone'] ?? ''}'),
                )),
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