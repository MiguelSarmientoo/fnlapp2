import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fnlapp/SharedPreferences/sharedpreference.dart';
import 'package:fnlapp/Main/cargarprograma.dart';
import 'package:fnlapp/config.dart';
import '../Preguntas/questions_data.dart';

class TestEstresQuestionScreen extends StatefulWidget {
  const TestEstresQuestionScreen({Key? key}) : super(key: key);

  @override
  _TestEstresQuestionScreenState createState() => _TestEstresQuestionScreenState();
}

class _TestEstresQuestionScreenState extends State<TestEstresQuestionScreen> {
  int currentQuestionIndex = 0;
  List<int?> selectedOptions = List<int?>.filled(23, null); // Almacena las respuestas seleccionadas
  int? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();  // Cargamos el ID del usuario al iniciar
  }

  // Función para cargar el userId desde SharedPreferences
  Future<void> _loadUserId() async {
    int? id = await getUserId();  // Función que obtienes de SharedPreferences
    setState(() {
      userId = id;
    });
  }

  // Función para seleccionar una opción
  void selectOption(int optionId) {
    setState(() {
      selectedOptions[currentQuestionIndex] = optionId;  // Guarda la respuesta para la pregunta actual
    });
  }

  void goToNextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    }
  }

  void goToPreviousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
      });
    }
  }

  Future<void> submitTest() async {
    final url = Uri.parse('${Config.apiUrl}/guardarTestEstres');
    final updateEstresUrl = Uri.parse('${Config.apiUrl}/userestresessions/assign');
    
    final Map<String, dynamic> data = {
      'user_id': userId,
      'pregunta_1': selectedOptions[0],
      'pregunta_2': selectedOptions[1],
      'pregunta_3': selectedOptions[2],
      'pregunta_4': selectedOptions[3],
      'pregunta_5': selectedOptions[4],
      'pregunta_6': selectedOptions[5],
      'pregunta_7': selectedOptions[6],
      'pregunta_8': selectedOptions[7],
      'pregunta_9': selectedOptions[8],
      'pregunta_10': selectedOptions[9],
      'pregunta_11': selectedOptions[10],
      'pregunta_12': selectedOptions[11],
      'pregunta_13': selectedOptions[12],
      'pregunta_14': selectedOptions[13],
      'pregunta_15': selectedOptions[14],
      'pregunta_16': selectedOptions[15],
      'pregunta_17': selectedOptions[16],
      'pregunta_18': selectedOptions[17],
      'pregunta_19': selectedOptions[18],
      'pregunta_20': selectedOptions[19],
      'pregunta_21': selectedOptions[20],
      'pregunta_22': selectedOptions[21],
      'pregunta_23': selectedOptions[22],
      'estado': 'activo',
    };

    int totalScore = selectedOptions.fold(0, (sum, value) => sum + (value ?? 0));

    try {
      String nivelEstres = '';
      int estresNivelId = 0;

      final genderResponse = await http.get(Uri.parse('${Config.apiUrl}/userResponses/$userId'));

      if (genderResponse.statusCode == 200) {
        final List<dynamic> userData = json.decode(genderResponse.body);
        int genderId = userData[0]['gender_id'];

        // Calcular el nivel de estrés
        if (totalScore <= 92) {
          nivelEstres = 'LEVE';
          estresNivelId = 1;
        } else if (totalScore > 92 && totalScore <= 138) {
          if (genderId == 1 || genderId == null) {
            nivelEstres = 'MODERADO';
            estresNivelId = 2;
          } else if (genderId == 2) {
            if (totalScore <= 132) {
              nivelEstres = 'MODERADO';
              estresNivelId = 2;
            } else {
              nivelEstres = 'ALTO';
              estresNivelId = 3;
            }
          }
        } else if (totalScore <= 161) {
          if (genderId == 1 || genderId == null) {
            if (totalScore > 138) {
              nivelEstres = 'ALTO';
              estresNivelId = 3;
            }
          } else if (genderId == 2) {
            if (totalScore > 132) {
              nivelEstres = 'ALTO';
              estresNivelId = 3;
            }
          }
        }

        // Enviar el nivel de estrés al backend para generar las técnicas
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: json.encode(data),
        );

        if (response.statusCode == 200) {
          final updateData = {
            'user_id': userId,
            'estres_nivel_id': estresNivelId,
          };

          final updateResponse = await http.post(
            updateEstresUrl,
            headers: {"Content-Type": "application/json"},
            body: json.encode(updateData),
          );

          if (updateResponse.statusCode == 200) {
            // Después de procesar las respuestas, mostrar las técnicas de estrés generadas
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CargarProgramaScreen(nivelEstres: nivelEstres),
              ),
            );
          } else {
            print('Error al actualizar el estres_nivel_id: ${updateResponse.body}');
          }
        } else {
          print('Error al guardar el test: ${response.body}');
        }
      } else {
        print('Error al obtener el gender_id: ${genderResponse.statusCode}');
      }
    } catch (e) {
      print('Error al enviar el test: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestionIndex];

    return Scaffold(
      body: SingleChildScrollView( // Envolver el contenido principal en un SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                'Pregunta ${currentQuestionIndex + 1} de ${questions.length}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              Text(question['question']!, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              if (question['description'] != null) ...[
                SizedBox(height: 10),
                Text(question['description']!, style: TextStyle(fontSize: 18)),
              ],
              SizedBox(height: 20),
              Column(
                children: List.generate(8, (index) {
                  return RadioListTile<int>(
                    title: Text(question['option${index + 1}']!),
                    value: index + 1,
                    groupValue: selectedOptions[currentQuestionIndex],
                    onChanged: (value) {
                      if (value != null) {
                        selectOption(value);
                      }
                    },
                  );
                }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (currentQuestionIndex > 0)
                    ElevatedButton(
                      onPressed: goToPreviousQuestion,
                      child: Text('Anterior'),
                    ),
                  ElevatedButton(
                    onPressed: goToNextQuestion,
                    child: Text('Siguiente'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitTest,
                child: Text('Enviar Test'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
