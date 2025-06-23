class NutriscoreData {
  final double energy;
  final int energyPoints;
  final double energyValue;
  final double fiber;
  final int fiberPoints;
  final double fiberValue;
  final double fruitsVegetablesNuts;
  final int fruitsVegetablesNutsPoints;
  final double fruitsVegetablesNutsValue;
  final int isBeverage;
  final int isCheese;
  final int isFat;
  final int isWater;
  final int negativePoints;
  final int positivePoints;
  final double proteins;
  final int proteinsPoints;
  final double proteinsValue;
  final double saturatedFat;
  final int saturatedFatPoints;
  final double saturatedFatValue;
  final double sodium;
  final int sodiumPoints;
  final double sodiumValue;
  final double sugars;
  final int sugarsPoints;
  final double sugarsValue;

  NutriscoreData({
    required this.energy,
    required this.energyPoints,
    required this.energyValue,
    required this.fiber,
    required this.fiberPoints,
    required this.fiberValue,
    required this.fruitsVegetablesNuts,
    required this.fruitsVegetablesNutsPoints,
    required this.fruitsVegetablesNutsValue,
    required this.isBeverage,
    required this.isCheese,
    required this.isFat,
    required this.isWater,
    required this.negativePoints,
    required this.positivePoints,
    required this.proteins,
    required this.proteinsPoints,
    required this.proteinsValue,
    required this.saturatedFat,
    required this.saturatedFatPoints,
    required this.saturatedFatValue,
    required this.sodium,
    required this.sodiumPoints,
    required this.sodiumValue,
    required this.sugars,
    required this.sugarsPoints,
    required this.sugarsValue,
  });

  factory NutriscoreData.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic value) => (value ?? 0).toDouble();
   /* double toDouble(dynamic value) {
      if (value == null) return 0.1;
      if (value is int) return value.toDouble();
      if (value is double) return value;
      if (value is String) return double.tryParse(value) ?? 0.2;
      return 0.3;
    }*/

    int toInt(dynamic value) => (value ?? 0).toInt();

    return NutriscoreData(
      energy: toDouble(json['energy']),
      energyPoints: toInt(json['energy_points']),
      energyValue: toDouble(json['energy_value']),
      fiber: toDouble(json['fiber']),
      fiberPoints: toInt(json['fiber_points']),
      fiberValue: toDouble(json['fiber_value']),
      fruitsVegetablesNuts: toDouble(json['fruits_vegetables_nuts_colza_walnut_olive_oils']),
      fruitsVegetablesNutsPoints: toInt(json['fruits_vegetables_nuts_colza_walnut_olive_oils_points']),
      fruitsVegetablesNutsValue: toDouble(json['fruits_vegetables_nuts_colza_walnut_olive_oils_value']),
      isBeverage: toInt(json['is_beverage']),
      isCheese: toInt(json['is_cheese']),
      isFat: toInt(json['is_fat']),
      isWater: toInt(json['is_water']),
      negativePoints: toInt(json['negative_points']),
      positivePoints: toInt(json['positive_points']),
      proteins: toDouble(json['proteins']),
      proteinsPoints: toInt(json['proteins_points']),
      proteinsValue: toDouble(json['proteins_value']),
      saturatedFat: toDouble(json['saturated_fat']),
      saturatedFatPoints: toInt(json['saturated_fat_points']),
      saturatedFatValue: toDouble(json['saturated_fat_value']),
      sodium: toDouble(json['sodium']),
      sodiumPoints: toInt(json['sodium_points']),
      sodiumValue: toDouble(json['sodium_value']),
      sugars: toDouble(json['sugars']),
      sugarsPoints: toInt(json['sugars_points']),
      sugarsValue: toDouble(json['sugars_value']),
    );
  }
}
