// lib/features/farz/presentation/providers/farz_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/models/product_model.dart';

class FarzNotifier extends StateNotifier<List<ProductModel>> {
  FarzNotifier() : super([]);

  Future<void> loadProducts() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('status', isEqualTo: 'approved')
        .where('productType', isEqualTo: 'outlet')
        .orderBy('createdAt', descending: true)
        .limit(20)
        .get();

    state =
        snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList();
  }
}

final farzProductsProvider =
    StateNotifierProvider<FarzNotifier, List<ProductModel>>((ref) {
  return FarzNotifier();
});
