import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../models/symptom_data.dart';
import '../../services/symptom_service.dart';

class SymptomFormScreen extends StatefulWidget {
  final String? symptomId; // Para editar un síntoma existente

  const SymptomFormScreen({super.key, this.symptomId});

  @override
  State<SymptomFormScreen> createState() => _SymptomFormScreenState();
}

class _SymptomFormScreenState extends State<SymptomFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _symptomService = SymptomService();
  final _uuid = const Uuid();

  // Controladores y variables de estado
  DateTime _recordDate = DateTime.now();
  final _symptomTypeController = TextEditingController();
  final _detailedDescriptionController = TextEditingController();
  double _painLevel = 5.0;
  final List<String> _selectedPainLocations = [];
  TimeOfDay? _startTime;
  final _estimatedDurationController = TextEditingController();
  String? _selectedDurationUnit = 'minuto(s)';
  String? _selectedFrequency = 'primera vez';
  final _activityAtOnsetController = TextEditingController();
  final _triggersController = TextEditingController();
  final List<String> _selectedVitalSignChanges = [];
  final _otherVitalSignChangeController = TextEditingController();
  String? _selectedAffectedFunctionality = 'No aplica'; // Changed 'no aplica' to 'No aplica'
  bool _showOtherVitalSignField = false;

  bool _isLoading = false;
  bool _isEditMode = false;

  final List<String> _painLocationOptions = [
    'Cabeza', 'Cuello', 'Hombro', 'Brazo', 'Mano', 'Espalda', 'Pecho', 
    'Abdomen', 'Cadera', 'Pierna', 'Rodilla', 'Pie', 'Otro'
  ];
  final List<String> _durationUnitOptions = ['minuto(s)', 'hora(s)', 'dia(s)'];
  final List<String> _frequencyOptions = ['primera vez', 'ocasional', 'frecuente'];
  final List<String> _vitalSignChangeOptions = ['Presión alta', 'Presión baja', 'Fiebre', 'Hipotermia', 'Taquicardia', 'Bradicardia', 'Otro'];
  final List<String> _affectedFunctionalityOptions = ['Puede caminar', 'Necesita ayuda para moverse', 'Postrado en cama', 'No afecta movilidad', 'No aplica'];

  @override
  void initState() {
    super.initState();
    if (widget.symptomId != null) {
      _isEditMode = true;
      _loadSymptomData(widget.symptomId!);
    }
  }

  Future<void> _loadSymptomData(String id) async {
    setState(() => _isLoading = true);
    final symptom = await _symptomService.getSymptomById(id);
    if (symptom != null && mounted) {
      setState(() {
        _recordDate = symptom.recordDate;
        _symptomTypeController.text = symptom.symptomType ?? '';
        _detailedDescriptionController.text = symptom.detailedDescription ?? '';
        _painLevel = symptom.painLevel?.toDouble() ?? 5.0;
        _selectedPainLocations.addAll(symptom.painLocation ?? []);
        _startTime = symptom.startTime != null ? TimeOfDay.fromDateTime(symptom.startTime!) : null;
        _estimatedDurationController.text = symptom.estimatedDuration?.toString() ?? '';
        _selectedDurationUnit = symptom.durationUnit ?? 'minuto(s)';
        _selectedFrequency = symptom.frequency ?? 'primera vez';
        _activityAtOnsetController.text = symptom.activityAtOnset ?? '';
        _triggersController.text = symptom.triggers ?? '';
        _selectedVitalSignChanges.addAll(symptom.vitalSignChanges ?? []);
        if (_selectedVitalSignChanges.contains('Otro')) {
          _showOtherVitalSignField = true;
          _otherVitalSignChangeController.text = symptom.otherVitalSignChange ?? '';
        }
        _selectedAffectedFunctionality = symptom.affectedFunctionality ?? 'No aplica'; // Ensure consistency here too
        _isLoading = false;
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _startTime) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  Future<void> _saveSymptom() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final symptomData = SymptomData(
        id: _isEditMode ? widget.symptomId! : _uuid.v4(),
        recordDate: _recordDate,
        symptomType: _symptomTypeController.text,
        detailedDescription: _detailedDescriptionController.text,
        painLevel: _painLevel.toInt(),
        painLocation: _selectedPainLocations,
        startTime: _startTime != null 
            ? DateTime(_recordDate.year, _recordDate.month, _recordDate.day, _startTime!.hour, _startTime!.minute)
            : null,
        estimatedDuration: int.tryParse(_estimatedDurationController.text),
        durationUnit: _selectedDurationUnit,
        frequency: _selectedFrequency,
        activityAtOnset: _activityAtOnsetController.text,
        triggers: _triggersController.text,
        vitalSignChanges: _selectedVitalSignChanges,
        otherVitalSignChange: _showOtherVitalSignField ? _otherVitalSignChangeController.text : null,
        affectedFunctionality: _selectedAffectedFunctionality,
        userId: '', // Se asignará en el servicio
      );

      final success = await _symptomService.saveSymptom(symptomData);

      if (mounted) {
        setState(() => _isLoading = false);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Síntoma guardado correctamente')),
          );
          Navigator.pop(context, true); // Indicar que se guardó
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al guardar el síntoma')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Editar Síntoma' : 'Registrar Síntoma'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: <Widget>[
                  Text('Fecha y Hora de Registro: ${DateFormat('dd/MM/yyyy HH:mm').format(_recordDate)}', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _symptomTypeController,
                    decoration: const InputDecoration(labelText: 'Tipo de síntoma/malestar (dolor, mareo, etc.)'),
                    validator: (value) => value!.isEmpty ? 'Este campo es obligatorio' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _detailedDescriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Descripción detallada',
                      hintText: 'Ej: Dolor punzante en la sien derecha, acompañado de sensibilidad a la luz.',
                      alignLabelWithHint: true,
                    ),
                    maxLines: 3,
                    validator: (value) => value!.isEmpty ? 'Este campo es obligatorio' : null,
                  ),
                  const SizedBox(height: 16),
                  Text('Nivel de dolor/intensidad: ${_painLevel.toInt()}'),
                  Slider(
                    value: _painLevel,
                    min: 1,
                    max: 10,
                    divisions: 9,
                    label: _painLevel.toInt().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _painLevel = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Text('Ubicación específica del dolor (si aplica):'),
                  Wrap(
                    spacing: 8.0,
                    children: _painLocationOptions.map((location) {
                      return ChoiceChip(
                        label: Text(location),
                        selected: _selectedPainLocations.contains(location),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedPainLocations.add(location);
                            } else {
                              _selectedPainLocations.remove(location);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: Text('Hora de inicio de los síntomas: ${_startTime == null ? 'No establecida' : _startTime!.format(context)}'),
                    trailing: const Icon(Icons.access_time),
                    onTap: () => _selectStartTime(context),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _estimatedDurationController,
                          decoration: const InputDecoration(labelText: 'Duración estimada'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        value: _selectedDurationUnit,
                        items: _durationUnitOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedDurationUnit = newValue;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Frecuencia'),
                    value: _selectedFrequency,
                    items: _frequencyOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedFrequency = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _activityAtOnsetController,
                    decoration: const InputDecoration(labelText: 'Actividad que realizaba al inicio'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _triggersController,
                    decoration: const InputDecoration(labelText: 'Factores desencadenantes (comida, clima, estrés, etc.)'),
                  ),
                  const SizedBox(height: 16),
                  Text('Cambios en signos vitales:'),
                  Wrap(
                    spacing: 8.0,
                    children: _vitalSignChangeOptions.map((vitalSign) {
                      return ChoiceChip(
                        label: Text(vitalSign),
                        selected: _selectedVitalSignChanges.contains(vitalSign),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedVitalSignChanges.add(vitalSign);
                              if (vitalSign == 'Otro') {
                                _showOtherVitalSignField = true;
                              }
                            } else {
                              _selectedVitalSignChanges.remove(vitalSign);
                              if (vitalSign == 'Otro') {
                                _showOtherVitalSignField = false;
                                _otherVitalSignChangeController.clear();
                              }
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  if (_showOtherVitalSignField)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextFormField(
                        controller: _otherVitalSignChangeController,
                        decoration: const InputDecoration(labelText: 'Otro cambio en signo vital'),
                      ),
                    ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Nivel de funcionalidad afectada'),
                    value: _selectedAffectedFunctionality,
                    items: _affectedFunctionalityOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedAffectedFunctionality = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveSymptom,
                    child: Text(_isEditMode ? 'Guardar Cambios' : 'Registrar Síntoma'),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _symptomTypeController.dispose();
    _detailedDescriptionController.dispose();
    _estimatedDurationController.dispose();
    _activityAtOnsetController.dispose();
    _triggersController.dispose();
    _otherVitalSignChangeController.dispose();
    super.dispose();
  }
}