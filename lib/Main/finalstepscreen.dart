import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:fnlapp/Main/home.dart';
import 'dart:convert';
import '../config.dart'; 

class FinalStepScreen extends StatefulWidget {
  final int userId;
  final int tecnicaId;

  FinalStepScreen({required this.userId, required this.tecnicaId});

  @override
  _FinalStepScreenState createState() => _FinalStepScreenState();
}

class _FinalStepScreenState extends State<FinalStepScreen> {
  final TextEditingController commentController = TextEditingController();
  double _rating = 0;
  bool _isButtonEnabled = false;
  String _feedbackMessage = '';

  void _checkInput() {
    setState(() {
      _isButtonEnabled = commentController.text.isNotEmpty && _rating > 0;
    });
  }

  Future<void> _sendData() async {
    // Usa la URL base desde el archivo de configuración
    final String apiUrl = "${Config.apiUrl}/userprograma/${widget.userId}/${widget.tecnicaId}";

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
        setState(() {
          _feedbackMessage = 'Comentario y calificación enviados exitosamente';
        });
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (Route<dynamic> route) => false,
        );
      } else {
        setState(() {
          _feedbackMessage = 'Error al enviar los datos: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _feedbackMessage = 'Error de red: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 3, 12, 12),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
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
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://funkyrecursos.s3.us-east-2.amazonaws.com/assets/login.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: Colors.black.withOpacity(0.5), // Sombreado del 60% encima de la imagen
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Califica tu experiencia con la técnica de relajación de hoy que te ofreció Funcy",
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    "¿Qué tan aliviado te sientes luego de la sesión de hoy?",
                    style: TextStyle(fontSize: 16.0, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                RatingBar.builder(
                  initialRating: 3,
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
                      _checkInput();
                    });
                  },
                ),
                SizedBox(height: 30),
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
                      _checkInput();
                    },
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isButtonEnabled ? _sendData : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 75, 21, 141),
                  ),
                  child: Text(
                    'Enviar',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                // Mensaje de feedback
                Text(
                  _feedbackMessage,
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: MediaQuery.of(context).size.width / 2 - 28,
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 75, 21, 141),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                iconSize: 28,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
