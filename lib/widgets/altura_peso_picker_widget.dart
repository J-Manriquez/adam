import 'package:ADAM/models/font_size_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ADAM/models/theme_model.dart'; // Importamos el modelo de tema
import 'package:provider/provider.dart';

class AlturaPesoPicker extends StatefulWidget {
  final String title; // Altura o Peso
  final Function(double) onValueSelected;

  const AlturaPesoPicker({
    Key? key,
    required this.title,
    required this.onValueSelected,
    required Color selectedColor,
  }) : super(key: key);

  @override
  _AlturaPesoPickerState createState() => _AlturaPesoPickerState();
}

class _AlturaPesoPickerState extends State<AlturaPesoPicker> {
  int enteroSeleccionado = 0; // Número entero seleccionado
  int decimalSeleccionado = 0; // Número decimal seleccionado

  // Valores iniciales por defecto (se ajustan en initState)
  late List<int> enteros;
  late List<int> decimales;

  // Listas generadas con los rangos solicitados
  final List<int> enterosAltura = List.generate(161, (index) => index + 80); // Parte entera de la altura (80 - 240 cm)
  final List<int> decimalesAltura = List.generate(10, (index) => index); // Parte decimal de la altura (0.0 - 0.9 cm)

  final List<int> enterosPeso = List.generate(171, (index) => index + 30); // Parte entera del peso (30 - 200 kg)
  final List<int> decimalesPeso = List.generate(10, (index) => index); // Parte decimal del peso (0.0 - 0.9 kg)

  // Inicializamos los valores seleccionados
  @override
  void initState() {
    super.initState();

    // Verificamos si es un picker para "Altura" o "Peso"
    if (widget.title == "Altura") {
      // Configuración inicial para altura
      enteros = enterosAltura;
      decimales = decimalesAltura;
      enteroSeleccionado = enteros.indexOf(150); // Ejemplo: 150 cm (dentro del rango 80 - 240)
    } else if (widget.title == "Peso") {
      // Configuración inicial para peso
      enteros = enterosPeso;
      decimales = decimalesPeso;
      enteroSeleccionado = enteros.indexOf(60); // Ejemplo: 60 kg (dentro del rango 30 - 200)
    }
  }

  // Método para abrir el modal
  void _mostrarModal() {
    final themeModel = Provider.of<ThemeModel>(context, listen: false); // Obtenemos el modelo de tema
    final fontSizeModel = Provider.of<FontSizeModel>(context, listen: false); // Obtenemos el modelo de tamaño de fuente

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: themeModel.primaryButtonColor, // Fondo dinámico
          title: Text(widget.title,
              style: TextStyle(
                fontSize: fontSizeModel.titleSize,
                color: themeModel.primaryTextColor,
              )), // Título del modal
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Picker para la parte entera
                  Container(
                    width: 100,
                    height: 150,
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                        initialItem: enteroSeleccionado, // Selección inicial
                      ),
                      itemExtent: 32,
                      onSelectedItemChanged: (int value) {
                        setState(() {
                          enteroSeleccionado = value; // Actualiza el valor entero
                        });
                        _emitirValorSeleccionado(); // Emitimos el valor seleccionado
                      },
                      children: enteros
                          .map((int value) => Text(value.toString(),
                              style: TextStyle(
                                fontSize: fontSizeModel.textSize,
                                color: themeModel.secondaryTextColor,
                              )))
                          .toList(),
                      selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
                        background: themeModel.secondaryButtonColor.withOpacity(0.5), // Cambia el color aquí
                      ),
                    ),
                  ),
                  // Picker para la parte decimal
                  Container(
                    width: 70,
                    height: 150,
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                        initialItem: decimalSeleccionado, // Selección inicial
                      ),
                      itemExtent: 32,
                      onSelectedItemChanged: (int value) {
                        setState(() {
                          decimalSeleccionado = value; // Actualiza el valor decimal
                        });
                        _emitirValorSeleccionado(); // Emitimos el valor seleccionado
                      },
                      children: decimales
                          .map((int value) => Text(value.toString(),
                              style: TextStyle(
                                fontSize: fontSizeModel.textSize,
                                color: themeModel.secondaryTextColor,
                              )))
                          .toList(),
                      selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
                        background: themeModel.secondaryButtonColor.withOpacity(0.5), // Cambia el color aquí
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity, // Ocupa todo el ancho disponible
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar el modal
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: themeModel.primaryIconColor // Cambia el color del botón aquí
                  ),
                  child: Text('Seleccionar',
                      style: TextStyle(
                          fontSize: 16,
                          color: themeModel.secondaryTextColor)), // Botón para seleccionar
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Emitimos el valor seleccionado
  void _emitirValorSeleccionado() {
    // Emitimos el valor seleccionado (altura o peso)
    widget.onValueSelected(
      enteroSeleccionado + decimalSeleccionado / 10.0, // Combina entero y decimal
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context); // Obtenemos el modelo de tema

    return GestureDetector(
      onTap: _mostrarModal, // Abrir el modal al hacer clic
      child: TextFormField(
        readOnly: true, // Hace que el campo sea de solo lectura
        onTap: _mostrarModal, // Abre el modal al hacer clic
        decoration: InputDecoration(
          labelText: '', // Etiqueta del campo
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: themeModel.secondaryButtonColor.withOpacity(0.5),
              width: 4.0,
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: themeModel.primaryButtonColor,
              width: 2.0,
            ),
          ),
        ),
        style: TextStyle(fontSize: 16), // Estilo del texto del campo
        controller: TextEditingController(
          text: '${enteros[enteroSeleccionado]}.${decimalSeleccionado}', // Mostrar la selección
        ),
      ),
    );
  }
}
