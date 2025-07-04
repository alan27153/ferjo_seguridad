import 'package:flutter/material.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: const [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage("https://via.placeholder.com/150"),
        ),
        SizedBox(height: 16),
        Center(
          child: Text(
            "Juan Pérez",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 8),
        Center(child: Text("juanperez@email.com")),
        SizedBox(height: 20),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text("Editar perfil"),
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text("Configuración"),
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text("Cerrar sesión"),
        ),
      ],
    );
  }
}
