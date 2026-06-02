// lib/features/favorites/presentation/providers/favorites_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/product_model.dart';

class FavoritesNotifier extends StateNotifier<List<ProductModel>> {
  FavoritesNotifier() : super([]);

  void addToFavorites(ProductModel product) {
    if (!state.any((p) => p.id == product.id)) {
      state = [...state, product];
    }
  }

  void removeFromFavorites(String productId) {
    state = state.where((p) => p.id != productId).toList();
  }

  void toggleFavorite(ProductModel product) {
    if (state.any((p) => p.id == product.id)) {
      removeFromFavorites(product.id);
    } else {
      addToFavorites(product);
    }
  }

  bool isFavorite(String productId) {
    return state.any((p) => p.id == productId);
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<ProductModel>>((ref) {
  return FavoritesNotifier();
});