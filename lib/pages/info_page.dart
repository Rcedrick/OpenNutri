import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBanner(),
            const SizedBox(height: 20),
            _buildSectionTitle("Catégories populaires"),
            _buildCategories(context),
            const SizedBox(height: 20),
            _buildSectionTitle("Produits à découvrir"),
            _buildFeaturedProducts(context),
            const SizedBox(height: 20),
            _buildSectionTitle("Astuces & Actus"),
            _buildTips(),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Colors.purple, Colors.deepPurple],
        ),
      ),
      child: const Center(
        child: Text(
          "🌟 Informations nutrition & conseils",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }

  Widget _buildCategories(BuildContext context) {
    final categories = [
      "Snacks",
      "Boissons",
      "Bio",
      "Céréales",
      "Confiseries",
      "Surgelés",
      "Produits laitiers",
      "Fruits & Légumes",
      "Sauces & Condiments",
      "Viandes",
      "Poissons & Fruits de mer",
      "Vegan",
      "Sans gluten",
      "Produits locaux",
    ];
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (_, index) {
          return GestureDetector(
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.purple.shade100,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(categories[index],
                    style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500)),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedProducts(BuildContext context) {
    final products = ["Nutella", "Coca-Cola", "Kinder Bueno"];
    return Column(
      children: products.map((product) {
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            title: Text(product),
            subtitle: const Text("Clique pour plus d'infos"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(product),
                  content: const Text(
                      "Voici une description plus détaillée de ce produit."),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Fermer"))
                  ],
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTips() {
    final tips = [
      {
        "title": " Manger moins de sucre",
        "content": """
Réduire sa consommation de sucre est essentiel pour éviter le surpoids, le diabète et les caries dentaires. 
• Limitez les sodas et boissons sucrées.
• Préférez des fruits entiers aux jus industriels.
• Lisez bien l’étiquette : le sucre peut être caché sous des noms comme sirop de glucose, fructose ou saccharose.
"""
      },
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
