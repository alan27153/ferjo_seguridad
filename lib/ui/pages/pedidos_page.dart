import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/widgets/cabecera_app.dart';
import 'package:flutter_application_1/ui/widgets/pie_navegacion.dart';
import 'pagina_principal.dart';
import 'categorias_page.dart';
import 'carrito_page.dart';
import 'perfil_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/data/dao/pedido_dao.dart';
import 'package:flutter_application_1/data/models/pedido_model.dart';

class PedidosPage extends StatefulWidget {
  const PedidosPage({super.key});

  @override
  State<PedidosPage> createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  final PedidoDAO pedidoDAO = PedidoDAO();
  List<Pedido> pedidos = [];
  bool cargando = true;
  String? usuarioId;

  @override
  void initState() {
    super.initState();
    cargarPedidos();
  }

  Future<void> cargarPedidos() async {
    final usuario = FirebaseAuth.instance.currentUser;
    if (usuario == null) {
      setState(() {
        pedidos = [];
        cargando = false;
      });
      return;
    }
    usuarioId = usuario.uid;

    try {
      final listaPedidos = await pedidoDAO.obtenerPedidosPorUsuario(usuarioId!);
      setState(() {
        pedidos = listaPedidos;
        cargando = false;
      });
    } catch (e) {
      setState(() {
        pedidos = [];
        cargando = false;
      });
      print("Error al cargar pedidos: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CabeceraApp(titulo: 'Mis Pedidos'),
      ),
      bottomNavigationBar: PieNavegacion(
        indiceActual: 3,
        onTap: (index) {
          if (index == 3) return;

          Widget destino;
          switch (index) {
            case 0:
              destino = const PaginaPrincipal();
              break;
            case 1:
              destino = const CategoriasPage();
              break;
            case 2:
              destino = const CarritoPage();
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
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : pedidos.isEmpty
              ? const Center(
                  child: Text("No tienes pedidos realizados."),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: pedidos.length,
                  itemBuilder: (context, index) {
                    final pedido = pedidos[index];
                    final String id = pedido.id;
                    final String fecha = "${pedido.fecha.day.toString().padLeft(2, '0')}-${pedido.fecha.month.toString().padLeft(2, '0')}-${pedido.fecha.year}";
                    final String estado = pedido.estado;
                    final double total = pedido.total;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.receipt_long),
                        title: Text("Pedido #$id"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Fecha: $fecha"),
                            Text("Estado: $estado"),
                          ],
                        ),
                        trailing: Text(
                          "S/ ${total.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
