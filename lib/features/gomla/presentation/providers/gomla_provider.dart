// lib/features/gomla/presentation/providers/gomla_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/models/product_model.dart';

class GomlaNotifier extends StateNotifier<List<ProductModel>> {
  GomlaNotifier() : super([]);

  Future<void> loadProducts() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('status', isEqualTo: 'approved')
        .where('productType', isEqualTo: 'wholesale')
        .orderBy('createdAt', descending: true)
        .limit(20)
        .get();

    state =
        snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList();
  }
}

final gomlaProductsProvider =
    StateNotifierProvider<GomlaNotifier, List<ProductModel>>((ref) {
  return GomlaNotifier();
});
