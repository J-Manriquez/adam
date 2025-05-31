import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/identification_data.dart';
import '../../services/form_data_service.dart';

class IdentificationViewScreen extends StatefulWidget {
  const IdentificationViewScreen({super.key});

  @override
  State<IdentificationViewScreen> createState() => _IdentificationViewScreenState();
}

class _IdentificationViewScreenState extends State<IdentificationViewScreen> {
  final _formDataService = FormDataService();
  IdentificationData? _data;
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

    final data = _formDataService.getIdentificationData();
    setState(() {
      _data = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información de Identificación'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, '/identification-form').then((_) {
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
                        'No hay información de identificación disponible',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/identification-form')
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
                        'Información Personal',
                        [
                          _buildInfoRow('Fecha de nacimiento', 
                              DateFormat('dd/MM/yyyy').format(_data!.birthDate)),
                          _buildInfoRow('Edad', '${_data!.age} años'),
                          _buildInfoRow('Género', _data!.gender),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        'Información de Contacto',
                        [
                          _buildInfoRow('Teléfono', _data!.phone),
                          _buildInfoRow('Dirección', _data!.address),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        'Información del Registro',
                        [
                          _buildInfoRow('Creado', 
                              DateFormat('dd/MM/yyyy HH:mm').format(_data!.createdAt)),
                          _buildInfoRow('Actualizado', 
                              DateFormat('dd/MM/yyyy HH:mm').format(_data!.updatedAt)),
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