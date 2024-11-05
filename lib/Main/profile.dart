import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/profile_data.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileData? profileData;
  final Function onLogout;

  ProfileScreen({
    required this.profileData,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(240, 218, 250, 1),
      body: Center( // Centrar el contenido en toda la pantalla
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: profileData == null
              ? CircularProgressIndicator()
              : _buildProfileInfo(),
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 300, // Altura máxima ajustada
        maxWidth: 400, // Ancho máximo ajustado
      ),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white, // Fondo blanco
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3), // Sombras suaves
            spreadRadius: 3,
            blurRadius: 6,
            offset: Offset(0, 3), // Desplazamiento de la sombra
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Alinear al centro
        mainAxisSize: MainAxisSize.min, // Ajustar el tamaño vertical
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[200],
            child: Icon(
              Icons.account_circle,
              size: 50,
              color: Color(0xFF5027D0), // Color del ícono
            ),
          ),
          SizedBox(height: 15),
          _buildProfileDetails(),
          SizedBox(height: 20),
          _buildLogoutButton(),
          SizedBox(height: 8), // Espaciado ajustado
          Text(
            'Versión: 1.0.0',
            style: GoogleFonts.poppins(
              fontSize: 12.0, // Tamaño de fuente reducido
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, // Alinear al centro
      children: [
        Text(
          profileData?.email ?? '',
          style: GoogleFonts.poppins(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF5027D0), // Color del texto en morado
          ),
        ),
        Text(
          profileData?.hierarchicalLevel ?? '',
          style: GoogleFonts.poppins(
            fontSize: 16.0,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return ElevatedButton(
      onPressed: () => onLogout(),
      child: Text('Cerrar sesión'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF5027D0), // Color morado
        foregroundColor: Colors.white, // Color del texto
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16), // Mejor padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 4, // Sombra del botón
      ),
    );
  }
}
