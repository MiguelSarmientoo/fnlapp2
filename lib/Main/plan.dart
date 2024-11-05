import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert'; // Importa esta librería para usar json.decode
import 'package:fnlapp/Main/step_screen.dart';

class PlanScreen extends StatelessWidget {
  final String nivelEstres;
  final bool isLoading;
  final List<dynamic> programas;

  PlanScreen({required this.nivelEstres, required this.isLoading, required this.programas});

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Color.fromARGB(255, 237, 221, 255),
    body: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 130.0),
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0), 
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Mi plan diario',
                      style: GoogleFonts.poppins(fontSize: 28.0, fontWeight: FontWeight.w600, color: Color(0xFF3F0071)),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Nivel de estrés: ', 
                          style: GoogleFonts.poppins(fontSize: 18.0, fontWeight: FontWeight.w500, color: Color(0xFF4A4A4A)),
                        ),
                        Text(
                          nivelEstres, 
                          style: GoogleFonts.poppins(fontSize: 18.0, fontWeight: FontWeight.bold, color: Color(0xFF3F0071)),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    if (isLoading)
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3F0071)),
                      )
                    else if (programas.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(
                          'No hay programas disponibles',
                          style: GoogleFonts.poppins(fontSize: 16.0, color: Color(0xFF4A4A4A)),
                        ),
                      )
                    else
                      Column(
                        children: programas.map((programa) => 
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: _buildProgramaWidget(programa, context),
                          )
                        ).toList(),
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

  Widget _buildProgramaWidget(dynamic programa, BuildContext context) {
    IconData iconoPrograma = iconMapping[programa['tecnica']['icon']] ?? Icons.self_improvement;

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
  } else if ((programa['tecnica']['id'] >= 11 && programa['tecnica']['id'] <= 15) ||
      (programa['tecnica']['id'] >= 92 && programa['tecnica']['id'] <= 95)) {
    backgroundColor = Color.fromARGB(255, 255, 220, 240); // Rosado claro
    iconColor = Color(0xFFFF44B5); // Rosado para el ícono
    textColor = Color(0xFFFF44B5); // Rosado para el texto
  } else if ((programa['tecnica']['id'] >= 16 && programa['tecnica']['id'] <= 21) ||
      (programa['tecnica']['id'] >= 96 && programa['tecnica']['id'] <= 103)) {
    backgroundColor = Color.fromARGB(255, 255, 235, 205); // Naranja claro
    iconColor = Color(0xFFFFA500); // Naranja para el ícono
    textColor = Color(0xFFFFA500); // Naranja para el texto
  } else if ((programa['tecnica']['id'] >= 22 && programa['tecnica']['id'] <= 27) ||
      (programa['tecnica']['id'] >= 104 && programa['tecnica']['id'] <= 110)) {
    backgroundColor = Color.fromARGB(255, 240, 255, 208); // Verde claro
    iconColor = Color(0xFF8BC34A); // Verde para el ícono
    textColor = Color(0xFF8BC34A); // Verde para el texto
  } else if ((programa['tecnica']['id'] >= 28 && programa['tecnica']['id'] <= 31) ||
      (programa['tecnica']['id'] >= 111 && programa['tecnica']['id'] <= 116)) {
    backgroundColor = Color.fromARGB(255, 220, 230, 250); // Azul violáceo claro
    iconColor = Color(0xFF5C6BC0); // Azul violáceo para el ícono
    textColor = Color(0xFF5C6BC0); // Azul violáceo para el texto
  } else if (programa['tecnica']['id'] >= 52 && programa['tecnica']['id'] <= 58) {
    backgroundColor = Color.fromARGB(255, 255, 240, 200); // Amarillo pálido
    iconColor = Color(0xFFFFC107); // Amarillo para el ícono
    textColor = Color(0xFFFFC107); // Amarillo para el texto
  } else if (programa['tecnica']['id'] >= 59 && programa['tecnica']['id'] <= 65) {
    backgroundColor = Color.fromARGB(255, 255, 200, 200); // Amarillo pálido
    iconColor = Color.fromARGB(255, 255, 7, 7); // Amarillo para el ícono
    textColor = Color.fromARGB(255, 255, 7, 7); // Amarillo para el texto
  } else if (programa['tecnica']['id'] >= 66 && programa['tecnica']['id'] <= 73) {
    backgroundColor = Color.fromARGB(255, 255, 200, 213); // Amarillo pálido
    iconColor = Color.fromARGB(255, 255, 7, 230); // Amarillo para el ícono
    textColor = Color.fromARGB(255, 255, 7, 230); // Amarillo para el texto
  } else {
    backgroundColor = Color.fromARGB(255, 206, 252, 255); // Azul claro por defecto
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
    width: 350, // Establecer un ancho definido
    margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0), // Margen para separar de otros elementos
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                programa['tecnica']['mensaje'] ?? '', // Descripción del programa
                style: GoogleFonts.poppins(
                  fontSize: 14.0,
                  color: Colors.black87,
                ),
              ),
            ),
            // Botón de play centrado
            GestureDetector(
              onTap: () {
                dynamic stepsData = programa['tecnica']['steps'];
                List<dynamic> steps;

                // Verifica si 'steps' es un string JSON o una lista
                if (stepsData is String) {
                  steps = json.decode(stepsData); // Decodifica si es una cadena JSON
                } else {
                  steps = stepsData; // Usa la lista directamente
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StepScreen(
                      steps: steps, // Pasa los pasos
                      tecnicaNombre: programa['tecnica']['nombre'], // Pasa el nombre de la técnica
                      dia: programa['dia'], // Pasa el día
                      userId: programa['user_id'], // Pasa el user_id
                      tecnicaId: programa['tecnica']['id'], // Pasa el tecnica_id
                    ),
                  ),
                );
              },
              child: CircleAvatar(
                backgroundColor: Color.fromARGB(255, 237, 221, 255),
                radius: 24,
                child: Icon(
                  Icons.play_arrow,
                  size: 28,
                  color: Color.fromARGB(255, 75, 21, 141),
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
              clipBehavior: Clip.none, // Permitir que los elementos se dibujen fuera de los límites del Stack
              children: [
                CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 240, 240, 240),
                  radius: 15, // Aumentamos un poco el tamaño del círculo base
                  child: Icon(
                    Icons.headset, // Ícono de audífono
                    color: Color.fromARGB(255, 103, 21, 141),
                    size: 18,
                  ),
                ),
                Positioned(
                  top: -4, // Ajustamos la posición hacia arriba para que quede en la esquina
                  right: -4, // Ajustamos a la derecha
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 8, // Aumentamos el radio para que el círculo del check sea visible
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 9, // Tamaño adecuado del ícono check dentro del círculo
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 6),
            // Botón tipo Chip con el tipo de programa
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
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

