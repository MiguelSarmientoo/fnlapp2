import 'package:flutter/material.dart';
import 'package:fnlapp/Login/login.dart';
import 'package:fnlapp/Main/profile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fnlapp/SharedPreferences/sharedpreference.dart';
import 'package:fnlapp/Funcy/screens/splash_screen.dart';
import 'package:fnlapp/Main/step_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String nivelEstres = "Cargando...";
  List<dynamic> programas = []; // Lista para almacenar los programas de la API
  bool isLoading = true;
  late int remainingDays; // Variable para almacenar los días restantes
  int _selectedIndex = 0;
  bool isChatOpen = false;
  int? userId;
  String? username;
  List<ProfileData> profileDataList = [];
  ProfileData? profileData;
  bool isProfileOpen = false;

  @override
  void initState() {
    super.initState();
    remainingDays = calculateRemainingDays();
    obtenerNivelEstresYProgramas();
    loadProfile();
  }

  Future<void> loadProfile() async {
    profileData = await fetchProfile();
    setState(() {});
  }

  Future<ProfileData?> fetchProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');

    if (userId == null) {
      print('Error: userId is null');
      return null;
    }

    String url = 'http://localhost:3000/api/perfilUsuario/$userId';
    print('URI: $url');

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print('Response body: ${response.body}');

      ProfileData profileData =
          ProfileData.fromJson(json.decode(response.body));

      print('ProfileData: $profileData');

      return profileData;
    } else {
      print('Error: ${response.statusCode}');
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
        return _buildPlan();
      case 2:
        return _buildPlan();
      case 3:
        return buildProfile(context);
      default:
        return _buildPlan();
    }
  }

  Widget _buildCustomNavigationBar() {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        height: 95,
        width: 280,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround, // Espaciado igual
          children: [
            _buildRoundedIcon(
                Icons.self_improvement, "Mi plan", _selectedIndex == 0, 0),
            _buildRoundedIcon(Icons.chat, "Chat", _selectedIndex == 1, 1),
            _buildRoundedIcon(
                Icons.favorite, "Mi test", _selectedIndex == 2, 2),
            _buildRoundedIcon(
                Icons.account_circle, "Yo", _selectedIndex == 3, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundedIcon(
      IconData iconData, String label, bool isSelected, int index) {
    return GestureDetector(
      onTap: () {
        _onItemTapped(index); // Cambia el índice al tocar
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: isSelected ? 26 : 22, // Tamaño del ícono
            backgroundColor: isSelected ? Color(0xFF5027D0) : Colors.grey[200],
            child: Icon(
              iconData,
              color: isSelected ? Colors.white : Color(0xFF5027D0),
              size: isSelected ? 26 : 22,
            ),
          ),
          SizedBox(height: 5), // Espacio entre el ícono y la etiqueta
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Color(0xFF5027D0) : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfile(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(240, 218, 250, 1),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 40),
                profileData == null
                    ? Center(child: CircularProgressIndicator())
                    : Column(
                        children: [
                          _buildProfileCard(),
                          SizedBox(height: 20),
                          _buildLogoutButton(),
                          SizedBox(height: 10),
                          Text(
                            'Versión del Proyecto: 1.0.0',
                            style: GoogleFonts.poppins(
                              fontSize: 12.0,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: _buildCustomNavigationBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildPlan() {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 237, 221, 255),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 130.0),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 35),
                    Text(
                      'Mi plan diario',
                      style: GoogleFonts.poppins(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Nivel de estrés: ',
                          style: GoogleFonts.poppins(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          nivelEstres, // Muestra el nivel de estrés
                          style: GoogleFonts.poppins(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 66, 14, 115),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 35),
                    if (isLoading)
                      CircularProgressIndicator()
                    else if (programas.isEmpty)
                      Text('No hay programas disponibles')
                    else
                      Column(
                        children: [
                          ...programas.map((programa) {
                            return _buildProgramaWidget(programa);
                          }).toList(),
                          SizedBox(height: 20),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
          // Widget flotante del chat
          if (isChatOpen)
            Positioned(
              bottom: 150,
              left: 20,
              right: 20,
              child: _buildChatWidget(),
            ),
          // Menú de navegación
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: _buildCustomNavigationBar(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 237, 221, 255),
      body: _getSelectedWidget(),
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

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      height: 220,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[200],
            child: Icon(
              Icons.account_circle, // Ícono dentro del avatar
              size: 50, // Tamaño del ícono
              color: Color(0xFF5027D0), // Color del ícono
            ),
          ),
          SizedBox(width: 15),
          _buildProfileInfo(),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          profileData?.email ?? '',
          style: GoogleFonts.poppins(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          profileData?.hierarchicalLevel ?? '',
          style: GoogleFonts.poppins(
            fontSize: 14.0,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return ElevatedButton(
      onPressed: _handleLogout,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF5027D0),
      ),
      child: Text(
        'Cerrar sesión',
        style: GoogleFonts.poppins(
          fontSize: 16.0,
          color: Colors.white,
        ),
      ),
    );
  }

  // Función para calcular los días restantes
  int calculateRemainingDays() {
    DateTime today = DateTime.now();
    DateTime endDate = today.add(Duration(days: 30)); // Por ejemplo, 30 días
    int remaining = endDate.difference(today).inDays;

    return remaining;
  }

  Future<void> obtenerNivelEstresYProgramas() async {
    int maxRetries = 8; // Máximo número de reintentos
    int retryCount = 0; // Contador de reintentos
    int waitTime = 1; // Tiempo de espera inicial en segundos

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userId = prefs.getInt('userId');
      username = prefs
          .getString('username'); // Obtener el userId desde SharedPreferences

      if (userId != null) {
        // Hacer la petición para obtener el estres_nivel_id
        final responseNivel = await http.get(
          Uri.parse(
              'http://localhost:3000/api/userestresessions/$userId/nivel'),
        );

        if (responseNivel.statusCode == 200) {
          // Procesar la respuesta JSON del nivel de estrés
          final responseData = jsonDecode(responseNivel.body);
          int estresNivelId = responseData['estres_nivel_id'];

          // Convertir el id de nivel de estrés a texto
          setState(() {
            if (estresNivelId == 1) {
              nivelEstres = "LEVE";
            } else if (estresNivelId == 2) {
              nivelEstres = "MODERADO";
            } else if (estresNivelId == 3) {
              nivelEstres = "ALTO";
            } else {
              nivelEstres = "DESCONOCIDO";
            }
          });

          // Intentos de búsqueda hasta encontrar los programas o alcanzar el límite de reintentos
          while (retryCount < maxRetries) {
            final responseProgramas = await http.post(
                Uri.parse(
                    'http://localhost:3000/api/userprograma/getprogramcompleto/$userId'),
                headers: {"Content-Type": "application/json"},
                body: jsonEncode({'user_id': userId}));

            if (responseProgramas.statusCode == 200) {
              // Procesar la respuesta JSON y almacenar los programas
              final List<dynamic> programasData =
                  jsonDecode(responseProgramas.body);
              setState(() {
                programas = programasData;
                isLoading = false; // Ya no estamos cargando
              });
              break; // Salir del bucle si encontramos los programas
            } else {
              // Incrementar el contador de reintentos y hacer una pausa antes del próximo intento
              retryCount++;
              await Future.delayed(Duration(seconds: waitTime));
              waitTime *= 2; // Incremento exponencial del tiempo de espera
            }
          }

          // Si alcanzamos el máximo de reintentos sin éxito
          if (retryCount == maxRetries) {
            setState(() {
              nivelEstres =
                  "No se encontraron programas después de varios intentos";
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

  Future<void> _sendMultipleMessages() async {
    try {
      // Verificar el estado de funcyInteract antes de proceder
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userId = prefs.getInt('userId');
      String? token = prefs.getString('token');

      if (userId != null && token != null) {
        // Hacer la petición para obtener el valor de funcyInteract
        final response = await http.get(
          Uri.parse('http://localhost:3000/api/datos/users/$userId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token', // Añadimos el token en el header
          },
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          int funcyInteract = responseData['funcyinteract'];

          // Verificar si funcyInteract es 0 o 1
          if (funcyInteract == 1) {
            print('Redirigiendo correctamente a funcy');
            return; // No continuar con el envío de mensajes si funcyInteract es 1
          } else if (funcyInteract == 0) {
            // Si funcyInteract es 0, procedemos a enviar los mensajes
            final String comentario1 = '¡Hola ${username}! 👋🐱';
            final String comentario2 =
                'Soy Funcy y me gustaría saber cómo te encuentras el día de hoy';

            // Primer mensaje (comentario1)
            await http.post(
              Uri.parse('http://localhost:3000/api/guardarMensajeFromBot'),
              headers: {'Content-Type': 'application/json'},
              body: json.encode({
                'content': comentario1,
                'userId': userId, // El userId 1 es para ambos mensajes
              }),
            );

            await Future.delayed(Duration(seconds: 1));

            // Segundo mensaje (comentario2)
            await http.post(
              Uri.parse('http://localhost:3000/api/guardarMensajeFromBot'),
              headers: {'Content-Type': 'application/json'},
              body: json.encode({
                'content': comentario2,
                'userId': userId,
              }),
            );

            print('Los dos mensajes han sido enviados con éxito.');
          }
        } else {
          print('Error al obtener datos del usuario: ${response.statusCode}');
        }
      } else {
        if (userId == null) {
          print('Usuario no encontrado en SharedPreferences.');
        }
        if (token == null) {
          print('Token no encontrado en SharedPreferences.');
        }
      }
    } catch (e) {
      print('Error al verificar funcyinteract: $e');
    }
  }

  Future<void> _updateFuncyInteract() async {
    try {
      if (userId == null) {
        print('No se encontró el ID del usuario.');
        return;
      }

      String? token = await getToken(); // Obtener el token de SharedPreferences

      if (token == null) {
        print('No se encontró el token de autenticación.');
        return;
      }

      final url = 'http://localhost:3000/api/users/$userId';
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $token', // Aquí añadimos el token en el header
        },
        body: jsonEncode(
            {'funcyinteract': 1}), // Enviamos el valor de funcyinteract
      );

      if (response.statusCode == 200) {
        print('Campo funcyinteract actualizado correctamente.');

        // Guardar en SharedPreferences si es necesario
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('funcyinteract', 1);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Interacción actualizada correctamente.')),
        );
      } else {
        print('Error al actualizar funcyinteract: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar interacción.')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al conectar con el servidor.')),
      );
    }
  }

  Widget _buildChatWidget() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 4,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título y botón de cerrar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Consejero virtual Funcy',
                style: GoogleFonts.poppins(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.black54),
                onPressed: () {
                  setState(() {
                    isChatOpen = false; // Cerrar el widget de chat
                    _selectedIndex = 0; // Selecciona "Mi plan" al cerrar
                  });
                },
              )
            ],
          ),
          SizedBox(height: 8),

          // Comentario 1
          Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 239, 239, 239),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: Text(
              '¡Hola ${username}! 👋🐱',
              style: GoogleFonts.poppins(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(height: 10),

          // Comentario 2
          Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 239, 239, 239),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: Text(
              'Soy Funcy y me gustaría saber cómo te encuentras el día de hoy',
              style: GoogleFonts.poppins(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(height: 20),

          // Botón centrado
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (userId != null) {
                  _sendMultipleMessages();
                  _updateFuncyInteract();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SplashScreen(userId: userId!)),
                  );
                } else {
                  print("Error: userId no definido");
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
                child: Text(
                  'Comencemos el chat',
                  style: GoogleFonts.poppins(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF5027D0), // Color del botón
                foregroundColor: Colors.white, // Color del texto
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, IconData> iconMapping = {
    "air": Icons.air, // Para Técnicas de Relajación
    "self_improvement": Icons.self_improvement, // Para Musicoterapia
    "spa": Icons.spa,
    "visibility": Icons.visibility, // Para Aromaterapia
    "healing": Icons.healing, // Para Musicoterapia
    "psychology": Icons.psychology, // Para Relajación Muscular Progresiva
    "music_note":
        Icons.music_note, // Para Técnicas de Visualización (El Molino)
    "emoji_nature": Icons
        .emoji_nature, // Para Técnicas Cognitivas (Pensamientos Polarizados)
    "wb_sunny": Icons
        .wb_sunny, // Para Técnicas Cognitivas (Interpretación del Pensamiento)
    "directions_walk": Icons
        .directions_walk, // Para Técnicas Cognitivas (Razonamiento Emocional)
    "nature": Icons.nature, // Para Técnicas Cognitivas (Etiquetas Globales)
    "fitness_center":
        Icons.fitness_center, // Para Técnicas Cognitivas (Culpabilidad)
    "bathtub": Icons
        .bathtub, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "do_not_disturb": Icons
        .do_not_disturb, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "airline_seat_flat": Icons
        .airline_seat_flat, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "mood": Icons
        .mood, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "water": Icons
        .water, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "motion_photos_pause": Icons
        .motion_photos_pause, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "note": Icons
        .note, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "question_answer": Icons
        .question_answer, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "transform": Icons
        .transform, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "shuffle": Icons
        .shuffle, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "calculate": Icons
        .calculate, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "theater_comedy": Icons
        .theater_comedy, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "arrow_downward": Icons
        .arrow_downward, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "loop": Icons
        .loop, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "thumb_up": Icons
        .thumb_up, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "swap_horiz": Icons
        .swap_horiz, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "table_chart": Icons
        .table_chart, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "block": Icons
        .block, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "favorite": Icons
        .favorite, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "chat": Icons
        .chat, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "stop_circle": Icons
        .stop_circle, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "emoji_events": Icons
        .emoji_events, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "account_box": Icons
        .account_box, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "fact_check": Icons
        .fact_check, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "problem_solving": Icons
        .visibility, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "style": Icons
        .style, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "control_camera": Icons
        .control_camera, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "mail": Icons
        .mail, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "help_outline": Icons
        .help_outline, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "anchor": Icons
        .anchor, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "tune": Icons
        .tune, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "compare_arrows": Icons
        .compare_arrows, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "sync_alt": Icons
        .sync_alt, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "people": Icons
        .people, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "school": Icons
        .school, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "timeline": Icons
        .timeline, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "mirror": Icons
        .fact_check, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "breakfast_dining": Icons
        .breakfast_dining, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "flip": Icons
        .flip, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "anchor_off": Icons
        .calculate, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "change_circle": Icons
        .change_circle, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "circle": Icons
        .circle, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "security": Icons
        .security, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "groups": Icons
        .groups, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "thumb_up_alt": Icons
        .thumb_up_alt, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "link": Icons
        .link, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "theaters": Icons
        .theaters, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "autorenew": Icons
        .autorenew, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "visibility_off": Icons
        .visibility_off, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "target": Icons
        .transform, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "emoji_emotions": Icons
        .emoji_emotions, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
    "record_voice_over": Icons
        .record_voice_over, // Para Terapias Laborales (Falacia de Razón en el Entorno Laboral)
  };

  Widget _buildProgramaWidget(dynamic programa) {
    // Obtener el ícono basado en el nombre que recibes desde el programa
    IconData iconoPrograma = iconMapping[programa['tecnica']['icon']] ??
        Icons.self_improvement; // Ícono por defecto

    // Definir los colores por rango de días
    Color backgroundColor;
    Color iconColor;
    Color textColor;

    // Establecer colores dependiendo del tipo de terapia
    if ((programa['tecnica']['id'] >= 7 && programa['tecnica']['id'] <= 10) ||
        (programa['tecnica']['id'] >= 74 && programa['tecnica']['id'] <= 76)) {
      backgroundColor = Color.fromARGB(255, 206, 252, 255); // Azul claro
      iconColor = Color(0xFF44DEE8); // Azul para el ícono
      textColor = Color(0xFF44DEE8); // Azul para el texto
    } else if ((programa['tecnica']['id'] >= 11 &&
            programa['tecnica']['id'] <= 15) ||
        (programa['tecnica']['id'] >= 92 && programa['tecnica']['id'] <= 95)) {
      backgroundColor = Color.fromARGB(255, 255, 220, 240); // Rosado claro
      iconColor = Color(0xFFFF44B5); // Rosado para el ícono
      textColor = Color(0xFFFF44B5); // Rosado para el texto
    } else if ((programa['tecnica']['id'] >= 16 &&
            programa['tecnica']['id'] <= 21) ||
        (programa['tecnica']['id'] >= 96 && programa['tecnica']['id'] <= 103)) {
      backgroundColor = Color.fromARGB(255, 255, 235, 205); // Naranja claro
      iconColor = Color(0xFFFFA500); // Naranja para el ícono
      textColor = Color(0xFFFFA500); // Naranja para el texto
    } else if ((programa['tecnica']['id'] >= 22 &&
            programa['tecnica']['id'] <= 27) ||
        (programa['tecnica']['id'] >= 104 &&
            programa['tecnica']['id'] <= 110)) {
      backgroundColor = Color.fromARGB(255, 240, 255, 208); // Verde claro
      iconColor = Color(0xFF8BC34A); // Verde para el ícono
      textColor = Color(0xFF8BC34A); // Verde para el texto
    } else if ((programa['tecnica']['id'] >= 28 &&
            programa['tecnica']['id'] <= 31) ||
        (programa['tecnica']['id'] >= 111 &&
            programa['tecnica']['id'] <= 116)) {
      backgroundColor =
          Color.fromARGB(255, 220, 230, 250); // Azul violáceo claro
      iconColor = Color(0xFF5C6BC0); // Azul violáceo para el ícono
      textColor = Color(0xFF5C6BC0); // Azul violáceo para el texto
    } else if (programa['tecnica']['id'] >= 52 &&
        programa['tecnica']['id'] <= 58) {
      backgroundColor = Color.fromARGB(255, 255, 240, 200); // Amarillo pálido
      iconColor = Color(0xFFFFC107); // Amarillo para el ícono
      textColor = Color(0xFFFFC107); // Amarillo para el texto
    } else if (programa['tecnica']['id'] >= 59 &&
        programa['tecnica']['id'] <= 65) {
      backgroundColor = Color.fromARGB(255, 255, 200, 200); // Amarillo pálido
      iconColor = Color.fromARGB(255, 255, 7, 7); // Amarillo para el ícono
      textColor = Color.fromARGB(255, 255, 7, 7); // Amarillo para el texto
    } else if (programa['tecnica']['id'] >= 66 &&
        programa['tecnica']['id'] <= 73) {
      backgroundColor = Color.fromARGB(255, 255, 200, 213); // Amarillo pálido
      iconColor = Color.fromARGB(255, 255, 7, 230); // Amarillo para el ícono
      textColor = Color.fromARGB(255, 255, 7, 230); // Amarillo para el texto
    } else {
      // Color por defecto si el tipo no coincide
      backgroundColor =
          Color.fromARGB(255, 206, 252, 255); // Azul claro por defecto
      iconColor = Color(0xFF44DEE8); // Azul para el ícono
      textColor = Color(0xFF44DEE8); // Azul para el texto
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment
            .start, // Asegura que la sección del día y el contenedor blanco estén alineados correctamente
        children: [
          // Sección para el Día y la barra
          SizedBox(
            width: 55, // Ancho fijo para la sección del Día
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Día',
                  style: GoogleFonts.poppins(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                Text(
                  programa['dia']
                      .toString()
                      .padLeft(2, '0'), // Día desde el API
                  style: GoogleFonts.poppins(
                    fontSize: 34.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Container(
                  // Eliminamos Expanded para evitar problemas de restricciones no acotadas
                  height: 40, // Ajusta el tamaño según necesites
                  width: 3,
                  color: const Color.fromARGB(
                      255, 255, 255, 255), // Línea divisoria blanca
                ),
              ],
            ),
          ),
          SizedBox(
              width:
                  16), // Espacio entre la sección del Día y el contenedor blanco

          // Contenedor del programa
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título del programa
                  Text(
                    programa['tecnica']['nombre'], // Nombre del programa
                    style: GoogleFonts.poppins(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  // Fila con descripción y el botón de play
                  Row(
                    children: [
                      Flexible(
                        // Utilizamos Flexible en lugar de Expanded para evitar overflow
                        child: Text(
                          programa['tecnica']['mensaje'] ??
                              '', // Descripción del programa
                          style: GoogleFonts.poppins(
                            fontSize: 14.0,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      // Botón de play centrado
                      // Botón de play centrado
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: GestureDetector(
                            onTap: () {
                              dynamic stepsData = programa['tecnica']['steps'];
                              List<dynamic> steps;

                              // Verifica si 'steps' es un string JSON o una lista
                              if (stepsData is String) {
                                steps = json.decode(
                                    stepsData); // Decodifica si es una cadena JSON
                              } else {
                                steps = stepsData; // Usa la lista directamente
                              }

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StepScreen(
                                    steps: steps, // Pasa los pasos
                                    tecnicaNombre: programa['tecnica'][
                                        'nombre'], // Pasa el nombre de la técnica
                                    dia: programa['dia'], // Pasa el día
                                    userId:
                                        programa['user_id'], // Pasa el user_id
                                    tecnicaId: programa['tecnica']
                                        ['id'], // Pasa el tecnica_id
                                  ),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              backgroundColor:
                                  Color.fromARGB(255, 237, 221, 255),
                              radius: 24,
                              child: Icon(
                                Icons.play_arrow,
                                size: 28,
                                color: Color.fromARGB(255, 75, 21, 141),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  // Fila con audífono + check y el botón tipo
                  Row(
                    children: [
                      // Audífono con check superpuesto
                      Stack(
                        clipBehavior: Clip
                            .none, // Permitir que los elementos se dibujen fuera de los límites del Stack
                        children: [
                          CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 240, 240, 240),
                            radius:
                                15, // Aumentamos un poco el tamaño del círculo base
                            child: Icon(
                              Icons.headset, // Ícono de audífono
                              color: Color.fromARGB(255, 103, 21, 141),
                              size: 18,
                            ),
                          ),
                          Positioned(
                            top:
                                -4, // Ajustamos la posición hacia arriba para que quede en la esquina
                            right: -4, // Ajustamos a la derecha
                            child: CircleAvatar(
                              backgroundColor: Colors.green,
                              radius:
                                  8, // Aumentamos el radio para que el círculo del check sea visible
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size:
                                    9, // Tamaño adecuado del ícono check dentro del círculo
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 6),
                      // Botón tipo Chip con el tipo de programa
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              iconoPrograma,
                              size: 18,
                              color: iconColor,
                            ),
                            SizedBox(width: 6),
                            Text(
                              programa['tecnica']['tipo'],
                              style: GoogleFonts.poppins(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileData {
  final String email;
  final String hierarchicalLevel;
  final String? profileImage;

  ProfileData({
    required this.email,
    required this.hierarchicalLevel,
    this.profileImage,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      email: json['User']['email'],
      hierarchicalLevel: json['HierarchicalLevel']['level'],
      profileImage: json['User']['profileImage'],
    );
  }
  @override
  String toString() {
    return 'ProfileData{profileImage: $profileImage, hierarchicalLevel: $hierarchicalLevel, email: $email}';
  }
}
