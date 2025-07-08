import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../controllers/product_controller.dart';
import '../models/product.dart';
import '../pages/product_detail_page.dart';
import '../pages/scanner_page.dart';
import '../utils/customise_utils.dart';
import '../utils/loading_utils.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final _controller = ProductController();
  final _searchController = TextEditingController();

  List<Product> _products = [];

  void _openScanner() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      final scannedCode = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (_) => ScannerPage(
            onScanned: (code) async {
              Navigator.pop(context, code);
            },
          ),
        ),
      );

      if (scannedCode != null && scannedCode.isNotEmpty) {
        showLoading(context, message: "Chargement du produit...");
        final result = await _controller.getProductByCode(scannedCode);
        hideLoading(context);

        if (result != null) {
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailPage(product: result),
              ),
            );
          }
        } else {
          showCustomSnackBar(context, "Produit introuvable");
        }
      }

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permission caméra refusée")),
      );
    }
  }


  void _searchProduct() async {
    final name = _searchController.text.trim();
    if (name.isEmpty) return;
    showLoading(context, message: "Recherche en cours...");
    try {
      final result = await _controller.getProductsByName(name);
      setState(() {
        _products = result;
      });
    } finally {
      hideLoading(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar("Recherche & Scan Produits"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _openScanner,
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Scanner un produit'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Rechercher par nom',
                fillColor: Colors.white,
                filled: true,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchProduct,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _products.isEmpty
                  ? const Text(
                "Aucun produit trouvé",
                style: TextStyle(color: Colors.white),
              )
                  : ListView.builder(
                itemCount: _products.length,
                itemBuilder: (_, index) {
                  final product = _products[index];
                  return Card(
                    color: Colors.deepPurple.withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: product.imageUrl.isNotEmpty
                          ? Image.network(product.imageUrl, width: 50)
                          : const Icon(Icons.image_not_supported),
                      title: Text(
                        product.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        "Nutri-Score: ${product.nutriscore.toUpperCase()}",
                        style: const TextStyle(color: Colors.white70),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ProductDetailPage(product: product),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
