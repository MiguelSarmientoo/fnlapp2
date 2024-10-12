/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fnlapp/Login/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Util/api_service.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String userId;

  @override
  void initState() {
    super.initState();
  }

  // Función para manejar el cierre de sesión
  Future<void> _handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs
        .clear(); // Elimina todos los datos guardados en las preferencias
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              LoginScreen()), // Redirige a la pantalla de inicio de sesión
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Color.fromRGBO(240, 218, 250, 1), // Color de fondo de la pantalla
      body: profileData.isEmpty
          ? Center(
              child:
                  CircularProgressIndicator()) // Muestra un indicador de carga si no hay datos
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 40), // Espacio superior
                  _buildProfileCard(),
                  Spacer(), // Llena el espacio restante
                  _buildLogoutButton(),
                  SizedBox(height: 10), // Espacio entre el botón y la versión
                  Text(
                    'Versión del Proyecto: 1.0.0', // Información de la versión del proyecto
                    style: GoogleFonts.poppins(
                      fontSize: 12.0,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // Función que construye la tarjeta de perfil
  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      height: 220, // Altura del contenedor
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white, // Color de fondo del contenedor
        borderRadius:
            BorderRadius.circular(12.0), // Bordes redondeados opcionales
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // Sombra ligera
            spreadRadius: 2,
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 50, // Radio del avatar
            backgroundColor: Colors.grey[200], // Color de fondo del avatar
            child: Icon(
              Icons.account_circle, // Ícono dentro del avatar
              size: 50, // Tamaño del ícono
              color: Color(0xFF5027D0), // Color del ícono
            ),
          ),
          SizedBox(width: 15), // Espacio entre el avatar y el texto
          _buildProfileInfo(),
        ],
      ),
    );
  }

  // Función que construye la información del perfil
  Widget _buildProfileInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          profileData[0].email, // Nombre del usuario
          style: GoogleFonts.poppins(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          profileData[0].responsabilitylevel, // Nivel del usuario
          style: GoogleFonts.poppins(
            fontSize: 14.0,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // Función que construye el botón de cerrar sesión
  Widget _buildLogoutButton() {
    return ElevatedButton(
      onPressed: _handleLogout, // Maneja el evento de cierre de sesión
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF5027D0), // Color de fondo del botón
      ),
      child: Text(
        'Cerrar sesión', // Texto del botón
        style: GoogleFonts.poppins(
          fontSize: 16.0,
          color: Colors.white,
        ),
      ),
    );
  }
}
*/