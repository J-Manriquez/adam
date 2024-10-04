import 'package:flutter/material.dart';
import 'package:ADAM/database/metodos/centros_medicos_metodos.dart'; // Importa el CRUD actualizado
import 'package:ADAM/models/db_model.dart'; // Importa el modelo CentroMedico
import 'package:ADAM/utils/custom_logger.dart';
import 'package:ADAM/models/theme_model.dart';
import 'package:ADAM/models/font_size_model.dart';
import 'package:provider/provider.dart';

class CentrosMedicosScreen extends StatefulWidget {
  @override
  _CentrosMedicosScreenState createState() => _CentrosMedicosScreenState();
}

class _CentrosMedicosScreenState extends State<CentrosMedicosScreen> {
  String? selectedRegion;
  String? selectedComuna;
  List<CentroMedico> centrosMedicos = [];
  List<String> regiones = [];
  List<String> comunas = [];

  @override
  void initState() {
    super.initState();
    _loadCentrosMedicos();
    _loadRegiones();
  }

  // Función para cargar los centros médicos
  Future<void> _loadCentrosMedicos({String? region, String? comuna}) async {
    try {
      final data = await CentrosMedicosCRUD.getCentrosMedicos(
          region: region, comuna: comuna);
      setState(() {
        centrosMedicos = data; // Almacena la lista de centros médicos
      });
    } catch (e) {
      CustomLogger().logError('Error al cargar centros médicos: $e');
    }
  }

  // Función para cargar las regiones
  Future<void> _loadRegiones() async {
    try {
      final data = await CentrosMedicosCRUD.getRegiones();
      setState(() {
        regiones = data
          ..sort(); // Almacena y ordena la lista de regiones alfabéticamente
      });
    } catch (e) {
      CustomLogger().logError('Error al cargar regiones: $e');
    }
  }

  // Función para cargar las comunas en base a la región seleccionada
  Future<void> _loadComunas(String region) async {
    try {
      final data = await CentrosMedicosCRUD.getComunas(region);
      setState(() {
        comunas = data
          ..sort(); // Almacena y ordena la lista de comunas alfabéticamente
      });
    } catch (e) {
      CustomLogger().logError('Error al cargar comunas: $e');
    }
  }

  // Método para mostrar información detallada del centro médico en un modal
  void _showCentroMedicoDetails(CentroMedico centro) {
    final themeModel = Provider.of<ThemeModel>(context, listen: false);
    final fontSizeModel = Provider.of<FontSizeModel>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              themeModel.primaryButtonColor, // Aplicar modelo de color al fondo
          title: Center(
            child: Text(
              centro.nombreOficial,
              style: TextStyle(
                  color: themeModel.primaryTextColor,
                  fontSize: fontSizeModel.titleSize),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Divider para separar el título del contenido
              Container(
                width: MediaQuery.of(context).size.width * 0.8, // 80% del ancho
                child: Divider(
                  color: themeModel.primaryTextColor, // Color del divider
                  thickness: 2, // Grosor del divider
                  height: 20, // Espacio alrededor
                ),
              ),
              // Línea con dirección, comuna y un ícono de mapa
              GestureDetector(
                onTap: () {
                  // Aquí puedes definir la función para manejar el toque en esta línea
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Espacio entre los elementos
                  children: [
                    Expanded(
                      child: Text(
                        '${centro.direccion},\n${centro.comuna}, ${centro.region}', // Mostrar dirección y comuna
                        style: TextStyle(
                            color: themeModel.primaryTextColor,
                            fontSize: fontSizeModel.textSize),
                      ),
                    ),
                    Icon(Icons.map,
                        color: themeModel.primaryIconColor,
                        size: fontSizeModel.iconSize,) // Ícono de mapa
                  ],
                ),
              ),
              SizedBox(height: 8), // Espacio adicional
              // Divider para separar la información del teléfono
              Container(
                width: MediaQuery.of(context).size.width * 0.8, // 80% del ancho
                child: Divider(
                  color: themeModel.primaryTextColor, // Color del divider
                  thickness: 2, // Grosor del divider
                  height: 20, // Espacio alrededor
                ),
              ),
              // Línea con teléfono y un ícono de llamada
              GestureDetector(
                onTap: () {
                  // Aquí puedes definir la función para manejar el toque en esta línea
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Espacio entre los elementos
                  children: [
                    Expanded(
                      child: Text(
                        '${centro.telefono ?? 'Sin teléfono'}', // Mostrar teléfono
                        style: TextStyle(
                            color: themeModel.primaryTextColor,
                            fontSize: fontSizeModel.textSize),
                      ),
                    ),
                    Icon(Icons.phone,
                        color: themeModel.primaryTextColor,
                        size: fontSizeModel.iconSize,), // Ícono de llamada
                  ],
                ),
              ),
              SizedBox(height: 16), // Espacio adicional antes del botón
              // Botón para cerrar el modal
              Container(
                width: MediaQuery.of(context).size.width * 0.8, // 80% del ancho
                padding: const EdgeInsets.all(8.0), // Opcional: padding interno
                decoration: BoxDecoration(
                  color:
                      themeModel.primaryIconColor, // Color del fondo del Container
                  borderRadius: BorderRadius.circular(
                      8.0), // Esquina redondeada (opcional)
                ),
                child: TextButton(
                  // Botón cambiado a TextButton para más flexibilidad
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cerrar',
                    style: TextStyle(
                        color: themeModel.primaryButtonColor,
                        fontSize: fontSizeModel.subtitleSize), // Color del texto
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Obtener los modelos de color y tamaño desde el proveedor
    final themeModel = Provider.of<ThemeModel>(context);
    final fontSizeModel = Provider.of<FontSizeModel>(context);

    return Scaffold(
      appBar: AppBar(
        leading: Container(
          alignment: Alignment.center,
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: themeModel.primaryIconColor),
            iconSize: fontSizeModel.iconSize, // Tamaño dinámico del ícono
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                'Centros Médicos',
                style: TextStyle(
                  fontSize:
                      fontSizeModel.titleSize, // Tamaño dinámico para subtítulo
                  color:
                      themeModel.primaryTextColor, // Color dinámico del texto
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
        backgroundColor:
            themeModel.primaryButtonColor, // Color dinámico del AppBar
      ),
      body: Container(
        color: themeModel.backgroundColor, // Aplicar color de fondo
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: selectedRegion,
              hint: Text('Selecciona una Región',
                  style: TextStyle(color: themeModel.secondaryTextColor)),
              onChanged: (value) {
                setState(() {
                  selectedRegion = value;
                  selectedComuna = null;
                  comunas.clear();
                  if (value != null) _loadComunas(value);
                });
              },
              items: regiones.map((region) {
                return DropdownMenuItem(
                  value: region,
                  child: Text(region,
                      style: TextStyle(color: themeModel.secondaryTextColor)),
                );
              }).toList(),
              dropdownColor:
                  themeModel.primaryButtonColor, // Color del dropdown
              isExpanded: true, // Hacer el dropdown de ancho completo
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: selectedComuna,
              hint: Text('Selecciona una Comuna',
                  style: TextStyle(color: themeModel.secondaryTextColor)),
              onChanged: selectedRegion == null
                  ? null
                  : (value) {
                      setState(() {
                        selectedComuna = value;
                      });
                    },
              items: comunas.map((comuna) {
                return DropdownMenuItem(
                  value: comuna,
                  child: Text(comuna,
                      style: TextStyle(color: themeModel.secondaryTextColor)),
                );
              }).toList(),
              dropdownColor:
                  themeModel.primaryButtonColor, // Color del dropdown
              isExpanded: true, // Hacer el dropdown de ancho completo
            ),
            SizedBox(height: 16),
            // Botón de búsqueda
            ElevatedButton(
              onPressed: () {
                _loadCentrosMedicos(
                    region: selectedRegion, comuna: selectedComuna);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: themeModel.primaryButtonColor,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: Text(
                'Buscar',
                style: TextStyle(
                  fontSize: fontSizeModel.textSize,
                  color: themeModel.secondaryTextColor,
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: themeModel.primaryButtonColor
                      .withOpacity(0.7), // Fondo del cuadro
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListView.builder(
                  itemCount: centrosMedicos.length,
                  itemBuilder: (context, index) {
                    final centro = centrosMedicos[index];
                    return Column(
                      children: [
                        // ListTile para mostrar el nombre del centro médico
                        ListTile(
                          title: Text(
                            centro.nombreOficial,
                            style:
                                TextStyle(color: themeModel.secondaryTextColor),
                          ),
                          subtitle: Text(
                            '${centro.direccion}, ${centro.comuna}', // Dirección y comuna en la misma línea
                            style:
                                TextStyle(color: themeModel.secondaryTextColor),
                          ),
                          onTap: () => _showCentroMedicoDetails(
                              centro), // Mostrar detalles al tocar
                        ),
                        // Línea de separación
                        Container(
                          width: MediaQuery.of(context).size.width *
                              0.8, // 80% del ancho total
                          child: Divider(
                            color: themeModel
                                .primaryTextColor, // Color de la línea
                            thickness: 2, // Grosor de la línea
                            height: 20, // Espacio alrededor de la línea
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
