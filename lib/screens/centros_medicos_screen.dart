import 'package:flutter/material.dart';
import 'package:ADAM/services/db_adam.dart'; // Asumiendo que la base de datos está en db_adam.dart
import 'package:ADAM/utils/custom_logger.dart'; // Para logging

class CentrosMedicosScreen extends StatefulWidget {
  @override
  _CentrosMedicosScreenState createState() => _CentrosMedicosScreenState();
}

class _CentrosMedicosScreenState extends State<CentrosMedicosScreen> {
  // Variables para almacenar las regiones, comunas y resultados de la búsqueda
  List<String> regiones = []; // Lista de regiones obtenidas de la base de datos
  List<String> comunas = []; // Lista de comunas obtenidas de la base de datos
  String? regionSeleccionada; // Región seleccionada en el dropdown
  String? comunaSeleccionada; // Comuna seleccionada en el dropdown
  List<Map<String, dynamic>> centrosMedicos = []; // Resultados de la búsqueda

  final dbHelper = DatabaseHelper(); // Instancia de DatabaseHelper

  // Inicialización del estado
  @override
  void initState() {
    super.initState();
    _loadRegiones(); // Cargar las regiones al iniciar la pantalla
  }

  // Método para cargar las regiones desde la base de datos
  Future<void> _loadRegiones() async {
    try {
      // Obtener lista de regiones desde la base de datos
      final List<String> fetchedRegiones = await dbHelper.getRegiones();
      setState(() {
        regiones = fetchedRegiones;
      });
    } catch (e) {
      CustomLogger().logError("Error al cargar regiones: $e");
    }
  }

  // Método para cargar las comunas según la región seleccionada
  Future<void> _loadComunas(String region) async {
    try {
      // Obtener lista de comunas desde la base de datos para la región seleccionada
      final List<String> fetchedComunas = await dbHelper.getComunasByRegion(region);
      setState(() {
        comunas = fetchedComunas;
        comunaSeleccionada = null; // Reiniciar la comuna seleccionada
      });
    } catch (e) {
      CustomLogger().logError("Error al cargar comunas: $e");
    }
  }

  // Método para buscar centros médicos según la región y comuna seleccionada
  Future<void> _buscarCentrosMedicos() async {
    try {
      // Si la región o comuna no están seleccionadas, mostrar todos los centros
      final List<Map<String, dynamic>> fetchedCentros = await dbHelper.getCentrosMedicos(regionSeleccionada, comunaSeleccionada);
      setState(() {
        centrosMedicos = fetchedCentros;
      });
    } catch (e) {
      CustomLogger().logError("Error al buscar centros médicos: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Centros Médicos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown para seleccionar la región
            DropdownButton<String>(
              hint: Text('Selecciona una región'),
              value: regionSeleccionada,
              isExpanded: true,
              onChanged: (String? newValue) {
                setState(() {
                  regionSeleccionada = newValue;
                  _loadComunas(newValue!); // Cargar las comunas al seleccionar región
                });
              },
              items: regiones.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),

            // Dropdown para seleccionar la comuna
            DropdownButton<String>(
              hint: Text('Selecciona una comuna'),
              value: comunaSeleccionada,
              isExpanded: true,
              onChanged: (String? newValue) {
                setState(() {
                  comunaSeleccionada = newValue;
                });
              },
              items: comunas.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),

            // Botón de buscar
            ElevatedButton(
              onPressed: _buscarCentrosMedicos, // Ejecuta la búsqueda
              child: Text('Buscar'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // Botón ocupa el ancho completo
              ),
            ),
            SizedBox(height: 16),

            // Lista de resultados
            Expanded(
              child: ListView.builder(
                itemCount: centrosMedicos.length,
                itemBuilder: (context, index) {
                  final centro = centrosMedicos[index];
                  return ListTile(
                    title: Text(centro['nombre']), // Mostrar nombre del centro
                    onTap: () {
                      // Mostrar modal con los detalles al tocar
                      _mostrarDetalleCentroMedico(context, centro);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para mostrar el modal con detalles del centro médico
  void _mostrarDetalleCentroMedico(BuildContext context, Map<String, dynamic> centro) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Tamaño mínimo para ajustar al contenido
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Detalles del Centro', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context); // Cerrar el modal
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text('Nombre: ${centro['Nombre_Oficial']}'),
              Text('Teléfono: ${centro['Telefono']}'),
              Text('Comuna, Región: ${centro['Comuna']}, ${centro['Region']}'),
              Text('Actualizado al: ${centro['Actualizado_al']}'),
            ],
          ),
        );
      },
    );
  }
}
