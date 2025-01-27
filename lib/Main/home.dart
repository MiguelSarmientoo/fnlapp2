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
import 'package:fnlapp/Main/testestres_form.dart';

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
  bool hasFilledEmotion = false;
  String? token;
  bool isExitTestEnabled = false; // Controla si el botón está habilitado

  

  @override
  void initState() {
    super.initState();
    _checkExitTest();
    obtenerNivelEstresYProgramas();
    loadProfile();
    checkIfEmotionFilledForToday();
  }


Future<void> _checkExitTest() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  userId = prefs.getInt('userId');
  token = prefs.getString('token');

  if (userId == null || token == null) {
    print('Error: userId o token no encontrados');
    return;
  }

  try {
    // Obtener el registro del programa con el activity_id (21)
    final response = await http.get(
      Uri.parse('${Config.apiUrl}/userprograma/$userId/actividad/21'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Obtener la fecha de inicio (start_date)
      final String startDateStr = data['start_date'];
      final DateTime startDate = DateTime.parse(startDateStr);

      // Comparar con la fecha actual (ignorando la hora)
      final DateTime today = DateTime.now();

      setState(() {
        showExitTest = true; // Siempre mostrar el botón
        isExitTestEnabled = (startDate.year == today.year &&
            startDate.month == today.month &&
            startDate.day == today.day); // Habilitar si coinciden las fechas
      });

      if (isExitTestEnabled) {
        print('Botón habilitado: Hoy es el día del registro.');
      } else {
        print('Botón deshabilitado: Hoy no coincide con el start_date.');
      }
    } else {
      print('Error al obtener el programa: ${response.body}');
      setState(() {
        isExitTestEnabled = false;
      });
    }
  } catch (e) {
    print('Error al verificar el programa: $e');
    setState(() {
      isExitTestEnabled = false;
    });
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
      token = prefs.getString('token');

      if (userId == null) {
        print('Error: userId is null');
        return null;
      }

      String url = '${Config.apiUrl}/perfilUsuario/$userId';
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        var profile = ProfileData.fromJson(json.decode(response.body));
        var res = await http
            .get(Uri.parse('${Config.apiUrl}/empresa/${profile.idEmpresa}'));
        profile.nombreEmpresa = json.decode(res.body)['nombre'];
        return profile;
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
    return Container(
      color: Colors.white, // Fondo blanco unificado
      child: Padding(
        padding: const EdgeInsets.only(bottom: 125.0), // Espacio para la barra de navegación
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 95.0, // Altura mínima igual al viewport menos el padding
            ),
            child: IntrinsicHeight( // Permite que el contenido interno se ajuste correctamente
              child: TestEstresQuestionScreen(),
            ),
          ),
        ),
      ),
    );
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
        Positioned.fill(
          child: _getSelectedWidget(),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: CustomNavigationBar(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
            showExitTest: showExitTest,
            isExitTestEnabled: isExitTestEnabled,
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
          Uri.parse('${Config.apiUrl}/userestresessions/$userId/nivel'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (responseNivel.statusCode == 200) {
          final responseData = jsonDecode(responseNivel.body);
          int estresNivelId = responseData['estres_nivel_id'];

          setState(() {
            nivelEstres = _mapNivelEstres(estresNivelId);
          });
        } else {
          setState(() {
            nivelEstres = NivelEstres.desconocido;
          });
        }

        while (retryCount < maxRetries) {
          final responseProgramas = await http.post(
            Uri.parse('${Config.apiUrl}/userprograma/getprogramcompleto/$userId'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({'user_id': userId}),
          );

          if (responseProgramas.statusCode == 200) {
            final responseData = jsonDecode(responseProgramas.body);
            final List<dynamic> programasData = responseData['userProgramas'];

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
            nivelEstres = NivelEstres.desconocido;
            isLoading = false;
          });
        }
      } else {
        setState(() {
          nivelEstres = NivelEstres.desconocido;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        nivelEstres = NivelEstres.desconocido;
        isLoading = false;
      });
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



  Future<void> checkIfEmotionFilledForToday() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userId = prefs.getInt('userId');

      if (userId != null) {
        String fechaHoy = DateTime.now().toIso8601String().split('T')[0];
        final response = await http.get(
          Uri.parse('http://localhost:3000/api/emociones_diarias/$fechaHoy'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          hasFilledEmotion = data['data'].isNotEmpty;
        } else {
          hasFilledEmotion = false;
        }
      }
    } catch (e) {
      hasFilledEmotion = false;
    }

    setState(() {});
  }

  void _showEmotionModal() {
    showDialog(
      context: context,
      builder: (context) {
        return EmotionModal(
          onEmotionRegistered: (emotion, note) {
            setState(() {
              hasFilledEmotion = true;
            });
            _registerEmotion(emotion, note);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  

  Future<void> _registerEmotion(int emotion, String note) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userId = prefs.getInt('userId');

      if (userId != null && token != null) {
        String fechaHoy = DateTime.now().toIso8601String().split('T')[0];
        final response = await http.post(
          Uri.parse('http://localhost:3000/api/emociones_diarias'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'emocion': emotion,
            'notaOpcional': note,
          }),
        );

        if (response.statusCode == 201) {
          print('Emotion registered successfully');
        } else {
          print('Failed to register emotion');
        }
      }
    } catch (e) {
      print('Error registering emotion: $e');
    }
  }
}

class EmotionModal extends StatefulWidget {
  final Function(int emotion, String note) onEmotionRegistered;

  EmotionModal({required this.onEmotionRegistered});

  @override
  _EmotionModalState createState() => _EmotionModalState();
}

class _EmotionModalState extends State<EmotionModal> {
  TextEditingController noteController = TextEditingController();
  int selectedEmotion = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Emotion'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedEmotion = 1;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: selectedEmotion == 1
                        ? Colors.grey.shade300
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.sentiment_very_satisfied,
                    color: Colors.green,
                    size: 40,
                  ),
                ),
              ),
              SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedEmotion = 0;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: selectedEmotion == 0
                        ? Colors.grey.shade300
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.sentiment_neutral,
                    color: Colors.grey,
                    size: 40,
                  ),
                ),
              ),
              SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedEmotion = -1;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: selectedEmotion == -1
                        ? Colors.grey.shade300
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.sentiment_dissatisfied,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          TextField(
            controller: noteController,
            decoration: InputDecoration(hintText: 'Optional note'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onEmotionRegistered(selectedEmotion, noteController.text);
          },
          child: Text('Save'),
        ),
      ],
    );
  }

}