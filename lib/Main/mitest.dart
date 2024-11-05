import 'package:flutter/material.dart';

class MiTestScreen extends StatelessWidget {
  final String nivelEstres;

  MiTestScreen({required this.nivelEstres});

  @override
  Widget build(BuildContext context) {
    // Determinar la ruta de la imagen en función del nivel de estrés
    String imagePath;
    switch (nivelEstres.toUpperCase()) {
      case 'LEVE':
        imagePath = 'assets/leve2.png';
        break;
      case 'MODERADO':
        imagePath = 'assets/moderado2.png';
        break;
      case 'SEVERO':
        imagePath = 'assets/severo2.png';
        break;
      default:
        imagePath = 'assets/fondoFNL.png'; 
    }

    return Scaffold(
      body: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      ),
    );
  }
}
