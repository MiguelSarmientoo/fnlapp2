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
    // Obtener el tamaño de la pantalla
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFFF7F2FA),
      appBar: AppBar(
        backgroundColor: Color(0xFF5027D0),
        title: Text(
          'Perfil',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 3,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04), // Espaciado flexible
          child: profileData == null
              ? const CircularProgressIndicator()
              : SingleChildScrollView(
                  child: _buildProfileInfo(screenWidth),
                ),
        ),
      ),
    );
  }

  Widget _buildProfileInfo(double screenWidth) {
    return Container(
      constraints: BoxConstraints(maxWidth: screenWidth * 0.85), // Porcentaje del ancho de pantalla
      padding: EdgeInsets.all(screenWidth * 0.05), // Espaciado flexible
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5027D0), Color(0xFF9F8CFD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildProfileImage(),
          const SizedBox(height: 20),
          _buildProfileDetails(),
          const SizedBox(height: 20),
          _buildAdditionalInfo(),
          const Divider(
            height: 40,
            thickness: 1.5,
            color: Colors.white70,
          ),
          const SizedBox(height: 20),
          _buildLogoutButton(),
          const SizedBox(height: 10),
          Text(
            'Versión 1.0.0',
            style: GoogleFonts.poppins(
              fontSize: 13.0,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return CircleAvatar(
      radius: 70,
      backgroundColor: Colors.white,
      backgroundImage: profileData?.profileImage != null
          ? NetworkImage(profileData!.profileImage!)
          : null,
      child: profileData?.profileImage == null
          ? const Icon(
              Icons.account_circle,
              size: 80,
              color: Color(0xFF5027D0),
            )
          : null,
    );
  }

  Widget _buildProfileDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          profileData?.email ?? 'Cargando...',
          style: GoogleFonts.poppins(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          profileData?.email ?? 'Nombre no disponible',
          style: GoogleFonts.poppins(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Correo:', profileData?.email ?? 'No disponible'),
        const SizedBox(height: 10),
        _buildInfoRow('Nivel jerárquico:', profileData?.hierarchicalLevel ?? 'No disponible'),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
            color: Colors.white70,
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: GoogleFonts.poppins(
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return ElevatedButton(
      onPressed: () => onLogout(),
      child: Text(
        'Cerrar sesión',
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF5027D0),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 8,
        shadowColor: Colors.grey.withOpacity(0.3),
      ),
    );
  }
}
