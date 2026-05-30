// lib/features/product/data/datasources/product_remote_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import '../../domain/entities/product_entity.dart';

class ProductRemoteDataSource {
  final FirebaseFirestore _firestore;

  ProductRemoteDataSource(this._firestore);

  Stream<List<ProductModel>> getProducts(String marketType) {
    return _firestore
        .collection('products')
        .where('status', isEqualTo: 'approved')
        .where('marketType', isEqualTo: marketType)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProductModel.fromFirestore(doc))
            .toList());
  }

  Stream<List<ProductModel>> getFeaturedProducts() {
    return _firestore
        .collection('products')
        .where('status', isEqualTo: 'approved')
        .limit(6)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProductModel.fromFirestore(doc))
            .toList());
  }

  Future<ProductModel?> getProductById(String productId) async {
    final doc = await _firestore.collection('products').doc(productId).get();
    if (!doc.exists) return null;
    return ProductModel.fromFirestore(doc);
  }

  Future<void> addProduct(ProductModel product) async {
    await _firestore.collection('products').add(product.toFirestore());
  }

  Future<void> updateProduct(ProductModel product) async {
    await _firestore
        .collection('products')
        .doc(product.id)
        .update(product.toFirestore());
  }

  Future<void> deleteProduct(String productId) async {
    await _firestore.collection('products').doc(productId).delete();
  }
}
