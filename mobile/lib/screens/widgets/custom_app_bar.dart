import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.screenTitle});
  final String screenTitle;

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        screenTitle,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
    );
  }
}
