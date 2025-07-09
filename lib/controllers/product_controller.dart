import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductController {
  final List<Product> _history = [];

  Future<Product?> getProductByCode(String code) async {
    final product = await ProductService.fetchProductByCode(code);
    if (product != null) {
      _history.insert(0, product);
      await addToHistory(product);
    }

    return product;
  }

  Future<List<Product>> getProductsByName(String name) async {
    return await ProductService.fetchProducts(name);
  }

  List<Product> get history => _history;

  Future<void> toggleLike(Product product) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final likeRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('like')
        .doc(product.code);

    final docSnapshot = await likeRef.get();

    if (docSnapshot.exists) {
      await likeRef.delete();
    } else {
      await likeRef.set({
        'code': product.code,
        'name': product.name,
        'imageUrl': product.imageUrl,
        'nutriscore': product.nutriscore,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<bool> isProductLiked(String code) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return false;

    final likeRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('like')
        .doc(code);

    final docSnapshot = await likeRef.get();
    return docSnapshot.exists;
  }

  Future<void> addToHistory(Product product) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final userHistory = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('history');
    final docRef = userHistory.doc(product.code);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      await docRef.update({
        'timestamp': FieldValue.serverTimestamp(),
      });
    } else {
      await docRef.set({
        'code': product.code,
        'name': product.name,
        'imageUrl': product.imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }


}
