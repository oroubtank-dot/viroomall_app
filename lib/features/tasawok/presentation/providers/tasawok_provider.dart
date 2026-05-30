// lib/features/tasawok/presentation/providers/tasawok_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/models/product_model.dart';

class TasawokNotifier extends StateNotifier<List<ProductModel>> {
  TasawokNotifier() : super([]);

  Future<void> loadProducts() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('status', isEqualTo: 'approved')
        .where('productType', isEqualTo: 'new')
        .orderBy('createdAt', descending: true)
        .limit(20)
        .get();

    state =
        snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList();
  }
}

final tasawokProductsProvider =
    StateNotifierProvider<TasawokNotifier, List<ProductModel>>((ref) {
  return TasawokNotifier();
});
