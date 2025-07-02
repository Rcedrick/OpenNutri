import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  ProductDetailPage({required this.product});

  @override
  Widget build(BuildContext context) {
    final double carbs = product.carbohydrates;
    final double protein = product.proteins;
    final double fat = product.fat;
    final double total = carbs + protein + fat;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.purple.shade900],
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
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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

                // Nom + quantité
                Text(
                  product.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  '${product.quantity} ${product.unity}',
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),

                const SizedBox(height: 10),

                // NutriScore + Nova + EcoScore
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildBadge('Nutri-Score', product.nutriscore.toUpperCase()),
                    _buildBadge('Nova Group', product.novaGroup?.toString() ?? '-'),
                    _buildBadge('Eco-Score', (product.ecoscoreGrade ?? 'n/a').toUpperCase())
                  ],
                ),

                const SizedBox(height: 20),

                // Macros
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMacroCircle("Carbs", carbs, Colors.blue, total == 0 ? 0 : (carbs / total) * 100),
                    _buildMacroCircle("Protein", protein, Colors.green, total == 0 ? 0 : (protein / total) * 100),
                    _buildMacroCircle("Fat", fat, Colors.orange, total == 0 ? 0 : (fat / total) * 100),
                  ],
                ),

                const SizedBox(height: 30),

                // Labels, Countries, Categories
                _buildSectionTitle("Labels"),
                Text(product.labels ??'', style: TextStyle(color: Colors.white70)),

                const SizedBox(height: 10),
                _buildSectionTitle("Countries"),
                Text(product.countries??'', style: TextStyle(color: Colors.white70)),

                const SizedBox(height: 10),
                _buildSectionTitle("Categories"),
                Text(product.categories ??'', style: TextStyle(color: Colors.white70)),

                const SizedBox(height: 20),

                // Vegetarian
                _buildSectionTitle("Végétarien ?"),
                Text(product.vegetarian ?? 'Non renseigné', style: TextStyle(color: Colors.white70)),

                const SizedBox(height: 20),

                // Ingrédient
                _buildSectionTitle("Ingrédient principal"),
                Text(product.ingredientText ??'', style: TextStyle(color: Colors.white70)),

                const SizedBox(height: 20),

                // Allergènes
                _buildSectionTitle("Allergènes"),
                Text(product.allergens??'', style: TextStyle(color: Colors.white70)),

                const SizedBox(height: 30),

                // Nutrition détails
                _buildSectionTitle("Nutrition pour 100g"),
                _buildNutritionLine("Energie", "${product.energyKcal} kcal"),
                _buildNutritionLine("Matières grasses", "${product.fat} g"),
                _buildNutritionLine("Graisses saturées", "${product.saturatedFat} g"),
                _buildNutritionLine("Glucides", "${product.carbohydrates} g"),
                _buildNutritionLine("Sucres", "${product.sugars} g"),
                _buildNutritionLine("Protéines", "${product.proteins} g"),
                _buildNutritionLine("Sel", "${product.salt} g"),
                _buildNutritionLine("Sodium", "${product.sodium} g"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 12)),
        Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(value, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
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
                value: percentage / 100,
                backgroundColor: color.withOpacity(0.2),
                color: color,
                strokeWidth: 6,
              ),
            ),
            Text(
              '${value.toStringAsFixed(1)} g',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 12)),
        Text('${percentage.toStringAsFixed(0)} %', style: TextStyle(color: Colors.white38, fontSize: 12)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  Widget _buildNutritionLine(String name, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: TextStyle(color: Colors.white70)),
          Text(value, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
