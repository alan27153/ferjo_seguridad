import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'data/services/firebase_service.dart';

import 'app/theme/app_theme.dart';
import 'ui/pages/pagina_principal.dart'; // Página principal

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Tienda',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const PaginaPrincipal(), // Ya no se usan rutas aquí
    );
  }
}
