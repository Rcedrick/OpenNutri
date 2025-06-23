import 'nutriscoreData.dart';

class Product {
  final String name;
  final String code;
  final String quantity;
  final String unity;
  final String imageUrl;
  final String nutriscore;
  final double energy;
  final double fat;
  final double carbohydrates;
  final double proteins;
  final double sugars;
  final NutriscoreData? nutriscoreData;
  final String? ingredientsText;

  Product({
    required this.name,
    required this.code,
    required this.quantity,
    required this.unity,
    required this.imageUrl,
    required this.nutriscore,
    required this.energy,
    required this.fat,
    required this.carbohydrates,
    required this.proteins,
    required this.sugars,
    this.nutriscoreData,
    this.ingredientsText,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final nutriments = json['nutriments'] ?? {};
    return Product(
      name: json['product_name'] ?? 'Produit inconnu',
      code: json['code'] ?? '',
      quantity: json['product_quantity'],
      unity: json['product_quantity_unit'],
      imageUrl: json['image_url'] ?? '',
      nutriscore: json['nutriscore_grade'] ?? 'n',
      energy: (json['nutriments']?['energy-kcal_100g'] ?? 0).toDouble(),
      fat: (nutriments['fat_100g'] ?? 0).toDouble(),
      carbohydrates: (nutriments['carbohydrates_100g'] ?? 0).toDouble(),
      proteins: (nutriments['proteins_100g'] ?? 0).toDouble(),
      sugars: (nutriments['sugars_100g'] ?? 0).toDouble(),
      nutriscoreData: json['nutriscore_data'] != null
          ? NutriscoreData.fromJson(json['nutriscore_data'])
          : null,
      ingredientsText: json['ingredients_text'],
    );
  }
}
