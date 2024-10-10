import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:fnlapp/Main/home.dart';
import 'dart:convert'; // Para manejar el JSON

class FinalStepScreen extends StatefulWidget {
  final int userId;
  final int tecnicaId;

  FinalStepScreen({required this.userId, required this.tecnicaId});

  @override
  _FinalStepScreenState createState() => _FinalStepScreenState();
}

class _FinalStepScreenState extends State<FinalStepScreen> {
  final TextEditingController commentController = TextEditingController();
  double _rating = 0; // Valor inicial para el rating de estrellas
  bool _isButtonEnabled = false;

  // Verifica si ambos campos están completos (comentario y calificación)
  void _checkInput() {
    setState(() {
      _isButtonEnabled = commentController.text.isNotEmpty && _rating > 0;
    });
  }

  // Función para enviar los datos a la API
  Future<void> _sendData() async {
    final String apiUrl = "http://localhost:3000/api/userprograma/${widget.userId}/${widget.tecnicaId}";

    // Estructura de los datos a enviar
    final Map<String, dynamic> data = {
      "comentario": commentController.text,
      "estrellas": _rating.toInt()
    };

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        // Mostrar un mensaje de éxito o realizar cualquier otra acción
        print('Comentario y calificación enviados exitosamente');
        // Navegar al home eliminando las pantallas anteriores
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()), // Reemplaza con tu pantalla de Home
          (Route<dynamic> route) => false, // Esto elimina todas las rutas anteriores
        );
      } else {
        print('Error al enviar los datos: ${response.body}');
      }
    } catch (e) {
      print('Error de red: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Fondo transparente para mostrar la imagen
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 3, 12, 12),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Color blanco para la flecha
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Final de la técnica',
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          // Imagen de fondo
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/login.png'), // Ruta de la imagen en assets
                fit: BoxFit.cover, // Ajusta la imagen al tamaño de la pantalla
              ),
            ),
            child: Container(
              color: Colors.black.withOpacity(0), // Sombreado del 30% encima de la imagen
            ),
          ),
          // Contenido centralizado
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Título
                Text(
                  "Califica tu experiencia con la técnica de relajación de hoy que te ofreció Funcy",
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                // Subtítulo con padding a los costados
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0), // Padding lateral de 10
                  child: Text(
                    "¿Qué tan aliviado te sientes luego de la sesión de hoy?",
                    style: TextStyle(fontSize: 16.0, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                // Rating
                RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _rating = rating;
                      _checkInput(); // Verifica si se puede habilitar el botón
                    });
                  },
                ),
                SizedBox(height: 30),
                // Input de comentario
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Deja un comentario sobre la técnica",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    maxLines: 3,
                    onChanged: (value) {
                      _checkInput(); // Verifica si se puede habilitar el botón
                    },
                  ),
                ),
                SizedBox(height: 20),
                // Botón de enviar
                ElevatedButton(
                  onPressed: _isButtonEnabled ? _sendData : null, // Habilitar solo si los campos están completos
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 75, 21, 141),
                  ),
                  child: Text(
                    'Enviar',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          // Botón de volver en la parte inferior
          Positioned(
            bottom: 30,
            left: MediaQuery.of(context).size.width / 2 - 28, // Centrar el botón
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 75, 21, 141), // Fondo circular
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white), // Flecha en blanco
                iconSize: 28,
                onPressed: () {
                  Navigator.pop(context); // Regresa a la pantalla anterior
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
