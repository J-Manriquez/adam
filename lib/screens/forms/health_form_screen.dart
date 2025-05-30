import 'package:flutter/material.dart';
import '../../models/health_data.dart';
import '../../services/form_data_service.dart';

class HealthFormScreen extends StatefulWidget {
  const HealthFormScreen({super.key});

  @override
  State<HealthFormScreen> createState() => _HealthFormScreenState();
}

class _HealthFormScreenState extends State<HealthFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formDataService = FormDataService();

  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _bloodPressureController = TextEditingController();
  final _physicalLimitationsController = TextEditingController();
  final _supportDevicesController = TextEditingController();

  String _mobilityLevel = 'independiente';
  bool _isLoading = false;
  bool _isEditing = false;

  final List<String> _mobilityOptions = [
    'independiente',
    'con ayuda',
    'silla de ruedas',
  ];

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _bloodPressureController.dispose();
    _physicalLimitationsController.dispose();
    _supportDevicesController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingData() async {
    setState(() {
      _isLoading = true;
    });
    final data = _formDataService.getHealthData();
    if (data != null) {
      setState(() {
        _isEditing = true;
        _weightController.text = data.weight.toString();
        _heightController.text = data.height.toString();
        _bloodPressureController.text = data.bloodPressure ?? '';
        _mobilityLevel = data.mobilityLevel;
        _physicalLimitationsController.text = data.physicalLimitations ?? '';
        _supportDevicesController.text = data.supportDevices.join(', ');
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final healthData = HealthData(
        weight: double.parse(_weightController.text),
        height: double.parse(_heightController.text),
        bloodPressure: _bloodPressureController.text.isNotEmpty ? _bloodPressureController.text : null,
        mobilityLevel: _mobilityLevel,
        physicalLimitations: _physicalLimitationsController.text.isNotEmpty ? _physicalLimitationsController.text : null,
        supportDevices: _supportDevicesController.text.isNotEmpty
            ? _supportDevicesController.text.split(',').map((e) => e.trim()).toList()
            : [],
      );
      final success = await _formDataService.saveHealthData(healthData);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Datos de salud guardados correctamente.')),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar los datos de salud.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: \$e')),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar datos de salud' : 'Datos de salud'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _weightController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(labelText: 'Peso (kg)'),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Ingrese el peso';
                        final num? val = num.tryParse(value);
                        if (val == null || val <= 0) return 'Peso inválido';
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _heightController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(labelText: 'Altura (cm)'),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Ingrese la altura';
                        final num? val = num.tryParse(value);
                        if (val == null || val <= 0) return 'Altura inválida';
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _bloodPressureController,
                      decoration: InputDecoration(labelText: 'Presión arterial (opcional)'),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _mobilityLevel,
                      items: _mobilityOptions
                          .map((option) => DropdownMenuItem(
                                value: option,
                                child: Text(option),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _mobilityLevel = value!;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Nivel de movilidad'),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _physicalLimitationsController,
                      decoration: InputDecoration(labelText: 'Limitaciones físicas (opcional)'),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _supportDevicesController,
                      decoration: InputDecoration(labelText: 'Dispositivos de apoyo (separados por coma)'),
                    ),
                    SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _saveForm,
                      child: Text(_isEditing ? 'Actualizar' : 'Guardar'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}