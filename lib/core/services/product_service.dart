// lib/core/services/product_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import '../constants/product_type.dart';

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // =============================================
  // الحصول على المنتجات حسب الوضع
  // =============================================
  Stream<List<ProductModel>> getProductsByMode(ProductType type) {
    return _db
        .collection('products')
        .where('productType', isEqualTo: type.firestoreValue)
        .where('status', isEqualTo: 'approved')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProductModel.fromFirestore(doc))
            .toList());
  }

  // =============================================
  // الحصول على كل المنتجات
  // =============================================
  Stream<List<ProductModel>> getAllProducts() {
    return _db
        .collection('products')
        .where('status', isEqualTo: 'approved')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProductModel.fromFirestore(doc))
            .toList());
  }

  // =============================================
  // الحصول على المنتجات المميزة
  // =============================================
  Stream<List<ProductModel>> getFeaturedProducts() {
    return _db
        .collection('products')
        .where('status', isEqualTo: 'approved')
        .where('qualityScore', isGreaterThanOrEqualTo: 80)
        .orderBy('qualityScore', descending: true)
        .limit(6)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProductModel.fromFirestore(doc))
            .toList());
  }

  // =============================================
  // الحصول على منتج واحد
  // =============================================
  Future<ProductModel?> getProduct(String productId) async {
    try {
      final doc = await _db.collection('products').doc(productId).get();
      if (doc.exists) {
        return ProductModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // =============================================
  // زيادة عدد المشاهدات
  // =============================================
  Future<void> incrementViews(String productId) async {
    try {
      await _db.collection('products').doc(productId).update({
        'views': FieldValue.increment(1),
      });
    } catch (e) {
      // تجاهل الخطأ
    }
  }
}
