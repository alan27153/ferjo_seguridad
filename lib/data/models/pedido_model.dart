import 'package:cloud_firestore/cloud_firestore.dart';

class Pedido {
  final String id;
  final String usuarioId;
  final List<Map<String, dynamic>> items; // Lista de productos con cantidad y precio
  final double total;
  final DateTime fecha;
  final String estado; // Ejemplo: "pendiente", "enviado", "entregado"

  Pedido({
    required this.id,
    required this.usuarioId,
    required this.items,
    required this.total,
    required this.fecha,
    this.estado = 'pendiente',
  });

  // Crear instancia desde Firestore
  factory Pedido.fromMap(String id, Map<String, dynamic> data) {
    return Pedido(
      id: id,
      usuarioId: data['usuarioId'] ?? '',
      items: List<Map<String, dynamic>>.from(data['items'] ?? []),
      total: (data['total'] ?? 0).toDouble(),
      fecha: (data['fecha'] as Timestamp).toDate(),
      estado: data['estado'] ?? 'pendiente',
    );
  }

  // Convertir a mapa para subir a Firestore
  Map<String, dynamic> toMap() {
    return {
      'usuarioId': usuarioId,
      'items': items,
      'total': total,
      'fecha': Timestamp.fromDate(fecha),
      'estado': estado,
    };
  }
}
