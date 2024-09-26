import 'package:flutter/material.dart';

class ThemeModel with ChangeNotifier {
  // Colores predeterminados
  Color _backgroundColor = Colors.white;
  Color _buttonColor = Colors.blue;
  Color _textColor = Colors.black;

  // Getters para los colores
  Color get backgroundColor => _backgroundColor;
  Color get buttonColor => _buttonColor;
  Color get textColor => _textColor;

  // Setters que permiten cambiar los colores y notifican a los widgets
  void setBackgroundColor(Color color) {
    _backgroundColor = color;
    notifyListeners(); // Notifica a todos los listeners para que se actualicen
  }

  void setButtonColor(Color color) {
    _buttonColor = color;
    notifyListeners();
  }

  void setTextColor(Color color) {
    _textColor = color;
    notifyListeners();
  }

  // Método para restablecer los valores predeterminados
  void resetToDefaults() {
    _backgroundColor = Colors.white;
    _buttonColor = Colors.blue;
    _textColor = Colors.black;
    notifyListeners();
  }
}
