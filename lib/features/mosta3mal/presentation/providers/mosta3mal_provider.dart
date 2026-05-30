// lib/features/mosta3mal/presentation/providers/mosta3mal_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/models/product_model.dart';

class Mosta3malNotifier extends StateNotifier<List<ProductModel>> {
  Mosta3malNotifier() : super([]);

  Future<void> loadProducts() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('status', isEqualTo: 'approved')
        .where('productType', isEqualTo: 'used')
        .orderBy('createdAt', descending: true)
        .limit(20)
        .get();

    state =
        snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList();
  }
}

final mosta3malProductsProvider =
    StateNotifierProvider<Mosta3malNotifier, List<ProductModel>>((ref) {
  return Mosta3malNotifier();
});
