class Categoria {
  final String id;
  final String nombre;
  final String descripcion;
  final String imagenUrl;

  Categoria({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.imagenUrl,
  });

  factory Categoria.fromMap(String id, Map<String, dynamic> data) {
    return Categoria(
      id: id,
      nombre: data['nombre'] ?? '',
      descripcion: data['descripcion'] ?? '',
      imagenUrl: data['imagenUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'imagenUrl': imagenUrl,
    };
  }
}
