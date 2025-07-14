import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pedido_model.dart';

class PedidoDAO {
  final CollectionReference _pedidosRef =
      FirebaseFirestore.instance.collection('pedidos');

  // Crear un nuevo pedido
  Future<void> crearPedido(Pedido pedido) async {
    await _pedidosRef.doc(pedido.id).set(pedido.toMap());
  }

  // Obtener pedidos por usuario
  Future<List<Pedido>> obtenerPedidosPorUsuario(String usuarioId) async {
    final query = await _pedidosRef
        .where('usuarioId', isEqualTo: usuarioId)
        .orderBy('fecha', descending: true)
        .get();

    return query.docs
        .map((doc) => Pedido.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Obtener pedido por ID
  Future<Pedido?> obtenerPorId(String pedidoId) async {
    final doc = await _pedidosRef.doc(pedidoId).get();
    if (doc.exists) {
      return Pedido.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Actualizar estado de un pedido
  Future<void> actualizarEstado(String pedidoId, String nuevoEstado) async {
    await _pedidosRef.doc(pedidoId).update({'estado': nuevoEstado});
  }

  // Eliminar un pedido (opcional, si decides permitirlo)
  Future<void> eliminarPedido(String pedidoId) async {
    await _pedidosRef.doc(pedidoId).delete();
  }
}
