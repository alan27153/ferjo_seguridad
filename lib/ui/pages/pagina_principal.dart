import 'package:flutter/material.dart';
import '../widgets/cabecera_app.dart';
import '../widgets/pie_navegacion.dart';

import 'categorias_page.dart' as categorias;
import 'carrito_page.dart' as carrito;
import 'pedidos_page.dart' as pedidos;
import 'perfil_page.dart' as perfil;

class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({super.key});

  @override
  State<PaginaPrincipal> createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  int _indiceActual = 0;

  final List<String> _titulos = const [
    "Inicio",
    "Categorías",
    "Carrito",
    "Pedidos",
    "Perfil",
  ];

  final List<Widget> _paginas = [];

  @override
  void initState() {
    super.initState();
    _paginas.addAll([
      _buildInicio(), // Vista de inicio
      const categorias.CategoriasPage(),
      const carrito.CarritoPage(),
      const pedidos.PedidosPage(),
      const perfil.PerfilPage(),
    ]);
  }

  Widget _buildInicio() {
    final List<Map<String, dynamic>> productos = [
      {
        "name": "Zapatillas Urbanas",
        "imageUrl":
            "https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=150&q=80",
        "originalPrice": 180.0,
        "discountPrice": 120.0,
      },
      {
        "name": "Audífonos Bluetooth",
        "imageUrl":
            "https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=150&q=80",
        "originalPrice": 150.0,
        "discountPrice": 99.0,
      },
      {
        "name": "Polera Oversize",
        "imageUrl":
            "https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=150&q=80",
        "originalPrice": 100.0,
        "discountPrice": 75.0,
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Productos en rebaja",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: productos.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final product = productos[index];
                final String name = product["name"] as String;
                final String imageUrl = product["imageUrl"] as String;
                final double originalPrice = product["originalPrice"] as double;
                final double discountPrice = product["discountPrice"] as double;
                final double discountPercent =
                    ((originalPrice - discountPrice) / originalPrice) * 100;

                return Card(
                  elevation: 3,
                  child: ListTile(
                    leading: Image.network(
                      imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                    title: Text(name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Antes: S/ ${originalPrice.toStringAsFixed(2)}",
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "Ahora: S/ ${discountPrice.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        Text(
                          "${discountPercent.toStringAsFixed(0)}% OFF",
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Acción al hacer tap (opcional)
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CabeceraApp(titulo: _titulos[_indiceActual]),
      body: _paginas[_indiceActual],
      bottomNavigationBar: PieNavegacion(
        indiceActual: _indiceActual,
        onTap: (index) {
          setState(() {
            _indiceActual = index;
          });
        },
      ),
    );
  }
}
