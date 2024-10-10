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
      color: Color.fromARGB(93, 255, 255, 255),
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          // IconButton(
          //   icon: Icon(Icons.attach_file),
          //   onPressed: () {
          //     // Implementar lógica para adjuntar archivos si es necesario
          //   },
          // ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: textEditingController,
                decoration: InputDecoration(
                  hintText: 'Escribe tu mensaje...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
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
