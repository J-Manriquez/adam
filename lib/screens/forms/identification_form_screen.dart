import 'package:adam/models/identification_data.dart';
import 'package:adam/services/form_data_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



class IdentificationFormScreen extends StatefulWidget {
  const IdentificationFormScreen({super.key});

  @override
  State<IdentificationFormScreen> createState() => _IdentificationFormScreenState();
}

class _IdentificationFormScreenState extends State<IdentificationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formDataService = FormDataService();
  
  final _birthDateController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  
  DateTime? _selectedDate;
  int _age = 0;
  String _gender = '';
  bool _isLoading = false;
  bool _isEditing = false;
  
  // Opciones para el dropdown de género
  final List<String> _genderOptions = [
    'Masculino',
    'Femenino',
    'No binario',
    'Prefiero no decir',
    'Otro'
  ];
  
  String? _otherGender;
  final _otherGenderController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }
  
  @override
  void dispose() {
    _birthDateController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _otherGenderController.dispose();
    super.dispose();
  }
  
  // Cargar datos existentes si los hay
  Future<void> _loadExistingData() async {
    setState(() {
      _isLoading = true;
    });
    
    final data = _formDataService.getIdentificationData();
    
    if (data != null) {
      setState(() {
        _isEditing = true;
        _selectedDate = data.birthDate;
        _birthDateController.text = DateFormat('dd/MM/yyyy').format(data.birthDate);
        _age = data.age;
        _gender = data.gender;
        _phoneController.text = data.phone;
        _addressController.text = data.address;
        
        // Verificar si el género es "Otro"
        if (!_genderOptions.contains(_gender) && _gender != 'Otro') {
          _otherGender = _gender;
          _gender = 'Otro';
          _otherGenderController.text = _otherGender!;
        }
      });
    }
    
    setState(() {
      _isLoading = false;
    });
  }
  
  // Calcular edad a partir de la fecha de nacimiento
  void _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    
    if (today.month < birthDate.month || 
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    
    setState(() {
      _age = age;
    });
  }
  
  // Seleccionar fecha de nacimiento
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().subtract(const Duration(days: 365 * 30)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthDateController.text = DateFormat('dd/MM/yyyy').format(picked);
        _calculateAge(picked);
      });
    }
  }
  
  // Guardar datos
  Future<void> _saveData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      // Determinar el valor final del género
      final finalGender = _gender == 'Otro' ? _otherGender! : _gender;
      
      final data = IdentificationData(
        birthDate: _selectedDate!,
        age: _age,
        gender: finalGender,
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
      );
      
      final success = await _formDataService.saveIdentificationData(data);
      
      setState(() {
        _isLoading = false;
      });
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datos guardados correctamente')),
        );
        setState(() {
          _isEditing = true;
        });
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar los datos')),
        );
      }
    }
  }
  
  // Eliminar datos
  Future<void> _deleteData() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Está seguro de que desea eliminar estos datos? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    
    if (confirm == true) {
      setState(() {
        _isLoading = true;
      });
      
      final success = await _formDataService.deleteIdentificationData();
      
      setState(() {
        _isLoading = false;
      });
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datos eliminados correctamente')),
        );
        
        // Limpiar formulario
        setState(() {
          _isEditing = false;
          _selectedDate = null;
          _birthDateController.clear();
          _age = 0;
          _gender = '';
          _phoneController.clear();
          _addressController.clear();
          _otherGender = null;
          _otherGenderController.clear();
        });
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar los datos')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Datos de Identificación' : 'Datos de Identificación'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteData,
              tooltip: 'Eliminar datos',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Fecha de nacimiento
                    TextFormField(
                      controller: _birthDateController,
                      decoration: const InputDecoration(
                        labelText: 'Fecha de nacimiento *',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor seleccione una fecha de nacimiento';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    
                    // Edad calculada
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Edad: $_age años',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Género
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Género *',
                        border: OutlineInputBorder(),
                      ),
                      value: _gender.isNotEmpty ? _gender : null,
                      items: _genderOptions.map((String gender) {
                        return DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _gender = newValue!;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor seleccione un género';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Campo para "Otro" género
                    if (_gender == 'Otro')
                      TextFormField(
                        controller: _otherGenderController,
                        decoration: const InputDecoration(
                          labelText: 'Especifique género *',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          _otherGender = value;
                        },
                        validator: (value) {
                          if (_gender == 'Otro' && (value == null || value.isEmpty)) {
                            return 'Por favor especifique el género';
                          }
                          return null;
                        },
                      ),
                    if (_gender == 'Otro') const SizedBox(height: 16),
                    
                    // Teléfono
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Teléfono principal *',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese un número de teléfono';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Dirección
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Dirección completa *',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese una dirección';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    
                    // Botón guardar
                    ElevatedButton(
                      onPressed: _saveData,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(_isEditing ? 'Actualizar datos' : 'Guardar datos'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}