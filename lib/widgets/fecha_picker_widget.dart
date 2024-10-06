import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ADAM/models/theme_model.dart'; // Importamos el modelo de tema
import 'package:provider/provider.dart';
import 'package:ADAM/models/font_size_model.dart';

class FechaNacimientoPicker extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const FechaNacimientoPicker(
      {Key? key, required this.onDateSelected, required Color selectedColor})
      : super(key: key);

  @override
  _FechaNacimientoPickerState createState() => _FechaNacimientoPickerState();
}

class _FechaNacimientoPickerState extends State<FechaNacimientoPicker> {
  // Valores iniciales tomados de la fecha actual
  DateTime fechaActual = DateTime.now();
  int diaSeleccionado = DateTime.now().day;
  int mesSeleccionado = DateTime.now().month;
  int anioSeleccionado = DateTime.now().year;

  final List<int> dias = List.generate(31, (index) => index + 1);
  final List<int> meses = List.generate(12, (index) => index + 1);
  final List<int> anios = List.generate(100, (index) => DateTime.now().year - index); // Años, del actual hacia atrás

  // Método para abrir el modal
  void _mostrarModal() {
    final themeModel = Provider.of<ThemeModel>(context,
        listen: false); // Obtenemos el modelo de tema
    final fontSizeModel = Provider.of<FontSizeModel>(context,
        listen: false); // Obtenemos el modelo de tamaño de fuente

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: themeModel.primaryButtonColor,
          title: Text('Fecha de Nacimiento',
              style: TextStyle(
                  fontSize: fontSizeModel.titleSize,
                  color: themeModel.primaryTextColor)), // Título del modal
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Picker para el día
                  Container(
                    width: 70,
                    height: 150,
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                        initialItem: dias.indexOf(
                            diaSeleccionado), // Selecciona el día actual
                      ),
                      itemExtent: 32,
                      onSelectedItemChanged: (int value) {
                        setState(() {
                          diaSeleccionado = dias[value];
                        });
                        _emitirFechaSeleccionada();
                      },
                      children: dias
                          .map((int value) => Text(value.toString(),
                              style: TextStyle(
                                  fontSize: fontSizeModel.textSize,
                                  color: themeModel.secondaryTextColor)))
                          .toList(),
                      selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
                        background: themeModel.secondaryButtonColor
                            .withOpacity(0.5), // Cambia el color aquí
                      ),
                    ),
                  ),
                  // Picker para el mes
                  Container(
                    width: 70,
                    height: 150,
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                        initialItem: meses.indexOf(
                            mesSeleccionado), // Selecciona el mes actual
                      ),
                      itemExtent: 32,
                      onSelectedItemChanged: (int value) {
                        setState(() {
                          mesSeleccionado = meses[value];
                          _ajustarDiasSegunMes();
                        });
                        _emitirFechaSeleccionada();
                      },
                      children: meses
                          .map((int value) => Text(value.toString(),
                              style: TextStyle(
                                  fontSize: fontSizeModel.textSize,
                                  color: themeModel.secondaryTextColor)))
                          .toList(),
                      selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
                        background: themeModel.secondaryButtonColor
                            .withOpacity(0.5), // Cambia el color aquí
                      ),
                    ),
                  ),
                  // Picker para el año
                  Container(
                    width: 100,
                    height: 150,
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                        initialItem: anios.indexOf(
                            anioSeleccionado), // Selecciona el año actual
                      ),
                      itemExtent: 32,
                      onSelectedItemChanged: (int value) {
                        setState(() {
                          anioSeleccionado = anios[value];
                          _ajustarDiasSegunMes();
                        });
                        _emitirFechaSeleccionada();
                      },
                      children: anios
                          .map((int value) => Text(value.toString(),
                              style: TextStyle(
                                  fontSize: fontSizeModel.textSize,
                                  color: themeModel.secondaryTextColor)))
                          .toList(),
                      selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
                        background: themeModel.secondaryButtonColor
                            .withOpacity(0.5), // Cambia el color aquí
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
                      backgroundColor: themeModel
                          .primaryIconColor // Cambia el color del botón aquí
                      ),
                  child: Text('Seleccionar',
                      style: TextStyle(
                          fontSize: 16,
                          color: themeModel
                              .secondaryTextColor)), // Botón para seleccionar
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _mostrarModal, // Abrir el modal al hacer clic
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Provider.of<ThemeModel>(context).primaryButtonColor, // Color del borde
              width: 2.0,
            ),
          ),
        ),
        child: Text(
          '${diaSeleccionado}/${mesSeleccionado}/${anioSeleccionado}', // Mostrar la selección
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  // Ajustamos los días según el mes y si el año es bisiesto
  void _ajustarDiasSegunMes() {
    int diasEnMes = _obtenerDiasDelMes(mesSeleccionado, anioSeleccionado);
    setState(() {
      if (diaSeleccionado > diasEnMes) {
        diaSeleccionado = diasEnMes;
      }
    });
  }

  // Obtenemos el número de días en el mes
  int _obtenerDiasDelMes(int mes, int anio) {
    if (mes == 2) {
      return (anio % 4 == 0 && (anio % 100 != 0 || anio % 400 == 0)) ? 29 : 28;
    }
    return [4, 6, 9, 11].contains(mes) ? 30 : 31;
  }

  // Emitimos la fecha seleccionada
  void _emitirFechaSeleccionada() {
    widget.onDateSelected(
        DateTime(anioSeleccionado, mesSeleccionado, diaSeleccionado));
  }
}
