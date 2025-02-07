import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {

    await Future.delayed(Duration(milliseconds: 500));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null && token.isNotEmpty && _isTokenValid(token)) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      await prefs.remove('token'); // El;imina el token si ha expirado
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  bool _isTokenValid(String token) {
    try {
      final jwt = JWT.decode(token);
      final exp = jwt.payload['exp'] * 1000; // Convertir a milisegundos
      return DateTime.now().millisecondsSinceEpoch < exp;
    } catch (e) {
      return false; // Si hay un error, asumimos que el token no es válido
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity, // Asegura que ocupe todo el ancho
        height: double.infinity, // Asegura que ocupe toda la altura
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://funkyrecursos.s3.us-east-2.amazonaws.com/assets/fondosplash.png'), // URL de la imagen en S3
            fit: BoxFit.cover, // La imagen cubrirá toda la pantalla
          ),
        ),
      ),
    );
  }
}
