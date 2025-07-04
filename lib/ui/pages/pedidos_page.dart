import 'package:flutter/material.dart';

class PedidosPage extends StatelessWidget {
  const PedidosPage({super.key});

  final List<Map<String, dynamic>> pedidos = const [
    {
      "id": "PED001",
      "fecha": "2025-05-20",
      "total": 219.00,
      "estado": "Entregado"
    },
    {
      "id": "PED002",
      "fecha": "2025-05-18",
      "total": 99.00,
      "estado": "Pendiente"
    },
  ];

  @override
  Widget build(BuildContext context) {
    if (pedidos.isEmpty) {
      return const Center(
        child: Text("No tienes pedidos realizados."),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: pedidos.length,
      itemBuilder: (context, index) {
        final pedido = pedidos[index];
        final String id = pedido["id"] ?? "Sin ID";
        final String fecha = pedido["fecha"] ?? "Sin fecha";
        final String estado = pedido["estado"] ?? "Desconocido";
        final double total = (pedido["total"] ?? 0).toDouble();

        return Card(
          margin: const EdgeInsets.only(bottom: 12.0),
          elevation: 3,
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
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}
