import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/pages/producto_seleccionado_page.dart';
import 'package:flutter_application_1/ui/widgets/pie_navegacion.dart';
import 'pagina_principal.dart';
import 'categorias_page.dart';
import 'carrito_page.dart';
import 'pedidos_page.dart';
import 'perfil_page.dart';

class ProductosPorCategoriaPage extends StatelessWidget {
  final String categoriaId;
  final String nombreCategoria;

  const ProductosPorCategoriaPage({
    super.key,
    required this.categoriaId,
    required this.nombreCategoria,
  });

  @override
  Widget build(BuildContext context) {
    final productosRef = FirebaseFirestore.instance
        .collection("productos")
        .where("categoriaId", isEqualTo: categoriaId)
        .where("disponible", isEqualTo: true);

    return Scaffold(
      appBar: AppBar(
        title: Text(nombreCategoria),
      ),
      bottomNavigationBar: PieNavegacion(
        indiceActual: 1,
        onTap: (index) {
          if (index == 1) return;

          Widget destino;
          switch (index) {
            case 0:
              destino = const PaginaPrincipal();
              break;
            case 2:
              destino = const CarritoPage();
              break;
            case 3:
              destino = const PedidosPage();
              break;
            case 4:
              destino = const PerfilPage();
              break;
            default:
              return;
          }

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => destino),
          );
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: productosRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No hay productos en esta categoría."));
          }

          final productos = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 productos por fila
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.6,
            ),
            itemCount: productos.length,
            itemBuilder: (context, index) {
              final producto = productos[index];
              final nombre = producto["nombre"] ?? "Sin nombre";
              final precio = producto["precio"] ?? 0;
              final imagenUrl = producto["imagenUrl"] ?? "";
              final productoId = producto.id;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductoSeleccionadoPage(productoId: productoId),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.network(
                            imagenUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              nombre,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "S/ ${precio.toStringAsFixed(2)}",
                              style: const TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
