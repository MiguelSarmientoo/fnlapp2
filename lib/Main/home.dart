import 'package:flutter/material.dart';
import 'package:fnlapp/Login/login.dart';
import 'package:fnlapp/Main/profile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fnlapp/Funcy/screens/splash_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './models/profile_data.dart';
import '../config.dart';
import '../Main/widgets/custom_navigation_bar.dart';
import 'plan.dart';
import './widgets/chat_widget.dart';
import 'mitest.dart';
import './ExitTest/exit_test_screen.dart'; // Importa la pantalla del Test de Salida

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String nivelEstres = "Cargando...";
  List<dynamic> programas = [];
  bool isLoading = true;
  int _selectedIndex = 0;
  bool isChatOpen = false;
  bool showExitTest = false;
  int? userId;
  String? username;
  int? funcyInteract;
  ProfileData? profileData;

  @override
  void initState() {
    super.initState();
    _checkExitTest();
    obtenerNivelEstresYProgramas();
    loadProfile();
  }

  Future<void> _checkExitTest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? startDate = prefs.getInt('startDate');

    if (startDate == null) {
      prefs.setInt('startDate', DateTime.now().millisecondsSinceEpoch);
    } else {
      int elapsedDays = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(startDate)).inDays;
      if (elapsedDays >= 21) {
        setState(() {
          showExitTest = true;
        });
      }
    }
  }

  Future<void> loadProfile() async {
    profileData = await fetchProfile();
    setState(() {});
  }

  Future<ProfileData?> fetchProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userId = prefs.getInt('userId');

      if (userId == null) {
        print('Error: userId is null');
        return null;
      }

      String url = '${Config.apiUrl}/perfilUsuario/$userId';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return ProfileData.fromJson(json.decode(response.body));
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      isChatOpen = index == 1;
    });
  }

  Widget _getSelectedWidget() {
    switch (_selectedIndex) {
      case 0:
        return PlanScreen(
          nivelEstres: nivelEstres,
          isLoading: isLoading,
          programas: programas,
        );
      case 1:
        return ChatWidget(
          userId: userId ?? 1,
          username: username ?? 'Usuario',
          onChatToggle: (isOpen) {
            setState(() {
              isChatOpen = isOpen;
            });
          },
        );
      case 2:
        return MiTestScreen(nivelEstres: nivelEstres);
      case 3:
        return ProfileScreen(
          profileData: profileData,
          onLogout: _handleLogout,
        );
      case 4:
        if (showExitTest) {
          return ExitTestScreen(); // Pantalla para el Test de Salida
        }
        return PlanScreen(
          nivelEstres: nivelEstres,
          isLoading: isLoading,
          programas: programas,
        );
      default:
        return PlanScreen(
          nivelEstres: nivelEstres,
          isLoading: isLoading,
          programas: programas,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 237, 221, 255),
      body: Stack(
        children: [
          _getSelectedWidget(),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomNavigationBar(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
              showExitTest: showExitTest, // Pasa el estado de showExitTest al CustomNavigationBar
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  Future<void> obtenerNivelEstresYProgramas() async {
    int maxRetries = 8;
    int retryCount = 0;
    int waitTime = 1;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userId = prefs.getInt('userId');
      username = prefs.getString('username');

      if (userId != null) {
        final responseNivel = await http.get(
          Uri.parse('http://localhost:3000/api/userestresessions/$userId/nivel'),
        );

        if (responseNivel.statusCode == 200) {
          final responseData = jsonDecode(responseNivel.body);
          int estresNivelId = responseData['estres_nivel_id'];

          setState(() {
            nivelEstres = _mapNivelEstres(estresNivelId);
          });

          while (retryCount < maxRetries) {
            final responseProgramas = await http.post(
              Uri.parse('http://localhost:3000/api/userprograma/getprogramcompleto/$userId'),
              headers: {"Content-Type": "application/json"},
              body: jsonEncode({'user_id': userId}),
            );

            if (responseProgramas.statusCode == 200) {
              final List<dynamic> programasData = jsonDecode(responseProgramas.body);
              setState(() {
                programas = programasData;
                isLoading = false;
              });
              break;
            } else {
              retryCount++;
              await Future.delayed(Duration(seconds: waitTime));
              waitTime *= 2;
            }
          }

          if (retryCount == maxRetries) {
            setState(() {
              nivelEstres = "No se encontraron programas después de varios intentos";
              isLoading = false;
            });
          }
        } else {
          setState(() {
            nivelEstres = "Error al obtener el nivel de estrés";
            isLoading = false;
          });
        }
      } else {
        setState(() {
          nivelEstres = "Usuario no encontrado";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        nivelEstres = "Error al cargar";
        isLoading = false;
      });
      print("Error al obtener los programas: $e");
    }
  }

  String _mapNivelEstres(int nivelId) {
    switch (nivelId) {
      case 1:
        return "LEVE";
      case 2:
        return "MODERADO";
      case 3:
        return "ALTO";
      default:
        return "DESCONOCIDO";
    }
  }
}
