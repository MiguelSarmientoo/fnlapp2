import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    // Iniciar un temporizador de 3 segundos antes de navegar al Login
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login'); // Ir al login después del Splash
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity, // Asegura que ocupe todo el ancho
        height: double.infinity, // Asegura que ocupe toda la altura
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondosplash.png'), // Ruta de tu imagen
            fit: BoxFit.cover, // La imagen cubrirá toda la pantalla
          ),
        ),
      ),
    );
  }
}
