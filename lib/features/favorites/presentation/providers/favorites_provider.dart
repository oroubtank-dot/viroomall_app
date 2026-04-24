// lib/features/favorites/presentation/providers/favorites_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/product_model.dart';
import '../../../../core/services/auth_service.dart';

class FavoritesNotifier extends StateNotifier<List<ProductModel>> {
  FavoritesNotifier() : super([]);

  void toggleFavorite(ProductModel product) {
    final index = state.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      state = state.where((p) => p.id != product.id).toList();
    } else {
      state = [...state, product];
    }
  }

  bool isFavorite(String productId) {
    return state.any((p) => p.id == productId);
  }

  void removeFavorite(String productId) {
    state = state.where((p) => p.id != productId).toList();
  }

  void clearFavorites() {
    state = [];
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<ProductModel>>((ref) {
  return FavoritesNotifier();
});

final isFavoriteProvider = Provider.family<bool, String>((ref, productId) {
  return ref.watch(favoritesProvider).any((p) => p.id == productId);
});
