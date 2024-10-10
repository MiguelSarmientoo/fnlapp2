import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double scrollOffset;
  final Color backgroundColor;

    CustomAppBar({
      required this.scrollOffset,
      this.backgroundColor = Colors.white, // Color por defecto
    });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Color.fromARGB(255, 255, 255, 255); // Usar Colors.white para un blanco puro
    final iconColor = Colors.black;

    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0, // Eliminar la sombra para que se vea más fluida
      leading: Padding(
        padding: EdgeInsets.only(left: 20.0),
        child: IconButton(
          icon: Icon(Icons.arrow_back, color: iconColor), // Icono de color negro
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      title: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white, // Fondo blanco
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/logo_funcy_scale.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Funcy IA',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                ),
              ),
              Text(
                'Online',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        SizedBox(width: 8),
      ],
    );
  }
}
