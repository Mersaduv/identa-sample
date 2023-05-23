import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 16.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: SvgPicture.asset(
          'assets/menu.svg',
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        onPressed: () {
          // Open the menu
        },
      ),
      titleSpacing:
          0.0, // Remove the default spacing between the title and leading icon
      title: Row(
        children: [
          const Text(
            'identa',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ],
      ),
      centerTitle: false, // Align the title to the left
      elevation: 0.0,
      backgroundColor: const Color(0xFF2D9CDB),
      toolbarHeight: kToolbarHeight + 16.0,
    );
  }
}
