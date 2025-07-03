import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_nutri/pages/authentification/signin_page.dart';
import '../controllers/product_controller.dart';
import '../models/product.dart';
import 'product_detail_page.dart';
import 'scanner_page.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _controller = ProductController();
  final _searchController = TextEditingController();
  Product? _product;

  void _openScanner() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ScannerPage(
            onScanned: (code) async {
              final result = await _controller.getProductByCode(code);
              setState(() {
                _product = result;
              });
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Permission caméra refusée")),
      );
    }
  }

  void singUserOut(){
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SignInPage(),
      ),
    );
  }

  void _searchProduct() async {
    final code = _searchController.text;
    final result = await _controller.getProductByCode(code);
    setState(() {
      _product = result;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.purple.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ElevatedButton.icon(
                onPressed: _openScanner,
                icon: Icon(Icons.qr_code_scanner),
                label: Text('Scanner un produit'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Entrez le code-barres',
                  fillColor: Colors.white,
                  filled: true,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: _searchProduct,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              _product != null
                  ? ListTile(
                tileColor: Colors.white.withOpacity(0.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                leading: Image.network(_product!.imageUrl),
                title: Text(_product!.name, style: TextStyle(color: Colors.white)),
                subtitle: Text(
                  "Nutri-Score: ${_product!.nutriscore.toUpperCase()}",
                  style: TextStyle(color: Colors.white70),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailPage(product: _product!),
                    ),
                  );
                },
              )
                  : Text("Aucun produit trouvé", style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
