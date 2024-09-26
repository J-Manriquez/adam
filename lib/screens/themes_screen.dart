import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/theme_model.dart';
import '../models/font_size_model.dart'; // Asegúrate de importar el modelo de tamaño de fuente
import '../widgets/color_picker_widget.dart';

class ThemesScreen extends StatelessWidget {
  const ThemesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    final fontSizeModel = Provider.of<FontSizeModel>(context); // Obtenemos el modelo de tamaño de fuente

    return Scaffold(
      appBar: AppBar(
        leading: Container(
          alignment: Alignment.center,
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            iconSize: fontSizeModel.iconSize, // Tamaño dinámico del ícono
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                'Seleccionar Tema',
                style: TextStyle(
                  fontSize: fontSizeModel.titleSize, // Tamaño dinámico del título
                  color: themeModel.textColor, // Color dinámico del texto
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        backgroundColor: themeModel.buttonColor, // Color dinámico del AppBar
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: themeModel.backgroundColor, // Fondo dinámico
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                themeModel.resetToDefaults(); // Restablecer colores
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: themeModel.buttonColor, // Color dinámico del botón
                minimumSize: Size(double.infinity, 48), // Ancho completo del botón
              ),
              child: Text(
                'Restablecer a los valores predeterminados',
                style: TextStyle(
                  fontSize: fontSizeModel.textSize, // Tamaño dinámico del texto
                  color: themeModel.textColor, // Color dinámico del texto del botón
                ),
                textAlign: TextAlign.center, // Centrar el texto
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Seleccionar color de fondo:',
              style: TextStyle(
                fontSize: fontSizeModel.textSize, // Tamaño dinámico del texto
                color: themeModel.textColor, // Color dinámico del texto
              ),
            ),
            ColorPickerWidget(
              selectedColor: themeModel.backgroundColor,
              onColorChanged: (newColor) {
                themeModel.setBackgroundColor(newColor); // Actualizar fondo
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Seleccionar color del botón:',
              style: TextStyle(
                fontSize: fontSizeModel.textSize, // Tamaño dinámico del texto
                color: themeModel.textColor, // Color dinámico del texto
              ),
            ),
            ColorPickerWidget(
              selectedColor: themeModel.buttonColor,
              onColorChanged: (newColor) {
                themeModel.setButtonColor(newColor); // Actualizar botón
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Seleccionar color del texto:',
              style: TextStyle(
                fontSize: fontSizeModel.textSize, // Tamaño dinámico del texto
                color: themeModel.textColor, // Color dinámico del texto
              ),
            ),
            ColorPickerWidget(
              selectedColor: themeModel.textColor,
              onColorChanged: (newColor) {
                themeModel.setTextColor(newColor); // Actualizar texto
              },
            ),
          ],
        ),
      ),
    );
  }
}
