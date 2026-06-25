// lib/features/favorites/presentation/providers/favorites_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/models/product_model.dart';
import '../../../../core/services/auth_service.dart';

class FavoritesNotifier extends StateNotifier<List<ProductModel>> {
  FavoritesNotifier() : super([]);

  String? get _userId => AuthService.currentUser?.uid;

  // =============================================
  // 🆕 جلب المفضلة من Firebase
  // =============================================
  Future<void> loadFavorites() async {
    if (_userId == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('favorites')
          .where('userId', isEqualTo: _userId)
          .get();

      // جلب المنتجات كاملة من Firestore
      List<ProductModel> products = [];
      for (var doc in snapshot.docs) {
        final productId = doc.data()['productId'] as String?;
        if (productId != null) {
          final productDoc = await FirebaseFirestore.instance
              .collection('products')
              .doc(productId)
              .get();
          if (productDoc.exists) {
            products.add(ProductModel.fromFirestore(productDoc));
          }
        }
      }
      state = products;
    } catch (e) {
      print('❌ خطأ في جلب المفضلة: $e');
    }
  }

  // =============================================
  // 🆕 إضافة منتج للمفضلة
  // =============================================
  Future<void> addToFavorites(ProductModel product) async {
    if (_userId == null) return;

    try {
      // نضيف المنتج في Firestore
      await FirebaseFirestore.instance.collection('favorites').add({
        'userId': _userId,
        'productId': product.id,
        'addedAt': FieldValue.serverTimestamp(),
      });

      // نضيفه محلياً
      if (!state.any((p) => p.id == product.id)) {
        state = [...state, product];
      }
    } catch (e) {
      print('❌ خطأ في إضافة المفضلة: $e');
    }
  }

  // =============================================
  // 🆕 حذف منتج من المفضلة
  // =============================================
  Future<void> removeFromFavorites(String productId) async {
    if (_userId == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('favorites')
          .where('userId', isEqualTo: _userId)
          .where('productId', isEqualTo: productId)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      state = state.where((p) => p.id != productId).toList();
    } catch (e) {
      print('❌ خطأ في حذف المفضلة: $e');
    }
  }

  // =============================================
  // 🆕 تبديل حالة المفضلة (إضافة/حذف)
  // =============================================
  Future<void> toggleFavorite(ProductModel product) async {
    if (_userId == null) return;

    if (state.any((p) => p.id == product.id)) {
      await removeFromFavorites(product.id);
    } else {
      await addToFavorites(product);
    }
  }

  // =============================================
  // التحقق من وجود منتج في المفضلة
  // =============================================
  bool isFavorite(String productId) {
    return state.any((p) => p.id == productId);
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<ProductModel>>((ref) {
  final notifier = FavoritesNotifier();
  notifier.loadFavorites();
  return notifier;
});
