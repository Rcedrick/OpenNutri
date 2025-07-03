import 'package:flutter/material.dart';
import '../models/product.dart';
import 'product_detail_page.dart';

class HistoryPage extends StatelessWidget {
  final List<Product> history;

  const HistoryPage({required this.history, super.key});

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const Center(
        child: Text(
          'Aucun produit scanné.',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      itemCount: history.length,
      itemBuilder: (context, index) {
        final product = history[index];
        return ListTile(
          leading: Image.network(
            product.imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          title: Text(product.name),
          subtitle: Text('${product.energy.toStringAsFixed(0)} kcal'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailPage(product: product),
              ),
            );
          },
        );
      },
    );
  }
}
