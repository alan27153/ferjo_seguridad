import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/models/producto_model.dart';
import 'package:flutter_application_1/data/dao/producto_dao.dart';

class InicioViewModel extends ChangeNotifier {
  final ProductoDAO _productoDAO = ProductoDAO();

  List<Producto> _productos = [];
  bool _cargando = true;
  String? _error;

  List<Producto> get productos => _productos;
  bool get cargando => _cargando;
  String? get error => _error;

  Future<void> cargarProductos() async {
    // No llamamos notifyListeners() aquí directamente
    _cargando = true;

    try {
      _productos = await _productoDAO.obtenerTodos();
      _error = null;
    } catch (e) {
      _error = 'Error al cargar productos';
      _productos = [];
    } finally {
      _cargando = false;
      notifyListeners(); // Notificamos una vez al final
    }
  }
}
