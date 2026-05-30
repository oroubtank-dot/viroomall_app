// lib/features/product/presentation/providers/product_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/models/product_model.dart';

final allProductsProvider = StreamProvider<List<ProductModel>>((ref) {
  return FirebaseFirestore.instance
      .collection('products')
      .where('status', isEqualTo: 'approved')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList());
});

final featuredProductsProvider = StreamProvider<List<ProductModel>>((ref) {
  return FirebaseFirestore.instance
      .collection('products')
      .where('status', isEqualTo: 'approved')
      .limit(6)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList());
});

final productByIdProvider =
    FutureProvider.family<ProductModel?, String>((ref, productId) async {
  final doc = await FirebaseFirestore.instance
      .collection('products')
      .doc(productId)
      .get();
  if (!doc.exists) return null;
  return ProductModel.fromFirestore(doc);
});
