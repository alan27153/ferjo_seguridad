import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/producto_model.dart';

class ProductoDAO {
  final CollectionReference _productosRef =
      FirebaseFirestore.instance.collection('productos');

  // Guardar o actualizar un producto
  Future<void> guardarProducto(Producto producto) async {
    await _productosRef.doc(producto.id).set(producto.toMap());
  }

  // Obtener todos los productos
  Future<List<Producto>> obtenerTodos() async {
    final querySnapshot = await _productosRef.get();
    return querySnapshot.docs
        .map((doc) => Producto.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Obtener productos por categoría
  Future<List<Producto>> obtenerPorCategoria(String categoriaId) async {
    final querySnapshot = await _productosRef
        .where('categoriaId', isEqualTo: categoriaId)
        .get();

    return querySnapshot.docs
        .map((doc) => Producto.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Obtener un producto por ID
  Future<Producto?> obtenerPorId(String id) async {
    final doc = await _productosRef.doc(id).get();
    if (doc.exists) {
      return Producto.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Eliminar producto
  Future<void> eliminarProducto(String id) async {
    await _productosRef.doc(id).delete();
  }
}
