// lib/features/admin/data/product_repository.dart
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../../core/models/product_model.dart';

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
