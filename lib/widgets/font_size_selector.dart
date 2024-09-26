import 'package:flutter/material.dart';

class FontSizeSelector extends StatelessWidget {
  final String label;
  final double currentSize;
  final double min; // Tamaño mínimo
  final double max; // Tamaño máximo
  final ValueChanged<double> onSizeChanged;

  const FontSizeSelector({
    Key? key,
    required this.label,
    required this.currentSize,
    required this.min,
    required this.max,
    required this.onSizeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        Slider(
          value: currentSize,
          min: min, // Utilizar el tamaño mínimo proporcionado
          max: max, // Utilizar el tamaño máximo proporcionado
          divisions: (max - min).toInt(), // Divisiones basadas en rango
          label: currentSize.toString(),
          onChanged: onSizeChanged,
        ),
      ],
    );
  }
}
