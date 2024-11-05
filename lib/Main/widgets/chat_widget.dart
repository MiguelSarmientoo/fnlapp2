import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fnlapp/Funcy/screens/splash_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fnlapp/SharedPreferences/sharedpreference.dart';

class ChatWidget extends StatelessWidget {
  final int userId;
  final String username;
  final Function(bool) onChatToggle;

  ChatWidget({required this.userId, required this.username, required this.onChatToggle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco para toda la pantalla
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max, // Asegura que ocupe todo el espacio vertical
          mainAxisAlignment: MainAxisAlignment.center, // Centra el contenido verticalmente
          children: [
            _buildLogo(), // Añadir el logo en la parte superior
            SizedBox(height: 20),
            Text(
              'Consejero virtual Funcy',
              style: GoogleFonts.poppins(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 6),
            _buildChatMessage('¡Hola ${username}! 👋🐱'),
            SizedBox(height: 8),
            _buildChatMessage('Soy Funcy y me gustaría saber cómo te encuentras el día de hoy'),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await _startChat(context);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                  child: Text(
                    'Comencemos el chat',
                    style: GoogleFonts.poppins(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF5027D0),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      'assets/logo_funcy_splash.png', // Asegúrate de que la ruta sea correcta
      height: 80, // Ajusta la altura según sea necesario
      fit: BoxFit.contain,
    );
  }

  Widget _buildChatMessage(String message) {
    return Container(
      padding: EdgeInsets.all(5.0),
      margin: EdgeInsets.symmetric(vertical: 2.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 239, 239, 239),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message,
        style: GoogleFonts.poppins(
          fontSize: 13.0,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
      ),
    );
  }

  Future<void> _startChat(BuildContext context) async {
    if (userId != null) {
      await _sendMultipleMessages();
      await _updateFuncyInteract();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SplashScreen(userId: userId)),
      );
    } else {
      print("Error: userId no definido");
    }
  }

  Future<void> _sendMultipleMessages() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('userId');
      String? token = prefs.getString('token');

      if (userId != null && token != null) {
        final response = await http.get(
          Uri.parse('http://localhost:3000/api/datos/users/$userId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          int funcyInteract = responseData['funcyinteract'];

          if (funcyInteract == 1) {
            print('Redirigiendo correctamente a funcy');
            return;
          } else if (funcyInteract == 0) {
            final String comentario1 = '¡Hola ${username}! 👋🐱';
            final String comentario2 = 'Soy Funcy y me gustaría saber cómo te encuentras el día de hoy';

            await _guardarMensaje(comentario1);
            await Future.delayed(Duration(seconds: 1));
            await _guardarMensaje(comentario2);
            print('Los dos mensajes han sido enviados con éxito.');
          }
        } else {
          print('Error al obtener datos del usuario: ${response.statusCode}');
        }
      } else {
        print('Usuario o token no encontrado en SharedPreferences.');
      }
    } catch (e) {
      print('Error al verificar funcyinteract: $e');
    }
  }

  Future<void> _guardarMensaje(String contenido) async {
    try {
      await http.post(
        Uri.parse('http://localhost:3000/api/guardarMensajeFromBot'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'content': contenido,
          'userId': userId,
        }),
      );
    } catch (e) {
      print('Error al guardar mensaje: $e');
    }
  }

  Future<void> _updateFuncyInteract() async {
    try {
      if (userId == null) {
        print('No se encontró el ID del usuario.');
        return;
      }

      String? token = await getToken();

      if (token == null) {
        print('No se encontró el token de autenticación.');
        return;
      }

      final url = 'http://localhost:3000/api/users/$userId';
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'funcyinteract': 1}),
      );

      if (response.statusCode == 200) {
        print('Campo funcyinteract actualizado correctamente.');
        await _sendMultipleMessages();
      } else {
        print('Error al actualizar funcyinteract: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al realizar la actualización: $e');
    }
  }
}
