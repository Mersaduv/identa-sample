import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu,
            color: Color(0xFF2D9CDB)), // Set the color of the burger menu icon
        onPressed: () {
          // Open the menu
        },
      ),
      title: const Text(
        'identa',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D9CDB)), // Set the color of the "identa" text
      ),
      centerTitle: true,
      elevation: 0.0,
      backgroundColor: Colors.transparent,
    );
  }
}
