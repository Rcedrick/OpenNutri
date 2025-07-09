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
      // On lance la page ScannerPage qui va renvoyer un String (code) quand on pop
      final scannedCode = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (_) => ScannerPage(
            onScanned: (code) async {
              // Ici, on NE fait PAS de Navigator.pop, c'est ScannerPage qui ferme la page
              return;
            },
          ),
        ),
      );

      // Une fois la page scanner fermée, on récupère le code scanné
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
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          // Bandeau violet
          Container(
            height: 80,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple, Colors.deepPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(40),
              ),
            ),
          ),

          // Carte titre centrée
          Positioned(
            top: 30,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  "Recherche & Scan Produits",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
            ),
          ),

          // Contenu principal sous la carte
          Padding(
            padding: const EdgeInsets.only(top: 140, left: 16, right: 16),
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
                    style: TextStyle(color: Colors.black),
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
        ],
      ),
    );
  }
}
