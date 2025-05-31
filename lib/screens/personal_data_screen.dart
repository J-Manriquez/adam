import 'package:flutter/material.dart';
import '../services/form_data_service.dart';

class PersonalDataScreen extends StatefulWidget {
  const PersonalDataScreen({super.key});

  @override
  State<PersonalDataScreen> createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  final _formDataService = FormDataService();
  bool _hasIdentificationData = false;
  bool _hasHealthData = false;
  bool _hasMedicalData = false;
  bool _hasLifestyleData = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkDataAvailability();
  }

  Future<void> _checkDataAvailability() async {
    setState(() {
      _isLoading = true;
    });

    final identificationData = _formDataService.getIdentificationData();
    final healthData = _formDataService.getHealthData();
    final medicalData = _formDataService.getMedicalData();
    final lifestyleData = _formDataService.getLifestyleData();

    setState(() {
      _hasIdentificationData = identificationData != null;
      _hasHealthData = healthData != null;
      _hasMedicalData = medicalData != null;
      _hasLifestyleData = lifestyleData != null;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Datos Personales'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _checkDataAvailability,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildDataCard(
                      title: 'Información de Identificación',
                      icon: Icons.person,
                      color: Colors.blue,
                      hasData: _hasIdentificationData,
                      onTap: () => Navigator.pushNamed(context, '/identification-view')
                          .then((_) => _checkDataAvailability()),
                      onAdd: () => Navigator.pushNamed(context, '/identification-form')
                          .then((_) => _checkDataAvailability()),
                    ),
                    const SizedBox(height: 16),
                    _buildDataCard(
                      title: 'Información de Salud',
                      icon: Icons.favorite,
                      color: Colors.red,
                      hasData: _hasHealthData,
                      onTap: () => Navigator.pushNamed(context, '/health-view')
                          .then((_) => _checkDataAvailability()),
                      onAdd: () => Navigator.pushNamed(context, '/health-form')
                          .then((_) => _checkDataAvailability()),
                    ),
                    const SizedBox(height: 16),
                    _buildDataCard(
                      title: 'Información Médica',
                      icon: Icons.medical_services,
                      color: Colors.green,
                      hasData: _hasMedicalData,
                      onTap: () => Navigator.pushNamed(context, '/medical-view')
                          .then((_) => _checkDataAvailability()),
                      onAdd: () => Navigator.pushNamed(context, '/medical-form')
                          .then((_) => _checkDataAvailability()),
                    ),
                    const SizedBox(height: 16),
                    _buildDataCard(
                      title: 'Estilo de Vida',
                      icon: Icons.self_improvement,
                      color: Colors.purple,
                      hasData: _hasLifestyleData,
                      onTap: () => Navigator.pushNamed(context, '/lifestyle-view')
                          .then((_) => _checkDataAvailability()),
                      onAdd: () => Navigator.pushNamed(context, '/lifestyle-form')
                          .then((_) => _checkDataAvailability()),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildDataCard({
    required String title,
    required IconData icon,
    required Color color,
    required bool hasData,
    required VoidCallback onTap,
    required VoidCallback onAdd,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: hasData ? onTap : onAdd,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: color.withOpacity(0.2),
                    child: Icon(icon, color: color),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (hasData)
                    const Icon(Icons.arrow_forward_ios, size: 16)
                  else
                    ElevatedButton(
                      onPressed: onAdd,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      child: const Text('Agregar'),
                    ),
                ],
              ),
              if (hasData) ...[  
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  'Toca para ver detalles',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ] else ...[  
                const SizedBox(height: 8),
                Text(
                  'No hay información disponible',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}