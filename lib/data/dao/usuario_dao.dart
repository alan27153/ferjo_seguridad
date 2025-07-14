import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario_model.dart';

class UsuarioDAO {
  final CollectionReference _usuariosRef =
      FirebaseFirestore.instance.collection('usuarios');

  // Crear o actualizar usuario
  Future<void> guardarUsuario(Usuario usuario) async {
    await _usuariosRef.doc(usuario.id).set(usuario.toMap());
  }

  // Obtener usuario por ID
  Future<Usuario?> obtenerUsuarioPorId(String id) async {
    final doc = await _usuariosRef.doc(id).get();
    if (doc.exists) {
      return Usuario.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Verificar si un usuario existe
  Future<bool> existeUsuario(String id) async {
    final doc = await _usuariosRef.doc(id).get();
    return doc.exists;
  }
}
