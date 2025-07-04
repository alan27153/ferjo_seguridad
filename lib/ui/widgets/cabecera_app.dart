import 'package:flutter/material.dart';

class CabeceraApp extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;

  const CabeceraApp({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(titulo),
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
