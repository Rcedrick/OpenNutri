import '../models/product.dart';
import '../services/product_service.dart';

class ProductController {
  Future<Product?> getProductByCode(String code) async {
    return await ProductService.fetchProductByCode(code);
  }
  Future<List<Product>> getProductsByName(String name) async {
    return await ProductService.fetchProductByName(name);
  }
}
