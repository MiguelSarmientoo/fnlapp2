import 'package:fnlapp/config.dart';

class ProfileData {
  final String email;
  final String hierarchicalLevel;
  final String? profileImage;
  final int? idEmpresa;
  String? nombreEmpresa;
  ProfileData(
      {required this.email,
      required this.hierarchicalLevel,
      this.profileImage,
      this.idEmpresa,
      this.nombreEmpresa});

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    // Verifica si el perfil de la imagen es una URL completa o solo una ruta
    String? profileImagePath = json['profileImage'];
    if (profileImagePath != null && !profileImagePath.startsWith('http')) {
      // Construye la URL completa si es necesario (ajusta la URL base a tu entorno)
      profileImagePath =
          Config.imagenesUrl + profileImagePath.replaceAll('\\', '/');
    }

    return ProfileData(
        email: json['email'],
        hierarchicalLevel: json['hierarchicalLevel'].toString(),
        profileImage: profileImagePath,
        idEmpresa: json['id_empresa']);
  }

  @override
  String toString() {
    return 'ProfileData{profileImage: $profileImage, hierarchicalLevel: $hierarchicalLevel, email: $email, id_empresa: $idEmpresa}';
  }
}
