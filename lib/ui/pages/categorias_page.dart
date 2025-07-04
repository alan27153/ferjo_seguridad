import 'package:flutter/material.dart';

class CategoriasPage extends StatelessWidget {
  const CategoriasPage({super.key});

  final List<Map<String, String>> categorias = const [
    {
      "title": "Tecnología",
      "image": "https://cdn-icons-png.flaticon.com/512/1006/1006540.png",
    },
    {
      "title": "Moda",
      "image": "https://cdn-icons-png.flaticon.com/512/892/892458.png",
    },
    {
      "title": "Hogar",
      "image": "https://cdn-icons-png.flaticon.com/512/3062/3062634.png",
    },
    {
      "title": "Deportes",
      "image": "https://cdn-icons-png.flaticon.com/512/1042/1042330.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(16.0),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: categorias.map((categoria) {
        final String title = categoria["title"] ?? "Sin título";
        final String image = categoria["image"] ?? "";

        return Card(
          elevation: 4,
          child: InkWell(
            onTap: () {
              // Navegación futura
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  image,
                  height: 60,
                  width: 60,
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
