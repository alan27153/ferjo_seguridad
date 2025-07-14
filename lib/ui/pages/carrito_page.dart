import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/widgets/cabecera_app.dart';
import 'package:flutter_application_1/ui/widgets/pie_navegacion.dart';
import 'pagina_principal.dart';
import 'categorias_page.dart';
import 'pedidos_page.dart';
import 'perfil_page.dart';
import 'package:url_launcher/url_launcher.dart';

class CarritoPage extends StatelessWidget {
  const CarritoPage({super.key});

  Future<void> _eliminarItem(String usuarioId, String productoId) async {
    await FirebaseFirestore.instance
        .collection("carritos")
        .doc(usuarioId)
        .collection("items")
        .doc(productoId)
        .delete();
  }

  Future<void> _vaciarCarrito(String usuarioId) async {
    final itemsRef = FirebaseFirestore.instance
        .collection("carritos")
        .doc(usuarioId)
        .collection("items");

    final snapshot = await itemsRef.get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> _realizarPedido(BuildContext context, String usuarioId) async {
    final itemsRef = FirebaseFirestore.instance
        .collection("carritos")
        .doc(usuarioId)
        .collection("items");

    final snapshot = await itemsRef.get();

    if (snapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tu carrito está vacío")),
      );
      return;
    }

    final mensaje = StringBuffer("Hola, quiero realizar el siguiente pedido:\n");
    for (var doc in snapshot.docs) {
      final data = doc.data();
      mensaje.writeln("- ${data["nombreProducto"]} x${data["cantidad"]}");
    }

    const numero = "51964226073";
    final url = Uri.parse("https://wa.me/$numero?text=${Uri.encodeComponent(mensaje.toString())}");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se pudo abrir WhatsApp")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuarioId = FirebaseAuth.instance.currentUser?.uid;

    if (usuarioId == null) {
      return const Scaffold(
        body: Center(child: Text("Usuario no autenticado")),
      );
    }

    final carritoRef = FirebaseFirestore.instance
        .collection("carritos")
        .doc(usuarioId)
        .collection("items");

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CabeceraApp(titulo: "Mi Carrito"),
      ),
      bottomNavigationBar: PieNavegacion(
        indiceActual: 2,
        onTap: (index) {
          if (index == 2) return;

          Widget destino;
          switch (index) {
            case 0:
              destino = const PaginaPrincipal();
              break;
            case 1:
              destino = const CategoriasPage();
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
        stream: carritoRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Tu carrito está vacío."));
          }

          final items = snapshot.data!.docs;
          double total = 0;
          for (var item in items) {
            final cantidad = item["cantidad"] ?? 1;
            final precio = (item["precioUnitario"] ?? 0).toDouble();
            total += cantidad * precio;
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final nombre = item["nombreProducto"] ?? "Sin nombre";
                    final imagenUrl = item["imagenUrl"] ?? "";
                    final cantidad = item["cantidad"] ?? 1;
                    final precio = (item["precioUnitario"] ?? 0).toDouble();
                    final productoId = item["productoId"];
                    final totalItem = cantidad * precio;

                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(8),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            imagenUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image_not_supported),
                          ),
                        ),
                        title: Text(nombre),
                        subtitle: Text("Cantidad: $cantidad\nTotal: S/ ${totalItem.toStringAsFixed(2)}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => _eliminarItem(usuarioId, productoId),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Total: S/ ${total.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => _realizarPedido(context, usuarioId),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text("Realizar pedido por WhatsApp"),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("¿Vaciar carrito?"),
                            content: const Text("¿Estás seguro de eliminar todos los productos del carrito?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Cancelar"),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text("Vaciar"),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await _vaciarCarrito(usuarioId);
                        }
                      },
                      child: const Text("Vaciar carrito"),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
