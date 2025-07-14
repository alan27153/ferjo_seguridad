class CarritoItem {
  final String id; // ID del documento del ítem en el carrito
  final String productoId;
  final String nombreProducto;
  final String imagenUrl;
  final int cantidad;
  final double precioUnitario;

  CarritoItem({
    required this.id,
    required this.productoId,
    required this.nombreProducto,
    required this.imagenUrl,
    required this.cantidad,
    required this.precioUnitario,
  });

  double get subtotal => cantidad * precioUnitario;

  factory CarritoItem.fromMap(String id, Map<String, dynamic> data) {
    return CarritoItem(
      id: id,
      productoId: data['productoId'] ?? '',
      nombreProducto: data['nombreProducto'] ?? '',
      imagenUrl: data['imagenUrl'] ?? '',
      cantidad: data['cantidad'] ?? 1,
      precioUnitario: (data['precioUnitario'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productoId': productoId,
      'nombreProducto': nombreProducto,
      'imagenUrl': imagenUrl,
      'cantidad': cantidad,
      'precioUnitario': precioUnitario,
    };
  }
}
