import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Pantalla Principal',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
