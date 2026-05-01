// lib/features/search/presentation/providers/search_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/models/product_model.dart';

class SearchNotifier extends StateNotifier<List<ProductModel>> {
  SearchNotifier() : super([]);

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = [];
      return;
    }

    _isSearching = true;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('status', isEqualTo: 'approved')
          .get();

      final results = snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .where((product) {
        final title = product.title.toLowerCase();
        final desc = product.description.toLowerCase();
        final searchQuery = query.toLowerCase();
        return title.contains(searchQuery) || desc.contains(searchQuery);
      }).toList();

      state = results;
    } catch (e) {
      state = [];
    }

    _isSearching = false;
  }

  void clearSearch() {
    state = [];
  }
}

final searchProvider =
    StateNotifierProvider<SearchNotifier, List<ProductModel>>((ref) {
  return SearchNotifier();
});
