import 'package:flutter/material.dart';
import '../../models/lifestyle_data.dart';
import '../../services/form_data_service.dart';

class LifestyleFormScreen extends StatefulWidget {
  const LifestyleFormScreen({super.key});

  @override
  State<LifestyleFormScreen> createState() => _LifestyleFormScreenState();
}

class _LifestyleFormScreenState extends State<LifestyleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formDataService = FormDataService();

  // Controladores para campos de texto
  final _otherPhysicalHobbyController = TextEditingController();
  final _otherMentalHobbyController = TextEditingController();
  final _otherEatingHabitController = TextEditingController();
  final _otherDietaryRestrictionController = TextEditingController();

  // Variables para almacenar los datos del formulario
  List<String> _selectedPhysicalHobbies = [];
  List<String> _customPhysicalHobbies = [];
  String _physicalActivityFrequency = 'Diaria';
  List<String> _selectedMentalHobbies = [];
  List<String> _customMentalHobbies = [];
  List<String> _selectedEatingHabits = [];
  List<String> _customEatingHabits = [];
  List<String> _selectedDietaryRestrictions = [];
  List<String> _customDietaryRestrictions = [];
  bool _alcoholConsumption = false;
  bool _tobaccoConsumption = false;

  bool _isLoading = false;
  bool _isEditing = false;
  bool _showOtherPhysicalHobbyField = false;
  bool _showOtherMentalHobbyField = false;
  bool _showOtherEatingHabitField = false;
  bool _showOtherDietaryRestrictionField = false;

  // Opciones para los dropdowns
  final List<String> _physicalHobbyOptions = [
    'No tiene',
    'Caminar',
    'Correr',
    'Natación',
    'Ciclismo',
    'Yoga',
    'Pilates',
    'Gimnasio',
    'Baile',
    'Otro'
  ];
  final List<String> _physicalActivityFrequencyOptions = [
    'Diaria',
    'Varias veces por semana',
    'Una vez por semana',
    'Ocasional',
    'Nunca'
  ];
  final List<String> _mentalHobbyOptions = [
    'No tiene',
    'Lectura',
    'Crucigramas',
    'Sudoku',
    'Ajedrez',
    'Juegos de mesa',
    'Videojuegos',
    'Pintura',
    'Música',
    'Otro'
  ];
  final List<String> _eatingHabitOptions = [
    'No tiene',
    'Vegetariano',
    'Vegano',
    'Keto',
    'Paleo',
    'Bajo en carbohidratos',
    'Alto en proteínas',
    'Otro'
  ];
  final List<String> _dietaryRestrictionOptions = [
    'No tiene',
    'Sin gluten',
    'Sin lactosa',
    'Sin azúcar',
    'Sin sal',
    'Sin frutos secos',
    'Sin mariscos',
    'Otro'
  ];

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  @override
  void dispose() {
    _otherPhysicalHobbyController.dispose();
    _otherMentalHobbyController.dispose();
    _otherEatingHabitController.dispose();
    _otherDietaryRestrictionController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingData() async {
    setState(() {
      _isLoading = true;
    });

    final data = _formDataService.getLifestyleData();
    if (data != null) {
      setState(() {
        _isEditing = true;
        _selectedPhysicalHobbies = List<String>.from(data.physicalHobbies);
        _customPhysicalHobbies = List<String>.from(data.customPhysicalHobbies);
        _physicalActivityFrequency = data.physicalActivityFrequency;
        _selectedMentalHobbies = List<String>.from(data.mentalHobbies);
        _customMentalHobbies = List<String>.from(data.customMentalHobbies);
        _selectedEatingHabits = List<String>.from(data.eatingHabits);
        _customEatingHabits = List<String>.from(data.customEatingHabits);
        _selectedDietaryRestrictions = List<String>.from(data.dietaryRestrictions);
        _customDietaryRestrictions = List<String>.from(data.customDietaryRestrictions);
        _alcoholConsumption = data.alcoholConsumption;
        _tobaccoConsumption = data.tobaccoConsumption;

        // Verificar si hay opciones "Otro" seleccionadas
        _showOtherPhysicalHobbyField = _selectedPhysicalHobbies.contains('Otro');
        _showOtherMentalHobbyField = _selectedMentalHobbies.contains('Otro');
        _showOtherEatingHabitField = _selectedEatingHabits.contains('Otro');
        _showOtherDietaryRestrictionField = _selectedDietaryRestrictions.contains('Otro');
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
      // Si se seleccionó "No tiene" en pasatiempos físicos, limpiar otras selecciones
      if (_selectedPhysicalHobbies.contains('No tiene')) {
        _selectedPhysicalHobbies = ['No tiene'];
        _customPhysicalHobbies = [];
      }

      // Si se seleccionó "No tiene" en pasatiempos mentales, limpiar otras selecciones
      if (_selectedMentalHobbies.contains('No tiene')) {
        _selectedMentalHobbies = ['No tiene'];
        _customMentalHobbies = [];
      }

      // Si se seleccionó "No tiene" en hábitos alimentarios, limpiar otras selecciones
      if (_selectedEatingHabits.contains('No tiene')) {
        _selectedEatingHabits = ['No tiene'];
        _customEatingHabits = [];
      }

      // Si se seleccionó "No tiene" en restricciones dietéticas, limpiar otras selecciones
      if (_selectedDietaryRestrictions.contains('No tiene')) {
        _selectedDietaryRestrictions = ['No tiene'];
        _customDietaryRestrictions = [];
      }

      final lifestyleData = LifestyleData(
        physicalHobbies: _selectedPhysicalHobbies,
        customPhysicalHobbies: _customPhysicalHobbies,
        physicalActivityFrequency: _physicalActivityFrequency,
        mentalHobbies: _selectedMentalHobbies,
        customMentalHobbies: _customMentalHobbies,
        eatingHabits: _selectedEatingHabits,
        customEatingHabits: _customEatingHabits,
        dietaryRestrictions: _selectedDietaryRestrictions,
        customDietaryRestrictions: _customDietaryRestrictions,
        alcoholConsumption: _alcoholConsumption,
        tobaccoConsumption: _tobaccoConsumption,
      );

      final success = await _formDataService.saveLifestyleData(lifestyleData);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datos de estilo de vida guardados correctamente.')),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar los datos de estilo de vida.')),
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

  // Métodos para manejar la selección de pasatiempos físicos
  void _togglePhysicalHobby(String hobby, bool selected) {
    setState(() {
      if (hobby == 'No tiene' && selected) {
        _selectedPhysicalHobbies = ['No tiene'];
        _showOtherPhysicalHobbyField = false;
      } else {
        if (selected) {
          _selectedPhysicalHobbies.remove('No tiene');
          _selectedPhysicalHobbies.add(hobby);
          if (hobby == 'Otro') {
            _showOtherPhysicalHobbyField = true;
          }
        } else {
          _selectedPhysicalHobbies.remove(hobby);
          if (hobby == 'Otro') {
            _showOtherPhysicalHobbyField = false;
          }
        }
      }
    });
  }

  void _addCustomPhysicalHobby() {
    if (_otherPhysicalHobbyController.text.isNotEmpty) {
      setState(() {
        _customPhysicalHobbies.add(_otherPhysicalHobbyController.text);
        _otherPhysicalHobbyController.clear();
      });
    }
  }

  // Métodos para manejar la selección de pasatiempos mentales
  void _toggleMentalHobby(String hobby, bool selected) {
    setState(() {
      if (hobby == 'No tiene' && selected) {
        _selectedMentalHobbies = ['No tiene'];
        _showOtherMentalHobbyField = false;
      } else {
        if (selected) {
          _selectedMentalHobbies.remove('No tiene');
          _selectedMentalHobbies.add(hobby);
          if (hobby == 'Otro') {
            _showOtherMentalHobbyField = true;
          }
        } else {
          _selectedMentalHobbies.remove(hobby);
          if (hobby == 'Otro') {
            _showOtherMentalHobbyField = false;
          }
        }
      }
    });
  }

  void _addCustomMentalHobby() {
    if (_otherMentalHobbyController.text.isNotEmpty) {
      setState(() {
        _customMentalHobbies.add(_otherMentalHobbyController.text);
        _otherMentalHobbyController.clear();
      });
    }
  }

  // Métodos para manejar la selección de hábitos alimentarios
  void _toggleEatingHabit(String habit, bool selected) {
    setState(() {
      if (habit == 'No tiene' && selected) {
        _selectedEatingHabits = ['No tiene'];
        _showOtherEatingHabitField = false;
      } else {
        if (selected) {
          _selectedEatingHabits.remove('No tiene');
          _selectedEatingHabits.add(habit);
          if (habit == 'Otro') {
            _showOtherEatingHabitField = true;
          }
        } else {
          _selectedEatingHabits.remove(habit);
          if (habit == 'Otro') {
            _showOtherEatingHabitField = false;
          }
        }
      }
    });
  }

  void _addCustomEatingHabit() {
    if (_otherEatingHabitController.text.isNotEmpty) {
      setState(() {
        _customEatingHabits.add(_otherEatingHabitController.text);
        _otherEatingHabitController.clear();
      });
    }
  }

  // Métodos para manejar la selección de restricciones dietéticas
  void _toggleDietaryRestriction(String restriction, bool selected) {
    setState(() {
      if (restriction == 'No tiene' && selected) {
        _selectedDietaryRestrictions = ['No tiene'];
        _showOtherDietaryRestrictionField = false;
      } else {
        if (selected) {
          _selectedDietaryRestrictions.remove('No tiene');
          _selectedDietaryRestrictions.add(restriction);
          if (restriction == 'Otro') {
            _showOtherDietaryRestrictionField = true;
          }
        } else {
          _selectedDietaryRestrictions.remove(restriction);
          if (restriction == 'Otro') {
            _showOtherDietaryRestrictionField = false;
          }
        }
      }
    });
  }

  void _addCustomDietaryRestriction() {
    if (_otherDietaryRestrictionController.text.isNotEmpty) {
      setState(() {
        _customDietaryRestrictions.add(_otherDietaryRestrictionController.text);
        _otherDietaryRestrictionController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar estilo de vida' : 'Estilo de vida'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // Sección de pasatiempos físicos
                    const Text(
                      'Pasatiempos físicos',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      children: _physicalHobbyOptions.map((hobby) {
                        return FilterChip(
                          label: Text(hobby),
                          selected: _selectedPhysicalHobbies.contains(hobby),
                          onSelected: (selected) => _togglePhysicalHobby(hobby, selected),
                        );
                      }).toList(),
                    ),
                    if (_showOtherPhysicalHobbyField) ...[  
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _otherPhysicalHobbyController,
                              decoration: const InputDecoration(
                                labelText: 'Especificar otro pasatiempo físico',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: _addCustomPhysicalHobby,
                          ),
                        ],
                      ),
                    ],
                    if (_customPhysicalHobbies.isNotEmpty) ...[  
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        children: _customPhysicalHobbies.map((hobby) {
                          return Chip(
                            label: Text(hobby),
                            onDeleted: () {
                              setState(() {
                                _customPhysicalHobbies.remove(hobby);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                    
                    const SizedBox(height: 16),
                    // Frecuencia de actividad física
                    const Text(
                      'Frecuencia de actividad física',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _physicalActivityFrequency,
                      items: _physicalActivityFrequencyOptions
                          .map((option) => DropdownMenuItem(
                                value: option,
                                child: Text(option),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _physicalActivityFrequency = value!;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    // Sección de pasatiempos mentales
                    const Text(
                      'Pasatiempos mentales',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      children: _mentalHobbyOptions.map((hobby) {
                        return FilterChip(
                          label: Text(hobby),
                          selected: _selectedMentalHobbies.contains(hobby),
                          onSelected: (selected) => _toggleMentalHobby(hobby, selected),
                        );
                      }).toList(),
                    ),
                    if (_showOtherMentalHobbyField) ...[  
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _otherMentalHobbyController,
                              decoration: const InputDecoration(
                                labelText: 'Especificar otro pasatiempo mental',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: _addCustomMentalHobby,
                          ),
                        ],
                      ),
                    ],
                    if (_customMentalHobbies.isNotEmpty) ...[  
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        children: _customMentalHobbies.map((hobby) {
                          return Chip(
                            label: Text(hobby),
                            onDeleted: () {
                              setState(() {
                                _customMentalHobbies.remove(hobby);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                    
                    const SizedBox(height: 24),
                    // Sección de hábitos alimentarios
                    const Text(
                      'Hábitos alimentarios',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      children: _eatingHabitOptions.map((habit) {
                        return FilterChip(
                          label: Text(habit),
                          selected: _selectedEatingHabits.contains(habit),
                          onSelected: (selected) => _toggleEatingHabit(habit, selected),
                        );
                      }).toList(),
                    ),
                    if (_showOtherEatingHabitField) ...[  
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _otherEatingHabitController,
                              decoration: const InputDecoration(
                                labelText: 'Especificar otro hábito alimentario',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: _addCustomEatingHabit,
                          ),
                        ],
                      ),
                    ],
                    if (_customEatingHabits.isNotEmpty) ...[  
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        children: _customEatingHabits.map((habit) {
                          return Chip(
                            label: Text(habit),
                            onDeleted: () {
                              setState(() {
                                _customEatingHabits.remove(habit);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                    
                    const SizedBox(height: 24),
                    // Sección de restricciones dietéticas
                    const Text(
                      'Restricciones dietéticas',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      children: _dietaryRestrictionOptions.map((restriction) {
                        return FilterChip(
                          label: Text(restriction),
                          selected: _selectedDietaryRestrictions.contains(restriction),
                          onSelected: (selected) => _toggleDietaryRestriction(restriction, selected),
                        );
                      }).toList(),
                    ),
                    if (_showOtherDietaryRestrictionField) ...[  
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _otherDietaryRestrictionController,
                              decoration: const InputDecoration(
                                labelText: 'Especificar otra restricción dietética',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: _addCustomDietaryRestriction,
                          ),
                        ],
                      ),
                    ],
                    if (_customDietaryRestrictions.isNotEmpty) ...[  
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        children: _customDietaryRestrictions.map((restriction) {
                          return Chip(
                            label: Text(restriction),
                            onDeleted: () {
                              setState(() {
                                _customDietaryRestrictions.remove(restriction);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                    
                    const SizedBox(height: 24),
                    // Sección de consumo de alcohol y tabaco
                    const Text(
                      'Consumo de alcohol y tabaco',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      title: const Text('Consumo de alcohol'),
                      value: _alcoholConsumption,
                      onChanged: (value) {
                        setState(() {
                          _alcoholConsumption = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      title: const Text('Consumo de tabaco'),
                      value: _tobaccoConsumption,
                      onChanged: (value) {
                        setState(() {
                          _tobaccoConsumption = value;
                        });
                      },
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