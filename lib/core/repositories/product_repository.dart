// lib/core/repositories/product_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// جلب منتجات بائع معين
  Stream<List<ProductModel>> getProductsBySeller(String sellerId) {
    return _firestore
        .collection('products')
        .where('sellerId', isEqualTo: sellerId)
        .where('status', isEqualTo: 'approved')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProductModel.fromFirestore(doc))
            .toList());
  }

  /// جلب منتجات بائع معين (مرة واحدة)
  Future<List<ProductModel>> getProductsBySellerOnce(String sellerId) async {
    final snapshot = await _firestore
        .collection('products')
        .where('sellerId', isEqualTo: sellerId)
        .where('status', isEqualTo: 'approved')
        .orderBy('createdAt', descending: true)
        .get();
    
    return snapshot.docs
        .map((doc) => ProductModel.fromFirestore(doc))
        .toList();
  }

  /// حساب عدد منتجات البائع
  Future<int> getProductCount(String sellerId) async {
    final snapshot = await _firestore
        .collection('products')
        .where('sellerId', isEqualTo: sellerId)
        .where('status', isEqualTo: 'approved')
        .count()
        .get();
    return snapshot.count ?? 0;
  }

  /// حساب إجمالي المشاهدات لمنتجات البائع
  Future<int> getTotalViews(String sellerId) async {
    final products = await getProductsBySellerOnce(sellerId);
    int total = 0;
    for (var product in products) {
      total += product.views;
    }
    return total;
  }
}