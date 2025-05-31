import 'package:flutter/material.dart';
import '../../models/health_data.dart';
import '../../services/form_data_service.dart';

class HealthViewScreen extends StatefulWidget {
  const HealthViewScreen({super.key});

  @override
  State<HealthViewScreen> createState() => _HealthViewScreenState();
}

class _HealthViewScreenState extends State<HealthViewScreen> {
  final _formDataService = FormDataService();
  HealthData? _data;
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

    final data = _formDataService.getHealthData();
    setState(() {
      _data = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información de Salud'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, '/health-form').then((_) {
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
                        'No hay información de salud disponible',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/health-form')
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
                        'Medidas Corporales',
                        [
                          _buildInfoRow('Peso', '${_data!.weight} kg'),
                          _buildInfoRow('Altura', '${_data!.height} cm'),
                          _buildInfoRow('Presión arterial', 
                              _data!.bloodPressure ?? 'No especificada'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        'Movilidad y Limitaciones',
                        [
                          _buildInfoRow('Nivel de movilidad', _data!.mobilityLevel),
                          _buildInfoRow('Limitaciones físicas', 
                              _data!.physicalLimitations ?? 'Ninguna'),
                          _buildInfoRow('Dispositivos de apoyo', 
                              _data!.supportDevices.isEmpty 
                                  ? 'Ninguno' 
                                  : _data!.supportDevices.join(', ')),
                        ],
                      ),
                    ],
                  ),
                ),
    );
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