import 'package:flutter/material.dart';

class CarritoPage extends StatelessWidget {
  const CarritoPage({super.key});

  final List<Map<String, dynamic>> discountedProducts = const [
    {
      "name": "Zapatillas Urbanas",
      "imageUrl": "https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=150&q=80",
      "originalPrice": 180.0,
      "discountPrice": 120.0,
    },
    {
      "name": "Audífonos Bluetooth",
      "imageUrl": "https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=150&q=80",
      "originalPrice": 150.0,
      "discountPrice": 99.0,
    },
    {
      "name": "Polera Oversize",
      "imageUrl": "https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=150&q=80",
      "originalPrice": 100.0,
      "discountPrice": 75.0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Productos en el carrito",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: discountedProducts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final product = discountedProducts[index];
                final String name = product["name"] as String;
                final String imageUrl = product["imageUrl"] as String;
                final double original = product["originalPrice"] as double;
                final double discount = product["discountPrice"] as double;

                final double percent = ((original - discount) / original) * 100;

                return Card(
                  elevation: 3,
                  child: ListTile(
                    leading: Image.network(
                      imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                    title: Text(name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Antes: S/ ${original.toStringAsFixed(2)}",
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "Ahora: S/ ${discount.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        Text(
                          "${percent.toStringAsFixed(0)}% OFF",
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Navegar o editar el carrito
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
