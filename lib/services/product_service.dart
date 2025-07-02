import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  static Future<Product?> fetchProductByCode(String code) async {
    final url = 'https://world.openfoodfacts.org/api/v2/product/$code.json';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['product'] != null) {
        return Product.fromJson(data['product']);
      }
    }
    return null;
  }

  static Future<List<Product>> fetchProductByName(String name) async {
    final url = Uri.parse(
      'https://world.openfoodfacts.org/cgi/search.pl'
          '?search_terms=$name'
          '&search_simple=1'
          '&action=process'
          '&json=1',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final products = data['products'] as List;

      return products
          .map((item) => Product.fromJson(item))
          .where((product) => product.imageUrl.isNotEmpty)
          .toList();
    } else {
      throw Exception('Échec de la recherche');
    }
  }

}
