import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/widgets/cabecera_app.dart';
import 'package:flutter_application_1/ui/widgets/pie_navegacion.dart';
import 'pagina_principal.dart';
import 'categorias_page.dart';
import 'carrito_page.dart';
import 'pedidos_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_application_1/data/models/usuario_model.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController nuevaPassController = TextEditingController();
  final TextEditingController confirmarPassController = TextEditingController();

  Usuario? usuario;
  bool cargando = true;
  bool guardandoNombre = false;
  bool cambiandoPass = false;

  bool mostrarNuevaPass = false;
  bool mostrarConfirmarPass = false;

  @override
  void initState() {
    super.initState();
    cargarUsuario();
  }

  Future<void> cargarUsuario() async {
    final usuarioFirebase = FirebaseAuth.instance.currentUser;
    if (usuarioFirebase == null) {
      setState(() {
        cargando = false;
      });
      return;
    }

    final doc = await FirebaseFirestore.instance.collection('usuarios').doc(usuarioFirebase.uid).get();

    if (doc.exists) {
      usuario = Usuario.fromMap(doc.id, doc.data()!);
      nombreController.text = usuario!.nombre;
    }

    setState(() {
      cargando = false;
    });
  }

  Future<void> guardarNombre() async {
    final nuevoNombre = nombreController.text.trim();
    if (nuevoNombre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("El nombre no puede estar vacío")));
      return;
    }

    setState(() => guardandoNombre = true);

    try {
      final usuarioFirebase = FirebaseAuth.instance.currentUser!;
      await FirebaseFirestore.instance.collection('usuarios').doc(usuarioFirebase.uid).update({
        'nombre': nuevoNombre,
      });

      setState(() {
        usuario = Usuario(
          id: usuario!.id,
          nombre: nuevoNombre,
          correo: usuario!.correo,
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Nombre actualizado")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error al guardar: $e")));
    } finally {
      setState(() => guardandoNombre = false);
    }
  }

  Future<void> cambiarContrasena() async {
    final nuevaPass = nuevaPassController.text.trim();
    final confirmarPass = confirmarPassController.text.trim();

    if (nuevaPass.isEmpty || confirmarPass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Por favor completa ambos campos de contraseña")));
      return;
    }

    if (nuevaPass != confirmarPass) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Las contraseñas no coinciden")));
      return;
    }

    setState(() => cambiandoPass = true);

    try {
      await FirebaseAuth.instance.currentUser!.updatePassword(nuevaPass);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Contraseña actualizada con éxito")));
      nuevaPassController.clear();
      confirmarPassController.clear();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Por seguridad, vuelve a iniciar sesión para cambiar la contraseña")));
        // Aquí puedes agregar lógica para reautenticación si quieres
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.message}")));
      }
    } finally {
      setState(() => cambiandoPass = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CabeceraApp(titulo: 'Perfil'),
      ),
      bottomNavigationBar: PieNavegacion(
        indiceActual: 4,
        onTap: (index) {
          if (index == 4) return;

          Widget destino;
          switch (index) {
            case 0:
              destino = const PaginaPrincipal();
              break;
            case 1:
              destino = const CategoriasPage();
              break;
            case 2:
              destino = const CarritoPage();
              break;
            case 3:
              destino = const PedidosPage();
              break;
            default:
              return;
          }

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => destino),
          );
        },
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  TextFormField(
                    controller: nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: guardandoNombre ? null : guardarNombre,
                    child: guardandoNombre
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Guardar Nombre'),
                  ),
                  const Divider(height: 40),
                  TextFormField(
                    controller: nuevaPassController,
                    obscureText: !mostrarNuevaPass,
                    decoration: InputDecoration(
                      labelText: 'Nueva contraseña',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          mostrarNuevaPass ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            mostrarNuevaPass = !mostrarNuevaPass;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: confirmarPassController,
                    obscureText: !mostrarConfirmarPass,
                    decoration: InputDecoration(
                      labelText: 'Confirmar nueva contraseña',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          mostrarConfirmarPass ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            mostrarConfirmarPass = !mostrarConfirmarPass;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: cambiandoPass ? null : cambiarContrasena,
                    child: cambiandoPass
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Cambiar contraseña'),
                  ),
                ],
              ),
            ),
    );
  }
}
