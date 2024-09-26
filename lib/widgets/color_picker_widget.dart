import 'package:flutter/material.dart';

class ColorPickerWidget extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorChanged;

  const ColorPickerWidget({
    Key? key,
    required this.selectedColor,
    required this.onColorChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildColorCircle(Colors.white),
          _buildColorCircle(Colors.black),
          _buildColorCircle(Colors.blue),
          _buildColorCircle(Colors.red),
          _buildColorCircle(Colors.green),
          _buildColorCircle(Colors.yellow),
          _buildColorCircle(Colors.orange),
        ],
      ),
    );
  }

  // Widget para mostrar un círculo de color
  Widget _buildColorCircle(Color color) {
    return GestureDetector(
      onTap: () => onColorChanged(color), // Cambia el color seleccionado
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(
            color: selectedColor == color ? Colors.black : Colors.transparent,
            width: 3,
          ),
        ),
      ),
    );
  }
}
