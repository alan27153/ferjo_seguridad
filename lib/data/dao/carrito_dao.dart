import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/carrito_item_model.dart';

class CarritoDAO {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _carritoRef(String usuarioId) {
    return _db.collection('carritos').doc(usuarioId).collection('items');
  }

  // Agregar o actualizar un ítem al carrito
  Future<void> guardarItem(String usuarioId, CarritoItem item) async {
    await _carritoRef(usuarioId).doc(item.id).set(item.toMap());
  }

  // Obtener todos los ítems del carrito
  Future<List<CarritoItem>> obtenerItems(String usuarioId) async {
    final query = await _carritoRef(usuarioId).get();
    return query.docs
        .map((doc) => CarritoItem.fromMap(doc.id, doc.data()))
        .toList();
  }

  // Eliminar un ítem
  Future<void> eliminarItem(String usuarioId, String itemId) async {
    await _carritoRef(usuarioId).doc(itemId).delete();
  }

  // Vaciar carrito
  Future<void> vaciarCarrito(String usuarioId) async {
    final items = await _carritoRef(usuarioId).get();
    for (var doc in items.docs) {
      await doc.reference.delete();
    }
  }
}
