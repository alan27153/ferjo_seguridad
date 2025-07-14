class Usuario {
  final String id;
  final String nombre;
  final String correo;

  Usuario({
    required this.id,
    required this.nombre,
    required this.correo,
  });

  // Crear instancia desde un mapa (por ejemplo, de Firestore)
  factory Usuario.fromMap(String id, Map<String, dynamic> data) {
    return Usuario(
      id: id,
      nombre: data['nombre'] ?? '',
      correo: data['correo'] ?? '',
    );
  }

  // Convertir a mapa para subir a Firestore
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'correo': correo,
    };
  }
}
