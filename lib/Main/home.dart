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
import './ExitTest/exit_test_screen.dart';
import 'package:fnlapp/Util/enums.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NivelEstres nivelEstres = NivelEstres.desconocido;
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
      int elapsedDays = DateTime.now()
          .difference(DateTime.fromMillisecondsSinceEpoch(startDate))
          .inDays;
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
              showExitTest:
                  showExitTest, // Pasa el estado de showExitTest al CustomNavigationBar
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
        // Obtener el nivel de estrés
        final responseNivel = await http.get(
          Uri.parse('${Config.apiUrl}/userestresessions/$userId/nivel'),
        );

        if (responseNivel.statusCode == 200) {
          final responseData = jsonDecode(responseNivel.body);
          int estresNivelId = responseData['estres_nivel_id'];

          print(
              'Nivel de estrés obtenido: $estresNivelId'); // Verifica que los datos se obtienen

          setState(() {
            nivelEstres = _mapNivelEstres(estresNivelId);
          });
        } else {
          setState(() {
            // nivelEstres = "Error al obtener el nivel de estrés";
            nivelEstres = NivelEstres.desconocido;
          });
          return;
        }

        // Intentar obtener los programas con reintentos
        while (retryCount < maxRetries) {
          final responseProgramas = await http.post(
            Uri.parse(
                '${Config.apiUrl}/userprograma/getprogramcompleto/$userId'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({'user_id': userId}),
          );

          if (responseProgramas.statusCode == 200) {
            final responseData = jsonDecode(responseProgramas.body);
            final List<dynamic> programasData = responseData[
                'userProgramas']; // Accede a la clave 'userProgramas'

            print(
                'Programas obtenidos: $programasData'); // Verifica los datos recibidos

            setState(() {
              programas = programasData;
              isLoading = false;
            });
            break; // Salir del ciclo si la solicitud fue exitosa
          } else {
            retryCount++;
            print('Intento ${retryCount}: Error en la obtención de programas');
            await Future.delayed(Duration(seconds: waitTime));
            waitTime *= 2; // Incrementa el tiempo de espera
          }
        }

        // Si no se obtuvieron programas después de los intentos
        if (retryCount == maxRetries) {
          setState(() {
            // nivelEstres = "No se encontraron programas después de varios intentos";
            nivelEstres = NivelEstres.desconocido;
            isLoading = false;
          });
        }
      } else {
        setState(() {
          // nivelEstres = "Usuario no encontrado";
          nivelEstres = NivelEstres.desconocido;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        // nivelEstres = "Error al cargar";
        nivelEstres = NivelEstres.desconocido;
        isLoading = false;
      });
      print("Error al obtener los programas: $e");
    }
  }

  NivelEstres _mapNivelEstres(int nivelId) {
    switch (nivelId) {
      case 1:
        return NivelEstres.leve;
      case 2:
        return NivelEstres.moderado;
      case 3:
        return NivelEstres.severo;
      default:
        return NivelEstres.desconocido;
    }
  }
}
