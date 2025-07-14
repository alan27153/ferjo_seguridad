import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'pagina_principal.dart';
import 'carrito_page.dart';
import 'pedidos_page.dart';
import 'perfil_page.dart';
import 'package:flutter_application_1/ui/widgets/pie_navegacion.dart';
import 'package:flutter_application_1/ui/widgets/cabecera_app.dart';

class ProductoSeleccionadoPage extends StatelessWidget {
  final String productoId;

  const ProductoSeleccionadoPage({super.key, required this.productoId});

  Future<void> _agregarAlCarrito(
    BuildContext context,
    String productoId,
    String nombreProducto,
    String imagenUrl,
    double precioUnitario,
  ) async {
    try {
      final usuarioId = FirebaseAuth.instance.currentUser?.uid;

      if (usuarioId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Usuario no autenticado")),
        );
        return;
      }

      final itemRef = FirebaseFirestore.instance
          .collection("carritos")
          .doc(usuarioId)
          .collection("items")
          .doc(productoId);

      final item = await itemRef.get();

      if (item.exists) {
        await itemRef.update({
          "cantidad": FieldValue.increment(1),
        });
      } else {
        await itemRef.set({
          "productoId": productoId,
          "nombreProducto": nombreProducto,
          "imagenUrl": imagenUrl,
          "cantidad": 1,
          "precioUnitario": precioUnitario,
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Producto añadido al carrito")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al añadir al carrito: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final productoRef =
        FirebaseFirestore.instance.collection("productos").doc(productoId);

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CabeceraApp(titulo: "Producto"),
      ),
      bottomNavigationBar: PieNavegacion(
        indiceActual: 0,
        onTap: (index) {
          Widget destino;
          switch (index) {
            case 0:
              destino = const PaginaPrincipal();
              break;
            case 1:
              Navigator.pop(context);
              return;
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
      body: FutureBuilder<DocumentSnapshot>(
        future: productoRef.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Producto no encontrado"));
          }

          final data = snapshot.data!;
          final nombre = data["nombre"] ?? "Sin nombre";
          final descripcion = data.data().toString().contains("descripcion") ? data["descripcion"] : "";
          final precio = (data["precio"] ?? 0).toDouble();
          final imagenUrl = data["imagenUrl"] ?? "";

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 1, // Imagen cuadrada
                    child: Image.network(
                      imagenUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 100),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  nombre,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  descripcion,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  "S/ ${precio.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    _agregarAlCarrito(context, productoId, nombre, imagenUrl, precio);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: const Text("Añadir al carrito"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
