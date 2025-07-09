import 'package:flutter/material.dart';
import '../controllers/product_controller.dart';
import '../models/product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/customise_utils.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool _isLiked = false;
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final _controller = ProductController();


  @override
  void initState() {
    super.initState();
    _checkIfLiked();
    _controller.addToHistory(widget.product);
  }

  Future<void> _checkIfLiked() async {
    if (uid == null) return;

    final likeRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('like')
        .doc(widget.product.code);

    final doc = await likeRef.get();

    setState(() {
      _isLiked = doc.exists;
    });
  }

  Future<void> _toggleLike() async {
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vous devez être connecté pour liker un produit.")),
      );
      return;
    }

    final likeRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('like')
        .doc(widget.product.code);

    final doc = await likeRef.get();

    if (doc.exists) {
      await likeRef.delete();
      setState(() {
        _isLiked = false;
      });
      showCustomSnackBar(context, "Produit retiré aux favoris.");
    } else {
      await likeRef.set({
        'name': widget.product.name,
        'code': widget.product.code,
        'imageUrl': widget.product.imageUrl,
        'nutriscore': widget.product.nutriscore,
        'timestamp': FieldValue.serverTimestamp(),
      });
      setState(() {
        _isLiked = true;
      });
      showCustomSnackBar(context, "Produit ajouté aux favoris.");
    }
  }


  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return DefaultTabController(
      length: 3,
      child: Container(
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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(
                  _isLiked ? Icons.favorite : Icons.favorite_border,
                  color: Colors.purple,
                ),
                onPressed: _toggleLike,
              )
            ],
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Aperçu'),
                Tab(text: 'Ingrédients'),
                Tab(text: 'Nutrition'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _buildApercuTab(product),
              _buildIngredientsTab(product, context),
              _buildNutritionTab(product),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildApercuTab(Product product) {
    final double carbs = product.carbohydrates;
    final double protein = product.proteins;
    final double fat = product.fat;
    final double total = carbs + protein + fat;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          _buildSectionTitle("Nom commercial"),
          Text(product.name, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 10),
          _buildSectionTitle("Marque(s)"),
          Text(product.brands ?? 'Non renseigné', style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 10),
          _buildSectionTitle("Poids / Quantité"),
          Text('${product.quantity} ${product.unity}', style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 10),
          _buildSectionTitle("Code-barres"),
          Text(product.code, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 10),
          _buildSectionTitle("Fabricant"),
          Text(product.producer ?? 'Non renseigné', style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBadge('Nutri-Score', product.nutriscore.toUpperCase()),
              _buildBadge('Nova Group', product.novaGroup?.toString() ?? '-'),
              _buildBadge('Eco-Score', (product.ecoscoreGrade ?? 'n/a').toUpperCase()),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMacroCircle("Carbs", carbs, Colors.blue, total == 0 ? 0 : (carbs / total) * 100),
              _buildMacroCircle("Protein", protein, Colors.green, total == 0 ? 0 : (protein / total) * 100),
              _buildMacroCircle("Fat", fat, Colors.orange, total == 0 ? 0 : (fat / total) * 100),
            ],
          ),
          const SizedBox(height: 20),
          _buildSectionTitle("Labels"),
          Text(product.labels ?? 'Non renseigné', style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 10),
          ExpansionTile(
            collapsedIconColor: Colors.white,
            iconColor: Colors.white,
            title: const Text("Pays de commercialisation", style: TextStyle(color: Colors.white)),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(product.countries ?? 'Non renseigné', style: const TextStyle(color: Colors.white70)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ExpansionTile(
            collapsedIconColor: Colors.white,
            iconColor: Colors.white,
            title: const Text("Catégories", style: TextStyle(color: Colors.white)),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(product.categories ?? 'Non renseigné', style: const TextStyle(color: Colors.white70)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsTab(Product product, BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Composition détaillée"),
          const SizedBox(height: 10),
          Table(
            border: TableBorder.all(color: Colors.white),
            columnWidths: const {
              0: FlexColumnWidth(3),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(1),
            },
            children: [
              const TableRow(
                decoration: BoxDecoration(color: Colors.white24),
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text('Ingrédient', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text('Vegan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text('Palm Oil', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text('Additif', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text('E-num', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              ...?product.ingredients?.map((ingredient) {
                return TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text(ingredient.text),
                              content: const Text('Plus de détails à venir ici...'),
                              actions: [
                                TextButton(
                                  child: const Text('Fermer'),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text(ingredient.text, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(ingredient.vegan ?? '-', style: const TextStyle(color: Colors.white70)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(ingredient.fromPalmOil ?? '-', style: const TextStyle(color: Colors.white70)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(ingredient.additive ?? '-', style: const TextStyle(color: Colors.white70)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(ingredient.eNumber ?? '-', style: const TextStyle(color: Colors.white70)),
                    ),
                  ],
                );
              }).toList(),
            ],
          ),
          const SizedBox(height: 20),
          _buildSectionTitle("Présence OGM"),
          Text(product.gmo ?? 'Non renseigné', style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 20),
          _buildSectionTitle("Traces possibles"),
          Text(product.traces ?? 'Non renseigné', style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildNutritionTab(Product product) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Nutrition pour 100g"),
          _buildNutritionLine("Énergie", "${product.energyKcal} kcal"),
          _buildNutritionLine("Matières grasses", "${product.fat} g"),
          _buildNutritionLine("Graisses saturées", "${product.saturatedFat} g"),
          _buildNutritionLine("Glucides", "${product.carbohydrates} g"),
          _buildNutritionLine("Sucres", "${product.sugars} g"),
          _buildNutritionLine("Protéines", "${product.proteins} g"),
          _buildNutritionLine("Sel", "${product.salt} g"),
          _buildNutritionLine("Sodium", "${product.sodium} g"),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        Text('${percentage.toStringAsFixed(0)} %', style: const TextStyle(color: Colors.white38, fontSize: 12)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  Widget _buildNutritionLine(String name, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: const TextStyle(color: Colors.white70)),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
