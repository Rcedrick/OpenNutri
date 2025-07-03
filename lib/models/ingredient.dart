class Ingredient {
  final String text;
  final String? vegan;
  final String? fromPalmOil;
  final String? additive;
  final String? eNumber;

  Ingredient({
    required this.text,
    this.vegan,
    this.fromPalmOil,
    this.additive,
    this.eNumber,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      text: json['text'] ?? '',
      vegan: json['vegan'],
      fromPalmOil: json['from_palm_oil'],
      additive: json['additive'],
      eNumber: json['e_number'],
    );
  }
}
