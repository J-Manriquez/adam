import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/medication_data.dart';
import '../../services/medication_service.dart';

class MedicationFormScreen extends StatefulWidget {
  final String? medicationId;
  
  const MedicationFormScreen({super.key, this.medicationId});

  @override
  State<MedicationFormScreen> createState() => _MedicationFormScreenState();
}

class _MedicationFormScreenState extends State<MedicationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _medicationService = MedicationService();
  
  // Controladores para campos de texto
  final _nameController = TextEditingController();
  final _concentrationController = TextEditingController();
  final _durationDaysController = TextEditingController();
  final _specialInstructionsController = TextEditingController();
  
  // Variables para almacenar los datos del formulario
  String _concentrationUnit = 'mg';
  String _form = 'Tableta';
  int _frequency = 1;
  TimeOfDay _startTime = TimeOfDay.now();
  bool _isIndefinite = false;
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  
  bool _isLoading = false;
  bool _isEditing = false;
  
  // Opciones para los dropdowns
  final List<String> _concentrationUnitOptions = ['mg', 'ml', 'g', 'mcg', 'UI'];
  final List<String> _formOptions = ['Tableta', 'Cápsula', 'Jarabe', 'Gotas', 'Inyectable', 'Parche', 'Inhalador', 'Crema', 'Supositorio'];
  final List<String> _durationOptions = ['Indefinido', 'Rango de días'];
  
  @override
  void initState() {
    super.initState();
    if (widget.medicationId != null) {
      _loadExistingData();
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _concentrationController.dispose();
    _durationDaysController.dispose();
    _specialInstructionsController.dispose();
    super.dispose();
  }
  
  Future<void> _loadExistingData() async {
    setState(() {
      _isLoading = true;
    });
    
    final medication = _medicationService.getMedicationById(widget.medicationId!);
    if (medication != null) {
      setState(() {
        _isEditing = true;
        _nameController.text = medication.name;
        _concentrationController.text = medication.concentration;
        _concentrationUnit = medication.concentrationUnit;
        _form = medication.form;
        _frequency = medication.frequency;
        _startTime = TimeOfDay.fromDateTime(medication.startTime);
        _isIndefinite = medication.isIndefinite;
        _startDate = medication.startDate;
        _endDate = medication.endDate;
        
        if (!_isIndefinite && medication.durationDays != null) {
          _durationDaysController.text = medication.durationDays.toString();
        }
        
        _specialInstructionsController.text = medication.specialInstructions;
      });
    }
    
    setState(() {
      _isLoading = false;
    });
  }
  
  Future<void> _selectStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    
    if (picked != null && picked != _startTime) {
      setState(() {
        _startTime = picked;
      });
    }
  }
  
  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        _calculateEndDate();
      });
    }
  }
  
  void _calculateEndDate() {
    if (!_isIndefinite && _durationDaysController.text.isNotEmpty) {
      final days = int.tryParse(_durationDaysController.text) ?? 0;
      if (days > 0) {
        setState(() {
          _endDate = _startDate.add(Duration(days: days));
        });
      }
    } else {
      setState(() {
        _endDate = null;
      });
    }
  }
  
  Future<void> _saveMedication() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Crear objeto de medicamento
      final medication = MedicationData(
        id: widget.medicationId ?? '',
        name: _nameController.text,
        concentration: _concentrationController.text,
        concentrationUnit: _concentrationUnit,
        form: _form,
        frequency: _frequency,
        startTime: DateTime(
          _startDate.year,
          _startDate.month,
          _startDate.day,
          _startTime.hour,
          _startTime.minute,
        ),
        isIndefinite: _isIndefinite,
        durationDays: _isIndefinite ? null : int.tryParse(_durationDaysController.text),
        startDate: _startDate,
        endDate: _endDate,
        specialInstructions: _specialInstructionsController.text,
      );
      
      // Guardar medicamento
      final success = await _medicationService.saveMedication(medication);
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Medicamento guardado correctamente')),
        );
        Navigator.pop(context, true);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar el medicamento')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Medicamento' : 'Nuevo Medicamento'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sección: Información del Medicamento
                    const Text(
                      'Información del Medicamento',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    
                    // Nombre del medicamento
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del medicamento',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el nombre del medicamento';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Concentración/dosis
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _concentrationController,
                            decoration: const InputDecoration(
                              labelText: 'Concentración/dosis',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese la concentración';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: DropdownButtonFormField<String>(
                            value: _concentrationUnit,
                            decoration: const InputDecoration(
                              labelText: 'Unidad',
                              border: OutlineInputBorder(),
                            ),
                            items: _concentrationUnitOptions.map((unit) {
                              return DropdownMenuItem<String>(
                                value: unit,
                                child: Text(unit),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _concentrationUnit = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Forma farmacéutica
                    const Text('Forma farmacéutica'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: _formOptions.map((form) {
                        return ChoiceChip(
                          label: Text(form),
                          selected: _form == form,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _form = form;
                              });
                            }
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    
                    // Sección: Posología y Administración
                    const Text(
                      'Posología y Administración',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    
                    // Frecuencia diaria
                    const Text('Frecuencia diaria'),
                    Slider(
                      value: _frequency.toDouble(),
                      min: 1,
                      max: 6,
                      divisions: 5,
                      label: _frequency.toString(),
                      onChanged: (value) {
                        setState(() {
                          _frequency = value.toInt();
                        });
                      },
                    ),
                    Text(
                      _frequency == 1
                          ? 'Una vez al día'
                          : '$_frequency veces al día (cada ${24 ~/ _frequency} horas)',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),
                    
                    // Hora de inicio
                    ListTile(
                      title: const Text('Hora de inicio'),
                      subtitle: Text(
                        'Primera toma: ${_startTime.format(context)}',
                      ),
                      trailing: const Icon(Icons.access_time),
                      onTap: _selectStartTime,
                    ),
                    const SizedBox(height: 16),
                    
                    // Duración del tratamiento
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<bool>(
                            title: const Text('Indefinido'),
                            value: true,
                            groupValue: _isIndefinite,
                            onChanged: (value) {
                              setState(() {
                                _isIndefinite = value!;
                                _calculateEndDate();
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<bool>(
                            title: const Text('Rango de días'),
                            value: false,
                            groupValue: _isIndefinite,
                            onChanged: (value) {
                              setState(() {
                                _isIndefinite = value!;
                                _calculateEndDate();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    
                    // Campo para ingresar días si no es indefinido
                    if (!_isIndefinite) ...[  
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _durationDaysController,
                        decoration: const InputDecoration(
                          labelText: 'Duración (días)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese la duración';
                          }
                          if (int.tryParse(value) == null || int.parse(value) <= 0) {
                            return 'Ingrese un número válido de días';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _calculateEndDate();
                        },
                      ),
                    ],
                    const SizedBox(height: 16),
                    
                    // Fecha de inicio
                    ListTile(
                      title: const Text('Fecha de inicio'),
                      subtitle: Text(
                        DateFormat('dd/MM/yyyy').format(_startDate),
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: _selectStartDate,
                    ),
                    
                    // Mostrar fecha de término si no es indefinido
                    if (!_isIndefinite && _endDate != null) ...[  
                      const SizedBox(height: 8),
                      ListTile(
                        title: const Text('Fecha de término (calculada)'),
                        subtitle: Text(
                          DateFormat('dd/MM/yyyy').format(_endDate!),
                        ),
                        trailing: const Icon(Icons.event_available),
                      ),
                    ],
                    const SizedBox(height: 16),
                    
                    // Instrucciones Especiales
                    TextFormField(
                      controller: _specialInstructionsController,
                      decoration: const InputDecoration(
                        labelText: 'Instrucciones Especiales',
                        hintText: 'Relación con comidas, instrucciones especiales, interacciones conocidas, efectos secundarios a vigilar',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 5,
                    ),
                    const SizedBox(height: 24),
                    
                    // Botón de guardar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveMedication,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(_isEditing ? 'Actualizar Medicamento' : 'Guardar Medicamento'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}