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
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF5027D0),
        title: Text(
          'Perfil',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
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
      constraints: BoxConstraints(maxWidth: screenWidth * 0.85),
      padding: EdgeInsets.all(screenWidth * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
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
            height: 30,
            thickness: 1,
            color: Colors.grey,
          ),
          const SizedBox(height: 20),
          _buildLogoutButton(),
          const SizedBox(height: 10),
          Text(
            'Versión 2.3',
            style: GoogleFonts.roboto(
              fontSize: 12.0,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return CircleAvatar(
      radius: 60,
      backgroundColor: const Color(0xFFEEE8FB),
      backgroundImage: profileData?.profileImage != null
          ? NetworkImage(profileData!.profileImage!)
          : null,
      child: profileData?.profileImage == null
          ? const Icon(
              Icons.person,
              size: 60,
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
          style: GoogleFonts.roboto(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          profileData?.email ?? 'Nombre no disponible',
          style: GoogleFonts.roboto(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
            Icons.email, 'Correo:', profileData?.email ?? 'No disponible'),
        const SizedBox(height: 10),
        _buildInfoRow(Icons.star, 'Nivel jerárquico:',
            profileData?.hierarchicalLevel ?? 'No disponible'),
        const SizedBox(height: 10),
        _buildInfoRow(Icons.business, 'Empresa:',
            profileData?.nombreEmpresa ?? 'No disponible'),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF5027D0), size: 20),
        const SizedBox(width: 10),
        Text(
          label,
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w500,
            fontSize: 14.0,
            color: Colors.black87,
          ),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: GoogleFonts.roboto(
              fontSize: 14.0,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return ElevatedButton.icon(
      onPressed: () => onLogout(),
      icon: const Icon(Icons.logout, size: 18, color: Colors.white),
      label: Text(
        'Cerrar sesión',
        style: GoogleFonts.roboto(fontWeight: FontWeight.w500),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF5027D0),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
