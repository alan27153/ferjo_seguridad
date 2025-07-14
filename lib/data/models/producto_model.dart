class Producto {
  final String id;
  final String nombre;
  final String descripcion;
  final double precio;
  final String imagenUrl;
  final String categoriaId; // ID de la categoría
  final bool disponible;

  Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.imagenUrl,
    required this.categoriaId,
    this.disponible = true,
  });

  // Convertir desde Firestore
  factory Producto.fromMap(String id, Map<String, dynamic> data) {
    return Producto(
      id: id,
      nombre: data['nombre'] ?? '',
      descripcion: data['descripcion'] ?? '',
      precio: (data['precio'] ?? 0).toDouble(),
      imagenUrl: data['imagenUrl'] ?? '',
      categoriaId: data['categoriaId'] ?? '',
      disponible: data['disponible'] ?? true,
    );
  }

  // Convertir a mapa para guardar en Firestore
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'imagenUrl': imagenUrl,
      'categoriaId': categoriaId,
      'disponible': disponible,
    };
  }
}
