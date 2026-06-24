// lib/core/repositories/product_repository.dart
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/product_model.dart';

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// رفع الصور إلى Firebase Storage
  Future<List<String>> uploadImages(List<File> images, String productId) async {
    final List<String> imageUrls = [];

    for (int i = 0; i < images.length; i++) {
      final file = images[i];
      final ref = _storage.ref().child('products/$productId/image_$i.jpg');
      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      imageUrls.add(url);
    }

    return imageUrls;
  }

  /// حفظ المنتج في Firestore
  Future<void> saveProductToFirestore(ProductModel product) async {
    await _firestore
        .collection('products')
        .doc(product.id)
        .set(product.toFirestore());
  }

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

  /// البحث عن منتجات (مباشر من Firestore)
  Stream<List<ProductModel>> searchProducts(String query) {
    if (query.isEmpty) {
      return _firestore
          .collection('products')
          .where('status', isEqualTo: 'approved')
          .limit(20)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => ProductModel.fromFirestore(doc))
              .toList());
    }

    return _firestore
        .collection('products')
        .where('status', isEqualTo: 'approved')
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThanOrEqualTo: '$query\uf8ff')
        .limit(20)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProductModel.fromFirestore(doc))
            .toList());
  }
}