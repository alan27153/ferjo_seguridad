import 'package:flutter/material.dart';
import '../../ui/pages/pagina_principal.dart';
import '../../ui/pages/categorias_page.dart';
import '../../ui/pages/carrito_page.dart';
import '../../ui/pages/pedidos_page.dart';
import '../../ui/pages/perfil_page.dart';
import '../../ui/pages/registro_page.dart'; // ✅ Importación añadida

class AppRoutes {
  static const String principal = '/';
  static const String categorias = '/categorias';
  static const String carrito = '/carrito';
  static const String pedidos = '/pedidos';
  static const String perfil = '/perfil';
  static const String registro = '/registro'; // ✅ Ruta añadida

  static Map<String, WidgetBuilder> get routes => {
        principal: (context) => const PaginaPrincipal(),
        categorias: (context) => const CategoriasPage(),
        carrito: (context) => const CarritoPage(),
        pedidos: (context) => const PedidosPage(),
        perfil: (context) => const PerfilPage(),
        registro: (context) => const RegistroPage(), // ✅ Registro añadido
      };
}
