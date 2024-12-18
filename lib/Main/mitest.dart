import 'package:flutter/material.dart';

class MiTestScreen extends StatelessWidget {
  final String nivelEstres;

  MiTestScreen({required this.nivelEstres});

  @override
  Widget build(BuildContext context) {
    // Determinar la ruta de la imagen en función del nivel de estrés
    String imageUrl;
    switch (nivelEstres.toUpperCase()) {
      case 'LEVE':
        imageUrl = 'https://funkyrecursos.s3.us-east-2.amazonaws.com/assets/leve2.png';
        break;
      case 'MODERADO':
        imageUrl = 'https://funkyrecursos.s3.us-east-2.amazonaws.com/assets/moderado2.png';
        break;
      case 'SEVERO':
        imageUrl = 'https://funkyrecursos.s3.us-east-2.amazonaws.com/assets/severo2.png';
        break;
      default:
        imageUrl = 'https://funkyrecursos.s3.us-east-2.amazonaws.com/assets/fondoFNL.jpg';
    }

    return Scaffold(
      body: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      ),
    );
  }
}
