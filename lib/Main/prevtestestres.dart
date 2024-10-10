import 'package:flutter/material.dart';
import 'package:fnlapp/Main/testestres_form.dart';

class TestEstresScreen extends StatelessWidget {
  const TestEstresScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( // Usamos Center para asegurar que todo esté centrado horizontalmente
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),  // Ajuste de padding horizontal
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,  // Centramos todo horizontalmente
            children: [
              // Añadimos un Spacer para separar la imagen de la parte superior
              Spacer(flex: 2),  // Espacio superior flexible (mayor)
              
              // Imagen en la parte superior
              Image.asset(
                'assets/testestres/estresimg.png', // Asegúrate de tener la imagen en los assets
                height: 350,  // Ajusta el tamaño si es necesario
              ),
              
              SizedBox(height: 40),  // Espacio entre la imagen y el título

              // Título
              Text(
                'Bienvenido al Test de Estrés',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: 20),  // Espacio entre el título y el texto

              // Texto descriptivo ajustado en ancho
              Container(
                width: MediaQuery.of(context).size.width * 0.85, // Ajuste del ancho para centrado
                child: Text(
                  'Este test te ayudará a evaluar tu nivel de estrés. A continuación, responderás a 10 preguntas sobre tu bienestar y estilo de vida.',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              Spacer(flex: 3),  // Espacio flexible para centrar verticalmente, mayor para el ajuste

              // Botón para comenzar el test con espacio adicional en la parte inferior
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),  // Añadir espacio extra en el fondo
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TestEstresQuestionScreen()), // Aquí navegas a la pantalla del test de estrés
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Text(
                    'Comenzar Test',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),

              ),
            ],
          ),
        ),
      ),
    );
  }
}
