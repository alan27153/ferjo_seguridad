import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/pages/productos_por_categoria_page.dart';
import 'package:flutter_application_1/ui/widgets/cabecera_app.dart';
import 'package:flutter_application_1/ui/widgets/pie_navegacion.dart';
import 'pagina_principal.dart';
import 'carrito_page.dart';
import 'pedidos_page.dart';
import 'perfil_page.dart';

class CategoriasPage extends StatelessWidget {
  const CategoriasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CabeceraApp(titulo: "Categorías"),
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
        stream: FirebaseFirestore.instance.collection("categorias").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No hay categorías disponibles."));
          }

          final categorias = snapshot.data!.docs;

          return GridView.count(
            padding: const EdgeInsets.all(16.0),
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: categorias.map((doc) {
              final nombre = doc["nombre"] ?? "Sin nombre";
              final descripcion = doc["descripcion"] ?? "";
              final id = doc.id;

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductosPorCategoriaPage(
                          categoriaId: id,
                          nombreCategoria: nombre,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          nombre,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          descripcion,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
