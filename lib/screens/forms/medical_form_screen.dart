import 'package:flutter/material.dart';
import '../../models/medical_data.dart';
import '../../services/form_data_service.dart';

class MedicalFormScreen extends StatefulWidget {
  const MedicalFormScreen({super.key});

  @override
  State<MedicalFormScreen> createState() => _MedicalFormScreenState();
}

class _MedicalFormScreenState extends State<MedicalFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formDataService = FormDataService();

  // Controladores para campos de texto
  final _otherAllergyController = TextEditingController();
  final _otherChronicDiseaseController = TextEditingController();
  final _doctorNameController = TextEditingController();
  final _doctorSpecialtyController = TextEditingController();
  final _doctorPhoneController = TextEditingController();
  final _healthInsuranceDetailController = TextEditingController();

  // Variables para almacenar los datos del formulario
  String _bloodType = 'A';
  String _rhFactor = '+';
  List<String> _selectedAllergies = [];
  List<String> _customAllergies = [];
  List<String> _selectedChronicDiseases = [];
  List<String> _customChronicDiseases = [];
  List<Map<String, String>> _primaryDoctors = [];
  String _healthInsuranceType = 'Fonasa';
  String _healthInsuranceDetail = '';

  bool _isLoading = false;
  bool _isEditing = false;
  bool _showOtherAllergyField = false;
  bool _showOtherChronicDiseaseField = false;

  // Opciones para los dropdowns
  final List<String> _bloodTypeOptions = ['A', 'B', 'AB', 'O'];
  final List<String> _rhFactorOptions = ['+', '-'];
  final List<String> _allergyOptions = [
    'No tiene',
    'Penicilina',
    'Aspirina',
    'Látex',
    'Mariscos',
    'Frutos secos',
    'Polen',
    'Otro'
  ];
  final List<String> _chronicDiseaseOptions = [
    'No tiene',
    'Diabetes',
    'Hipertensión',
    'Asma',
    'Artritis',
    'Enfermedad cardíaca',
    'Enfermedad renal',
    'Otro'
  ];
  final List<String> _healthInsuranceOptions = ['Fonasa', 'Isapre'];
  final List<String> _fonasaLetterOptions = ['A', 'B', 'C', 'D'];
  final List<String> _isapreOptions = [
    'Banmédica',
    'Colmena',
    'Cruz Blanca',
    'Vida Tres',
    'Consalud',
    'Esencial',
    'Otro'
  ];

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  @override
  void dispose() {
    _otherAllergyController.dispose();
    _otherChronicDiseaseController.dispose();
    _doctorNameController.dispose();
    _doctorSpecialtyController.dispose();
    _doctorPhoneController.dispose();
    _healthInsuranceDetailController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingData() async {
    setState(() {
      _isLoading = true;
    });

    final data = _formDataService.getMedicalData();
    if (data != null) {
      setState(() {
        _isEditing = true;
        _bloodType = data.bloodType;
        _rhFactor = data.rhFactor;
        _selectedAllergies = List<String>.from(data.allergies);
        _customAllergies = List<String>.from(data.customAllergies);
        _selectedChronicDiseases = List<String>.from(data.chronicDiseases);
        _customChronicDiseases = List<String>.from(data.customChronicDiseases);
        _primaryDoctors = List<Map<String, String>>.from(data.primaryDoctors);
        _healthInsuranceType = data.healthInsuranceType;
        _healthInsuranceDetail = data.healthInsuranceDetail;

        // Verificar si hay opciones "Otro" seleccionadas
        _showOtherAllergyField = _selectedAllergies.contains('Otro');
        _showOtherChronicDiseaseField = _selectedChronicDiseases.contains('Otro');

        // Establecer el valor del controlador de detalle de seguro de salud
        _healthInsuranceDetailController.text = _healthInsuranceDetail;
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
      // Si se seleccionó "No tiene" en alergias, limpiar otras selecciones
      if (_selectedAllergies.contains('No tiene')) {
        _selectedAllergies = ['No tiene'];
        _customAllergies = [];
      }

      // Si se seleccionó "No tiene" en enfermedades crónicas, limpiar otras selecciones
      if (_selectedChronicDiseases.contains('No tiene')) {
        _selectedChronicDiseases = ['No tiene'];
        _customChronicDiseases = [];
      }

      final medicalData = MedicalData(
        bloodType: _bloodType,
        rhFactor: _rhFactor,
        allergies: _selectedAllergies,
        customAllergies: _customAllergies,
        chronicDiseases: _selectedChronicDiseases,
        customChronicDiseases: _customChronicDiseases,
        primaryDoctors: _primaryDoctors,
        healthInsuranceType: _healthInsuranceType,
        healthInsuranceDetail: _healthInsuranceDetail,
      );

      final success = await _formDataService.saveMedicalData(medicalData);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datos médicos guardados correctamente.')),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar los datos médicos.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addCustomAllergy() {
    final allergy = _otherAllergyController.text.trim();
    if (allergy.isNotEmpty) {
      setState(() {
        _customAllergies.add(allergy);
        _otherAllergyController.clear();
      });
    }
  }

  void _addCustomChronicDisease() {
    final disease = _otherChronicDiseaseController.text.trim();
    if (disease.isNotEmpty) {
      setState(() {
        _customChronicDiseases.add(disease);
        _otherChronicDiseaseController.clear();
      });
    }
  }

  void _addPrimaryDoctor() {
    final name = _doctorNameController.text.trim();
    final specialty = _doctorSpecialtyController.text.trim();
    final phone = _doctorPhoneController.text.trim();

    if (name.isNotEmpty && specialty.isNotEmpty && phone.isNotEmpty) {
      setState(() {
        _primaryDoctors.add({
          'name': name,
          'specialty': specialty,
          'phone': phone,
        });
        _doctorNameController.clear();
        _doctorSpecialtyController.clear();
        _doctorPhoneController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar información médica' : 'Información médica'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // Tipo de sangre
                    const Text(
                      'Tipo de sangre',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _bloodType,
                            decoration: const InputDecoration(labelText: 'Tipo'),
                            items: _bloodTypeOptions
                                .map((option) => DropdownMenuItem(
                                      value: option,
                                      child: Text(option),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _bloodType = value!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _rhFactor,
                            decoration: const InputDecoration(labelText: 'Factor RH'),
                            items: _rhFactorOptions
                                .map((option) => DropdownMenuItem(
                                      value: option,
                                      child: Text(option),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _rhFactor = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Alergias conocidas
                    const Text(
                      'Alergias conocidas (obligatorio)',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      children: _allergyOptions.map((option) {
                        final isSelected = _selectedAllergies.contains(option);
                        return FilterChip(
                          label: Text(option),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (option == 'No tiene') {
                                _selectedAllergies = selected ? ['No tiene'] : [];
                              } else {
                                if (selected) {
                                  _selectedAllergies.remove('No tiene');
                                  _selectedAllergies.add(option);
                                } else {
                                  _selectedAllergies.remove(option);
                                }
                              }
                              _showOtherAllergyField = _selectedAllergies.contains('Otro');
                            });
                          },
                        );
                      }).toList(),
                    ),
                    if (_selectedAllergies.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Seleccione al menos una opción',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    if (_showOtherAllergyField) ...[  
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _otherAllergyController,
                              decoration: const InputDecoration(
                                labelText: 'Especifique otra alergia',
                                hintText: 'Ingrese la alergia',
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle),
                            onPressed: _addCustomAllergy,
                          ),
                        ],
                      ),
                    ],
                    if (_customAllergies.isNotEmpty) ...[  
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        children: _customAllergies.map((allergy) {
                          return Chip(
                            label: Text(allergy),
                            onDeleted: () {
                              setState(() {
                                _customAllergies.remove(allergy);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                    const SizedBox(height: 24),

                    // Enfermedades crónicas
                    const Text(
                      'Enfermedades crónicas diagnosticadas (obligatorio)',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      children: _chronicDiseaseOptions.map((option) {
                        final isSelected = _selectedChronicDiseases.contains(option);
                        return FilterChip(
                          label: Text(option),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (option == 'No tiene') {
                                _selectedChronicDiseases = selected ? ['No tiene'] : [];
                              } else {
                                if (selected) {
                                  _selectedChronicDiseases.remove('No tiene');
                                  _selectedChronicDiseases.add(option);
                                } else {
                                  _selectedChronicDiseases.remove(option);
                                }
                              }
                              _showOtherChronicDiseaseField = _selectedChronicDiseases.contains('Otro');
                            });
                          },
                        );
                      }).toList(),
                    ),
                    if (_selectedChronicDiseases.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Seleccione al menos una opción',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    if (_showOtherChronicDiseaseField) ...[  
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _otherChronicDiseaseController,
                              decoration: const InputDecoration(
                                labelText: 'Especifique otra enfermedad',
                                hintText: 'Ingrese la enfermedad',
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle),
                            onPressed: _addCustomChronicDisease,
                          ),
                        ],
                      ),
                    ],
                    if (_customChronicDiseases.isNotEmpty) ...[  
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        children: _customChronicDiseases.map((disease) {
                          return Chip(
                            label: Text(disease),
                            onDeleted: () {
                              setState(() {
                                _customChronicDiseases.remove(disease);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                    const SizedBox(height: 24),

                    // Médico de cabecera
                    const Text(
                      'Médico de cabecera',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _doctorNameController,
                      decoration: const InputDecoration(labelText: 'Nombre del médico'),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _doctorSpecialtyController,
                      decoration: const InputDecoration(labelText: 'Especialidad'),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _doctorPhoneController,
                            decoration: const InputDecoration(labelText: 'Teléfono'),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle),
                          onPressed: _addPrimaryDoctor,
                        ),
                      ],
                    ),
                    if (_primaryDoctors.isNotEmpty) ...[  
                      const SizedBox(height: 16),
                      const Text('Médicos registrados:'),
                      const SizedBox(height: 8),
                      ..._primaryDoctors.map((doctor) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            title: Text(doctor['name']!),
                            subtitle: Text('${doctor['specialty']} - ${doctor['phone']}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  _primaryDoctors.remove(doctor);
                                });
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                    const SizedBox(height: 24),

                    // Seguro de salud
                    const Text(
                      'Seguro de salud (obligatorio)',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _healthInsuranceType,
                      decoration: const InputDecoration(labelText: 'Tipo de seguro'),
                      items: _healthInsuranceOptions
                          .map((option) => DropdownMenuItem(
                                value: option,
                                child: Text(option),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _healthInsuranceType = value!;
                          // Limpiar el detalle al cambiar el tipo
                          _healthInsuranceDetail = '';
                          _healthInsuranceDetailController.clear();
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Seleccione un tipo de seguro';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    if (_healthInsuranceType == 'Fonasa')
                      DropdownButtonFormField<String>(
                        value: _healthInsuranceDetail.isNotEmpty ? _healthInsuranceDetail : null,
                        decoration: const InputDecoration(labelText: 'Letra Fonasa'),
                        items: _fonasaLetterOptions
                            .map((option) => DropdownMenuItem(
                                  value: option,
                                  child: Text(option),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _healthInsuranceDetail = value!;
                            _healthInsuranceDetailController.text = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Seleccione una letra';
                          }
                          return null;
                        },
                      )
                    else
                      DropdownButtonFormField<String>(
                        value: _isapreOptions.contains(_healthInsuranceDetail) ? _healthInsuranceDetail : null,
                        decoration: const InputDecoration(labelText: 'Isapre'),
                        items: _isapreOptions
                            .map((option) => DropdownMenuItem(
                                  value: option,
                                  child: Text(option),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _healthInsuranceDetail = value!;
                            _healthInsuranceDetailController.text = value == 'Otro' ? '' : value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Seleccione una Isapre';
                          }
                          return null;
                        },
                      ),
                    if (_healthInsuranceType == 'Isapre' && _healthInsuranceDetail == 'Otro')
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: TextFormField(
                          controller: _healthInsuranceDetailController,
                          decoration: const InputDecoration(labelText: 'Especifique la Isapre'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese el nombre de la Isapre';
                            }
                            return null;
                          },
                        ),
                      ),
                    const SizedBox(height: 32),
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