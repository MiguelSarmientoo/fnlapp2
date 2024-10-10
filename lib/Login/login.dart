import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool passwordVisible = false;

  Future<void> _login(BuildContext context) async {
    final username = emailController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, ingrese todos los campos')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/login'), // Cambia a tu URL de servidor
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final token = responseBody['token'];
        final username = responseBody['username'];
        final userId = responseBody['userId'];
        final email = responseBody['email'];
        final permisopoliticas = responseBody['permisopoliticas'];
        print("permisopoliticas $permisopoliticas");

        if (token != null && username != null && userId != null && email != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await prefs.setString('username', username);
          await prefs.setInt('userId', userId);
          await prefs.setString('email', email);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login exitoso')),
          );

          if (permisopoliticas == false) {
            Navigator.pushReplacementNamed(context, '/index');
          } else if (permisopoliticas == true) {
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Valor de permisopoliticas no esperado')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Datos de autenticación no recibidos')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error en el servidor: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/login.png', fit: BoxFit.cover),
          ),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Image.asset('assets/logo.png', width: 250.0),
                  ),
                  _buildTextField(Icons.person, 'Usuario', emailController),
                  SizedBox(height: 16.0),
                  _buildTextField(Icons.lock, 'Contraseña', passwordController, obscureText: true),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _login(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 61, 23, 126),  // Establece el color de fondo
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),  // Ajusta el padding del botón si es necesario
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),  // Opción para bordes redondeados
                      ),
                    ),
                    child: Text(
                      'Iniciar Sesión',
                      style: TextStyle(color: Colors.white),  // Color del texto
                    ),
                  )

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(IconData icon, String hintText, TextEditingController controller, {bool obscureText = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[700]),
          SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
              ),
              obscureText: obscureText && !passwordVisible,  // Controla si el texto es visible u oculto
            ),
          ),
          // Mostrar el ícono solo si es un campo de contraseña (obscureText = true)
          if (obscureText)
            IconButton(
              icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  passwordVisible = !passwordVisible;  // Cambia el estado de visibilidad
                });
              },
            ),
        ],
      ),
    );
  }
}
