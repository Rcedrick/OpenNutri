import 'nutriscoreData.dart';
import 'ingredient.dart';

class Product {
  final String name;
  final String code;
  final String quantity;
  final String unity;
  final String imageUrl;
  final List<String>? additionalImages;
  final String nutriscore;
  final double energy;
  final double fat;
  final double carbohydrates;
  final double proteins;
  final double sugars;
  final NutriscoreData? nutriscoreData;
  final String? ingredientsText;
  final int? novaGroup;
  final String? ecoscoreGrade;
  final String? labels;
  final String? countries;
  final String? categories;
  final String? vegetarian;
  final String? ingredientText;
  final String? allergens;
  final double? energyKcal;
  final double? saturatedFat;
  final double? sodium;
  final double? salt;
  final String? brands;
  final String? manufacturingPlaces;
  final String? producer;
  final String? link;
  final String? origins;
  final String? lastModified;
  final List<Ingredient> ingredients;
  final String? gmo;
  final String? traces;
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
    this.additionalImages,
    this.gmo,
    this.traces,
    this.nutriscoreData,
    this.ingredientsText,
    this.novaGroup,
    this.ecoscoreGrade,
    this.labels,
    this.countries,
    this.categories,
    this.vegetarian,
    this.ingredientText,
    this.allergens,
    this.energyKcal,
    this.saturatedFat,
    this.sodium,
    this.salt,
    this.brands,
    this.manufacturingPlaces,
    this.producer,
    this.link,
    this.origins,
    this.lastModified,
    this.ingredients = const [],
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final nutriments = json['nutriments'] ?? {};
    final ingredientsList = json['ingredients'] as List<dynamic>?;

    return Product(
      name: json['product_name'] ?? 'Produit inconnu',
      code: json['code'] ?? '',
      quantity: json['product_quantity']?.toString() ?? '',
      unity: json['product_quantity_unit']?.toString() ?? '',
      imageUrl: json['image_url'] ?? '',
      additionalImages: [
        if (json['image_front_url'] != null) json['image_front_url'],
        if (json['image_ingredients_url'] != null) json['image_ingredients_url'],
        if (json['image_nutrition_url'] != null) json['image_nutrition_url'],
      ],
      nutriscore: json['nutriscore_grade'] ?? 'n',
      energy: (nutriments['energy_100g'] ?? 0).toDouble(),
      fat: (nutriments['fat_100g'] ?? 0).toDouble(),
      carbohydrates: (nutriments['carbohydrates_100g'] ?? 0).toDouble(),
      proteins: (nutriments['proteins_100g'] ?? 0).toDouble(),
      sugars: (nutriments['sugars_100g'] ?? 0).toDouble(),
      nutriscoreData: json['nutriscore_data'] != null
          ? NutriscoreData.fromJson(json['nutriscore_data'])
          : null,
      ingredientsText: json['ingredients_text'],

      novaGroup: json['nova_group'] != null ? int.tryParse(json['nova_group'].toString()) : null,
      ecoscoreGrade: json['ecoscore_grade'] ?? '',
      labels: json['labels'],
      countries: json['countries'],
      categories: json['categories'],
      vegetarian: ingredientsList != null && ingredientsList.isNotEmpty
          ? ingredientsList[0]['vegetarian']?.toString()
          : null,
      ingredientText: ingredientsList != null && ingredientsList.isNotEmpty
          ? ingredientsList[0]['text']?.toString()
          : null,
      allergens: json['allergens'],
      energyKcal: (nutriments['energy-kcal_100g'] ?? 0).toDouble(),
      saturatedFat: (nutriments['saturated-fat_100g'] ?? 0).toDouble(),
      sodium: (nutriments['sodium_100g'] ?? 0).toDouble(),
      salt: (nutriments['salt_100g'] ?? 0).toDouble(),
      brands: json['brands'],
      manufacturingPlaces: json['manufacturing_places'],
      producer: json['packager_code'],
      link: json['url'],
      origins: json['origins'],
      lastModified: json['last_modified_t']?.toString(),
      gmo: json['ingredients_analysis_tags']?.contains('en:non-gmo') == true ? 'Non-OGM' : 'Peut contenir OGM',
      traces: json['traces'] ?? 'Non renseigné',
      ingredients: ingredientsList != null
          ? ingredientsList.map((e) => Ingredient.fromJson(e)).toList()
          : [],
    );

  }
}
