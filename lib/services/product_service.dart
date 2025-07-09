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
        final product = Product.fromJson(data['product']);
        return product;
      }
    }
    return null;
  }

  static Future<List<Product>> fetchProducts(String search) async {
    final url =
        'https://world.openfoodfacts.org/cgi/search.pl?search_terms=$search&search_simple=1&action=process&json=1';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List productsJson = jsonData['products'];

      return productsJson.map((p) => Product.fromJson(p)).toList();
    } else {
      throw Exception('Erreur lors du chargement des produits');
    }
  }

  static Future<List<Product>> fetchProductsByName(String name) async {
    final url =
        'https://world.openfoodfacts.org/cgi/search.pl?search_terms=$name&search_simple=1&action=process&json=1';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List productsJson = jsonData['products'];

      return productsJson.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Erreur lors de la récupération des produits');
    }
  }

  static Future<List<Product>> fetchFeaturedProducts() async {
    const url =
        'https://world.openfoodfacts.org/cgi/search.pl?search_terms=snack&search_simple=1&action=process&json=1';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final productsJson = jsonData['products'] as List;

      return productsJson
          .where((product) =>
      product['product_name'] != null &&
          product['image_url'] != null)
          .take(10)
          .map<Product>((product) => Product.fromJson(product))
          .toList();
    } else {
      throw Exception('Erreur lors du chargement des produits');
    }
  }

}
