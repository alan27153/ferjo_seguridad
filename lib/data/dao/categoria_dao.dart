import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/categoria_model.dart';

class CategoriaDAO {
  final CollectionReference _categoriasRef =
      FirebaseFirestore.instance.collection('categorias');

  // Crear o actualizar una categoría
  Future<void> guardarCategoria(Categoria categoria) async {
    await _categoriasRef.doc(categoria.id).set(categoria.toMap());
  }

  // Obtener todas las categorías
  Future<List<Categoria>> obtenerTodas() async {
    final snapshot = await _categoriasRef.get();
    return snapshot.docs
        .map((doc) => Categoria.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Obtener categoría por ID
  Future<Categoria?> obtenerPorId(String id) async {
    final doc = await _categoriasRef.doc(id).get();
    if (doc.exists) {
      return Categoria.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Eliminar categoría
  Future<void> eliminarCategoria(String id) async {
    await _categoriasRef.doc(id).delete();
  }
}
