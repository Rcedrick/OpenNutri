import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_nutri/pages/product_detail_page.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../utils/customise_utils.dart';

class HomePage extends StatelessWidget {
  final Function(int) onMenuTap;
  const HomePage({super.key, required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBanner(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  _buildSectionTitle("Actions à faire"),
                  _buildActions(context),
                  const SizedBox(height: 20),
                  _buildSectionTitle("Produits à découvrir"),
                  _buildFeaturedProducts(context),
                  const SizedBox(height: 20),
                  _buildSectionTitle("Astuces & Actus"),
                  _buildTips(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
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

        Positioned(
          top: 30,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Open Nutri",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }

  Widget _buildActions(BuildContext context) {
    final actions = [
      {
        "label": "Scan",
        "icon": Icons.qr_code_scanner,
        "onTap": () {
          onMenuTap(2);
        },
      },
      {
        "label": "Recherche",
        "icon": Icons.search,
        "onTap": () {
          onMenuTap(2);
        },
      },
      {
        "label": "Favoris",
        "icon": Icons.favorite,
        "onTap": () {
          onMenuTap(1);
        },
      },
      {
        "label": "Historique",
        "icon": Icons.history,
        "onTap": () {
          onMenuTap(3);
        },
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 4,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1,
        physics: const NeverScrollableScrollPhysics(),
        children: actions.map((action) {
          return GestureDetector(
            onTap: action["onTap"] as void Function()?,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    action["icon"] as IconData,
                    size: 40,
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    action["label"] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }


  Widget _buildFeaturedProducts(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: ProductService.fetchFeaturedProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Erreur : ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('Aucun produit trouvé.');
        } else {
          final products = snapshot.data!;
          return SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () async {
                    final fullProduct = await ProductService.fetchProductByCode(product.code);
                    if (fullProduct != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailPage(product: fullProduct),
                        ),
                      );
                    } else {
                      showCustomSnackBar(context, "Impossible de charger le produit");
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    margin: const EdgeInsets.only(right: 10),
                    child: Card(
                      child: Column(
                        children: [
                          Expanded(
                            child: product.imageUrl.isNotEmpty
                                ? Image.network(
                              product.imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            )
                                : const Icon(Icons.image_not_supported),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }


  Widget _buildTips() {
    final tips = [
      {
        "title": " Bien lire les étiquettes",
        "content": """
Prendre le temps de lire les étiquettes permet de mieux contrôler ce que l’on mange.
• Vérifiez la liste des ingrédients : le premier est celui présent en plus grande quantité.
• Surveillez les additifs, allergènes et sucres ajoutés.
• Comparez les valeurs nutritionnelles pour choisir le produit le plus sain.
"""
      },
      {
        "title": " Choisir Bio, pourquoi ?",
        "content": """
Les produits bio sont cultivés sans pesticides chimiques de synthèse ni OGM.
• Ils respectent l’environnement et la biodiversité.
• Ils soutiennent une agriculture plus durable.
• Ils contiennent souvent moins de résidus chimiques.
"""
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...tips.map((tip) {
          return Card(
            child: ExpansionTile(
              leading: const Icon(Icons.lightbulb, color: Colors.yellow),
              title: Text(
                tip['title']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    tip['content']!,
                    style: const TextStyle(color: Colors.black87),
                  ),
                ),
              ],
            ),
          );
        }).toList(),

        const SizedBox(height: 30),

        const Text(
          "À propos de cette application",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Cette application vous aide à scanner, comprendre et comparer vos produits alimentaires "
              "pour faire des choix plus sains et responsables au quotidien.\n"
              "Informations, conseils et astuces sont mis à votre disposition pour mieux consommer.",
          style: TextStyle(color: Colors.black87, height: 1.4),
        ),
      ],
    );
  }

}
