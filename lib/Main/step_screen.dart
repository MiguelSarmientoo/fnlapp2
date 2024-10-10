import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fnlapp/Main/finalstepscreen.dart';

class StepScreen extends StatefulWidget {
  final List<dynamic> steps; // Lista de pasos a mostrar
  final String tecnicaNombre; // Nombre de la técnica
  final int dia; // Número del día
  final int userId; // Nuevo: user_id
  final int tecnicaId; // Nuevo: tecnica_id

  StepScreen({
    required this.steps,
    required this.tecnicaNombre,
    required this.dia,
    required this.userId, // Nuevo: user_id
    required this.tecnicaId, // Nuevo: tecnica_id
  });

  @override
  _StepScreenState createState() => _StepScreenState();
}

class _StepScreenState extends State<StepScreen> {
  int currentStep = 0; // Índice del paso actual
  FlutterTts flutterTts = FlutterTts(); // Instancia de FlutterTts
  bool isPlaying = false; // Para controlar si se está reproduciendo el audio
  TextEditingController commentController = TextEditingController(); // Controlador del input de comentario
  double _rating = 0; // Valor inicial para el rating de estrellas

  bool isImageStep(int index) {
    // Las posiciones pares (0, 2, 4...) son mensajes y las impares (1, 3, 5...) son imágenes
    return index % 2 != 0;
  }

  // Función para leer el texto
  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("es-ES"); // Establecer el idioma español
    await flutterTts.setPitch(1.0); // Tono de voz normal
    await flutterTts.speak(text); // Leer el texto
    setState(() {
      isPlaying = true; // Cambia el estado a reproduciendo
    });
  }

  // Función para detener la lectura
  Future<void> _stop() async {
    await flutterTts.stop(); // Detiene la lectura
    setState(() {
      isPlaying = false; // Cambia el estado a detenido
    });
  }

  @override
  void dispose() {
    // Asegúrate de detener la lectura cuando el widget se elimine
    flutterTts.stop();
    commentController.dispose(); // Libera el controlador del input
    super.dispose();
  }

  // Función para enviar el comentario
  void _sendComment() {
    // Aquí puedes manejar el envío del comentario, por ahora simplemente hace pop
    Navigator.pop(context); // Volver al home
    print('Rating: $_rating'); // Verificar el valor del rating
  }

  @override
  Widget build(BuildContext context) {
    // Se define el número máximo de vistas (6 para los pasos + 1 para la vista del comentario)
    int maxSteps = widget.steps.length * 2;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 3, 12, 12), // Color de fondo oscuro
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          'Mi plan diario',
          style: GoogleFonts.poppins(fontSize: 16.0, color: Colors.white),
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            if (isImageStep(currentStep) && currentStep < maxSteps) // Solo mostrar el fondo si es un paso de imagen
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.steps[currentStep ~/ 2]['linkimg']), // Imagen de fondo
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.3), // Agrega el sombreado (30% de opacidad)
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Texto o imagen en la parte central
                  Expanded(
                    child: Center(
                      child: currentStep < maxSteps
                          ? isImageStep(currentStep)
                              ? Container() // No mostrar nada en el centro cuando sea imagen (ya es el fondo)
                              : Text(
                                  widget.steps[currentStep ~/ 2]['message'],
                                  style: GoogleFonts.poppins(
                                      fontSize: 22.0, color: Colors.white, height: 1.5),
                                  textAlign: TextAlign.center,
                                )
                          : Container(), // Evita error si intentamos acceder a una vista más allá de los steps
                    ),
                  ),
                  // Texto del día y la técnica
                  if (currentStep < maxSteps)
                    Column(
                      children: [
                        Text(
                          'Día ${widget.dia.toString().padLeft(2, '0')}',
                          style: GoogleFonts.poppins(fontSize: 14.0, color: Colors.white),
                        ),
                        Text(
                          widget.tecnicaNombre,
                          style: GoogleFonts.poppins(
                              fontSize: 16.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  SizedBox(height: 20),
                  
                  // Si es la última vista, mostrar el input y el botón "Enviar"
                  if (currentStep == maxSteps)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center, // Centra verticalmente
                        children: [
                          // Título y Rating
                          Text(
                            "Califica tu experiencia con las técnicas de relajación",
                            style: GoogleFonts.poppins(fontSize: 16.0, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
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
                              });
                            },
                          ),
                          SizedBox(height: 30),
                          // Input para el comentario
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: TextField(
                              controller: commentController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Deja un comentario sobre la técnica",
                                hintStyle: GoogleFonts.poppins(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              maxLines: 3,
                            ),
                          ),
                          SizedBox(height: 20),
                          // Botón "Enviar"
                          ElevatedButton(
                            onPressed: _sendComment, // Llama a la función para enviar el comentario
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 75, 21, 141),
                            ),
                            child: Text(
                              'Enviar',
                              style: GoogleFonts.poppins(fontSize: 16.0, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  // Botones de navegación y audio solo si es mensaje
                  if (currentStep < maxSteps)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Botón anterior (solo si no es la primera vista)
                        if (currentStep > 0)
                          Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 75, 21, 141), // Fondo circular
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.skip_previous, color: Colors.white),
                              iconSize: 28, // Tamaño del ícono ajustado
                              onPressed: () {
                                setState(() {
                                  if (currentStep > 0) {
                                    currentStep--;
                                  }
                                });
                              },
                            ),
                          ),
                        SizedBox(width: 20), // Separador
                        // Botón siguiente (mostrar en todas las vistas menos la final de comentarios)
                        if (currentStep < maxSteps) // Mostrar botón "siguiente" hasta la sexta vista
                          Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 75, 21, 141), // Fondo circular
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.skip_next, color: Colors.white),
                              iconSize: 28, // Tamaño del ícono ajustado
                              onPressed: () {
                                if (currentStep == 5) {
                                  // Ir a la nueva vista cuando sea el último paso
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FinalStepScreen(
                                        userId: widget.userId, // Pasa el user_id
                                        tecnicaId: widget.tecnicaId, // Pasa el tecnica_id
                                      ),
                                    ),
                                  );
                                } else {
                                  setState(() {
                                    currentStep++;
                                  });
                                }
                              },
                            ),
                          ),
                        SizedBox(width: 20), // Separador
                        // Botón de audio (solo cuando sea un mensaje)
                        if (!isImageStep(currentStep))
                          Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 75, 21, 141), // Fondo circular
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(isPlaying ? Icons.stop : Icons.volume_up, color: Colors.white),
                              iconSize: 28, // Tamaño del ícono ajustado
                              onPressed: () {
                                if (isPlaying) {
                                  _stop(); // Detiene la lectura
                                } else {
                                  _speak(widget.steps[currentStep ~/ 2]['message']); // Lee el texto
                                }
                              },
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
