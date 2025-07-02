import '../models/product.dart';
import '../services/product_service.dart';

class ProductController {
  final List<Product> _history = [];

  Future<Product?> getProductByCode(String code) async {
    return await ProductService.fetchProductByCode(code);
  }

  Future<List<Product>> getProductsByName(String name) async {
    return await ProductService.fetchProductByName(name);
  }

  void addToHistory(Product product) {
    _history.insert(0, product);
  }

  List<Product> get history => _history;
}
