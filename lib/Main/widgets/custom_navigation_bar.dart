import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  final bool showExitTest;

  CustomNavigationBar({
    required this.selectedIndex,
    required this.onItemTapped,
    required this.showExitTest,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20), // Ajusta el valor según el espacio deseado
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          height: 95,
          width: 320,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(showExitTest ? 5 : 4, (index) {
              return _buildRoundedIcon(context, index);
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildRoundedIcon(BuildContext context, int index) {
    List<Map<String, dynamic>> items = [
      {'icon': Icons.self_improvement, 'label': 'Mi plan'},
      {'icon': Icons.chat, 'label': 'Chat'},
      {'icon': Icons.favorite, 'label': 'Mi test'},
      {'icon': Icons.account_circle, 'label': 'Yo'},
      if (showExitTest) {'icon': Icons.check_circle, 'label': 'Test de Salida'},
    ];

    // Verifica que el índice esté dentro del rango
    if (index >= items.length) return Container();

    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: selectedIndex == index ? 26 : 22,
            backgroundColor: selectedIndex == index ? Color(0xFF5027D0) : Colors.grey[200],
            child: Icon(
              items[index]['icon'],
              color: selectedIndex == index ? Colors.white : Color(0xFF5027D0),
              size: selectedIndex == index ? 26 : 22,
            ),
          ),
          SizedBox(height: 5),
          Text(
            items[index]['label'],
            style: TextStyle(
              fontSize: 10,
              fontWeight: selectedIndex == index ? FontWeight.bold : FontWeight.normal,
              color: selectedIndex == index ? Color(0xFF5027D0) : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
