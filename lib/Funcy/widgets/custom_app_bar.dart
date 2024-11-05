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
    final iconColor = Colors.black;

    return Container(
      color: backgroundColor, // Fondo blanco
      child: AppBar(
        backgroundColor: backgroundColor, // Cambiar a un color sólido
        elevation: 0, // Sin sombra para un look más limpio
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: iconColor),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/logo_funcy_scale.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 12), // Mayor separación entre logo y texto
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Funcy IA',
                  style: TextStyle(
                    fontSize: 20, // Aumentar tamaño de fuente
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Online',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green, // Cambiar el color del texto
                      ),
                    ),
                    SizedBox(width: 4), // Espacio entre texto y el indicador
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.green, // Color del indicador
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
