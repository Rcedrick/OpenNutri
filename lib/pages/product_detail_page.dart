import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  ProductDetailPage({required this.product});

  @override
  Widget build(BuildContext context) {
    final nutriscore = product.nutriscoreData;
    final double carbs = product.carbohydrates;
    final double protein = product.proteins;
    final double fat = product.fat;
    final double total = carbs + protein + fat;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade700, Colors.purple.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
        title: Text(product.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
        ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image du produit
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                product.imageUrl,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            // Nom + kcal
            Text(
              product.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              (product.quantity +' '+product.unity),
              style: TextStyle(fontSize: 20, color: Colors.white70),
            ),
            Text(
              '${product.energy.toStringAsFixed(0)} kcal',
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
            const SizedBox(height: 20),

            // Macros breakdown
            if (nutriscore != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMacroCircle("Carbs", carbs, Colors.blue, (carbs/total)*100),
                    _buildMacroCircle("Protein", protein, Colors.purple, (protein/total)*100),
                    _buildMacroCircle("Fat", fat, Colors.orange, (fat/total)*100),
                  ],
                ),
              ),

            const SizedBox(height: 30),

            // Liste des ingrédients (placeholder ici)
            if (product.ingredientsText != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Ingrédients", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 10),
                    Text(
                      product.ingredientsText!,
                      style: TextStyle(color: Colors.white70),
                    ),
                    Text(
                      (product.quantity +' '+product.unity),
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),

            /*Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Ingredients", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildIngredientBox("Tuna", 150, "100g", Colors.pink.shade100),
                      _buildIngredientBox("Eggs", 140, "2 eggs", Colors.yellow.shade100),
                      _buildIngredientBox("Olives", 45, "20g", Colors.green.shade100),
                    ],
                  ),
                ],
              ),
            ),
            */
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildMacroCircle(String label, double value, Color color, double percentage) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: CircularProgressIndicator(
                value: percentage/100,
                backgroundColor: color.withOpacity(0.2),
                color: color,
                strokeWidth: 6,
              ),
            ),
            Text(
              '${value} g',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(label, style: TextStyle(color: Colors.white70)),
        Text('${percentage.toStringAsFixed(0)} %', style: TextStyle(color: Colors.white38)),
      ],
    );
  }

  Widget _buildIngredientBox(String name, int kcal, String amount, Color bgColor) {
    return Container(
      width: 90,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text('$kcal kcal', style: TextStyle(fontSize: 12)),
          Text(amount, style: TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
    );
  }
}
