import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart'; // Importa el archivo de configuración
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> passwordVisible = ValueNotifier(false);
  final _formKey = GlobalKey<FormState>();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  bool isLoading = false;  // Variable para controlar el estado de carga

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_formKey.currentState == null) {
        print("Form is not initialized yet");
      }
    });
  }

  Future<void> _login(BuildContext context) async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) return;

    final username = emailController.text.trim();
    final password = passwordController.text.trim();

    setState(() {
      isLoading = true;  // Activar el indicador de carga
    });

    try {
      final response = await http.post(
        Uri.parse('${Config.apiUrl}/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      setState(() {
        isLoading = false;  // Desactivar el indicador de carga
      });

      if (response.statusCode == 200) {
        await _handleLoginResponse(context, response);
      } else if (response.statusCode == 401) {
        _showSnackBar(context, 'Credenciales Invalidas');
      } else if (response.statusCode == 403) {
        _showSnackBar(context, 'Usuario sin un rol');
      } else {
        _showSnackBar(context, 'Error desconocido: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;  // Desactivar el indicador de carga en caso de error
      });
      print(e);
      _showSnackBar(context, 'Error: Intentar nuevamente o Contactar al soporte');
    }
  }

  Future<void> _handleLoginResponse(BuildContext context, http.Response response) async {
    final responseBody = jsonDecode(response.body);
    final token = responseBody['token'];
    final username = responseBody['username'];
    final userId = responseBody['userId'];
    final email = responseBody['email'];
    final role = responseBody['role'];

    if (role == 'User') {
      if (token != null && username != null && userId != null && email != null) {
        await _saveUserData(token, username, userId, email);


        await _fetchAndSavePermissions(userId);


        _navigateBasedOnPermission(context);
      } else {
        _showSnackBar(context, 'Datos de autenticación no recibidos');
      }
    } else {
      _showSnackBar(context, 'Usuario no autorizado');
    }
  }

    Future<void> _fetchAndSavePermissions(int userId) async {
      try {
        final response = await http.get(
          Uri.parse('${Config.apiUrl}/users/getpermisos/$userId'),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          // Verificar si la clave 'permisos' existe y no es nula
          final permisos = data['permisos'];
          
          if (permisos != null) {
            // Verificar que las claves dentro de 'permisos' no sean nulas
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool('permisopoliticas', permisos['permisopoliticas'] ?? false);
            await prefs.setBool('userresponsebool', permisos['userresponsebool'] ?? false);
            await prefs.setBool('testestresbool', permisos['testestresbool'] ?? false);

            print('Permisos guardados: $permisos');
          } else {
            print('Error: No se encontraron permisos en la respuesta.');
          }
        } else {
          print('Error en la solicitud: ${response.statusCode}');
        }
      } catch (e) {
        print('Error obteniendo permisos: $e');
      }
    }

  Future<void> _saveUserData(String token, String username, int userId, String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('token', token);
    await prefs.setString('username', username);
    await prefs.setInt('userId', userId);
    await prefs.setString('email', email);

    print("TOKEN GUARDADO en SharedPreferences: $token");
  }

  void _navigateBasedOnPermission(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/');
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://funkyrecursos.s3.us-east-2.amazonaws.com/assets/login.png', // Cargar imagen desde la URL
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 400),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 32.0),
                        child: Image.network('https://funkyrecursos.s3.us-east-2.amazonaws.com/assets/logo.png', width: 200.0),
                      ),
                      _buildTextField(Icons.person, 'Usuario', emailController),
                      SizedBox(height: 12.0),
                      _buildTextField(Icons.lock, 'Contraseña', passwordController, obscureText: true),
                      SizedBox(height: 32),
                      isLoading
                          ? Center(child: CircularProgressIndicator())
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => _login(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromARGB(255, 61, 23, 126),
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  elevation: 4,
                                ),
                                child: Text(
                                  'Iniciar Sesión',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
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
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[700]),
          SizedBox(width: 10),
          Expanded(
            child: ValueListenableBuilder<bool>(
              valueListenable: passwordVisible,
              builder: (context, value, child) {
                return TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
                  ),
                  obscureText: obscureText && !value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo es requerido';
                    }
                    return null;
                  },
                );
              },
            ),
          ),
          if (obscureText)
            ValueListenableBuilder<bool>(
              valueListenable: passwordVisible,
              builder: (context, value, child) {
                return IconButton(
                  icon: Icon(value ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => passwordVisible.value = !value,
                );
              },
            ),
        ],
      ),
    );
  }
}
