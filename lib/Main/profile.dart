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
      constraints: BoxConstraints(
        maxWidth: 400,
      ),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 6,
            offset: Offset(0, 3),
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
                    size: 50,
                    color: Color(0xFF5027D0),
                  )
                : null,
          ),
          SizedBox(height: 15),
          _buildProfileDetails(),
          SizedBox(height: 20),
          _buildLogoutButton(),
          SizedBox(height: 8),
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
        backgroundColor: Color(0xFF5027D0),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 4,
      ),
    );
  }
}
