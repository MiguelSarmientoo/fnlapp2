import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fnlapp/Login/login.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import 'package:shared_preferences/shared_preferences.dart'; 
import '../Util/api_service.dart'; 

class ProfileScreen extends StatefulWidget {
  final String username; 
  final ApiService apiServiceWithToken; 

  ProfileScreen({
    required this.username, 
    required this.apiServiceWithToken,
  });

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String username; 
  List<ProfileData> profileData = []; 

  @override
  void initState() {
    super.initState();
    username = widget.username; // Asigna el nombre de usuario del widget a la variable local
    fetchProfile(); // Llama a la función para obtener los datos del perfil
  }

  // Función que obtiene los datos del perfil desde la API
  Future<void> fetchProfile() async {
    try {
      var endpoint = 'v1/profiles/profile'; // Define el endpoint a consultar
      var response = await widget.apiServiceWithToken.get(endpoint);

      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body); // Decodifica la respuesta JSON
        if (data['results'] is List) {
          List<dynamic> results = data['results'];
          List<ProfileData> pd = results.map((item) => ProfileData.fromJson(item)).toList();
          setState(() {
            profileData = pd; // Actualiza el estado con los datos del perfil
          });
        } else {
          print('Error: No se encontró la lista de resultados');
        }
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al cargar los datos del perfil: $e'); // Captura e imprime cualquier error
    }
  }

  // Función para manejar el cierre de sesión
  Future<void> _handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Elimina todos los datos guardados en las preferencias
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()), // Redirige a la pantalla de inicio de sesión
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(240, 218, 250, 1), // Color de fondo de la pantalla
      body: profileData.isEmpty
          ? Center(child: CircularProgressIndicator()) // Muestra un indicador de carga si no hay datos
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
        borderRadius: BorderRadius.circular(12.0), // Bordes redondeados opcionales
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
          profileData[0].firstName, // Nombre del usuario
          style: GoogleFonts.poppins(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          profileData[0].levelName, // Nivel del usuario
          style: GoogleFonts.poppins(
            fontSize: 14.0,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 10), // Espacio entre el nombre/nivel y la información de los días restantes
        Text(
          '${profileData[0].remaining} Días faltantes \n hasta llegar a la meta semanal', // Información de los días restantes
          style: GoogleFonts.poppins(
            fontSize: 12.0,
            color: Colors.grey[600],
          ),
          maxLines: 2,
          overflow: TextOverflow.visible, // Permite que el texto ocupe más de una línea
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

// Clase para modelar los datos del perfil
class ProfileData {
  final int id;
  final String firstName;
  final String companyLogo;
  final double progress;
  final int level;
  final int lastDay;
  final bool completedUser;
  final bool completedCompany;
  final DateTime? lastSession;
  final int remaining;
  final String levelName;

  ProfileData({
    required this.id,
    required this.firstName,
    required this.companyLogo,
    required this.progress,
    required this.level,
    required this.lastDay,
    required this.completedUser,
    required this.completedCompany,
    required this.lastSession,
    required this.remaining,
    required this.levelName,
  });

  // Método de fábrica para crear una instancia de ProfileData desde un JSON
  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['id'],
      firstName: json['first_name'],
      companyLogo: json['company_logo'],
      progress: json['progress'].toDouble(),
      level: json['level'],
      lastDay: json['last_day'],
      completedUser: json['completed_user'],
      completedCompany: json['completed_company'],
      lastSession: json['last_session'] != null ? DateTime.parse(json['last_session']) : null,
      remaining: json['remaining'],
      levelName: json['level_name'],
    );
  }
}
