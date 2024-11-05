import 'package:flutter/material.dart';

class ChatBoxFooter extends StatelessWidget {
  final TextEditingController textEditingController;
  final Function(String) onSendMessage;

  ChatBoxFooter({
    required this.textEditingController,
    required this.onSendMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 245, 245, 245), // Fondo gris claro
      padding: EdgeInsets.all(12.0), // Espaciado adicional
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0), // Borde más redondeado
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(0, 4), // Sombra más difusa
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0), // Más espaciado horizontal
                child: TextField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    hintText: 'Escribe tu mensaje...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey[600]),
                  ),
                  maxLines: null, // Permitir múltiples líneas
                  minLines: 1, // Mínimo de una línea
                  textInputAction: TextInputAction.send,
                  onSubmitted: (message) {
                    String trimmedMessage = message.trim();
                    if (trimmedMessage.isNotEmpty) {
                      onSendMessage(trimmedMessage);
                      textEditingController.clear();
                    }
                  },
                ),
              ),
            ),
          ),
          SizedBox(width: 10), // Espaciado entre el TextField y el botón de enviar
          IconButton(
            icon: Icon(Icons.send, color: const Color(0xFF3F0071)),
            onPressed: () {
              String message = textEditingController.text.trim();
              if (message.isNotEmpty) {
                onSendMessage(message);
                textEditingController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
