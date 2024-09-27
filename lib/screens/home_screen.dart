import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/theme_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos los colores del modelo de tema usando Provider
    final themeModel = Provider.of<ThemeModel>(context);

    return Scaffold(
      backgroundColor: themeModel.backgroundColor, // Fondo dinámico
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Pantalla Principal',
              style: TextStyle(
                fontSize: 24,
                color: themeModel.primaryTextColor, // Texto dinámico
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: themeModel.primaryButtonColor, // Botón dinámico
              ),
              onPressed: () {},
              child: Text(
                'Presiona aquí',
                style: TextStyle(color: themeModel.secondaryTextColor), // Texto del botón dinámico
              ),
            ),
          ],
        ),
      ),
    );
  }
}
