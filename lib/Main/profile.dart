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
      backgroundColor: Color(0xFFF7F2FA), // Color de fondo suave
      appBar: AppBar(
        backgroundColor: Color(0xFF5027D0),
        title: Text(
          'Perfil',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: profileData == null
              ? CircularProgressIndicator()
              : SingleChildScrollView(
                  child: _buildProfileInfo(),
                ),
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Container(
      constraints: BoxConstraints(maxWidth: 400),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[200],
            backgroundImage: profileData?.profileImage != null
                ? NetworkImage(profileData!.profileImage!)
                : null,
            child: profileData?.profileImage == null
                ? Icon(
                    Icons.account_circle,
                    size: 60,
                    color: Color(0xFF5027D0),
                  )
                : null,
          ),
          SizedBox(height: 20),
          _buildProfileDetails(),
          Divider(
            height: 30,
            thickness: 1,
            color: Colors.grey[300],
          ),
          _buildAdditionalInfo(),
          SizedBox(height: 20),
          _buildLogoutButton(),
          SizedBox(height: 12),
          Text(
            'Versión: 1.0.0',
            style: GoogleFonts.poppins(
              fontSize: 12.0,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          profileData?.email ?? '',
          style: GoogleFonts.poppins(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF5027D0),
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _buildAdditionalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Correo:',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
                color: Colors.grey[700],
              ),
            ),
            Text(
              profileData?.email ?? 'No disponible',
              style: GoogleFonts.poppins(
                fontSize: 16.0,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Nivel jerárquico:',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
                color: Colors.grey[700],
              ),
            ),
            Text(
              profileData?.hierarchicalLevel ?? 'No disponible',
              style: GoogleFonts.poppins(
                fontSize: 16.0,
                color: Colors.grey[800],
              ),
            ),
          ],
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
        backgroundColor: Color(0xFF5027D0),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 6,
      ),
    );
  }
}
