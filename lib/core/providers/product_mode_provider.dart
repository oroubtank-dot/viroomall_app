// lib/core/providers/product_mode_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import '../constants/product_type.dart';

class ProductModeNotifier
    extends StateNotifier<AsyncValue<List<ProductModel>>> {
  final ProductType productType;
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  ProductModeNotifier(this.productType) : super(const AsyncValue.loading());

  Future<void> loadProducts({bool refresh = false}) async {
    if (refresh) {
      _lastDocument = null;
      _hasMore = true;
      state = const AsyncValue.loading();
    }

    if (!_hasMore && !refresh) return;

    try {
      var query = FirebaseFirestore.instance
          .collection('products')
          .where('status', isEqualTo: 'approved')
          .where('productType', isEqualTo: productType.firestoreValue)
          .orderBy('createdAt', descending: true)
          .limit(10);

      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      final snapshot = await query.get();

      final products =
          snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList();

      _hasMore = snapshot.docs.length == 10;
      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
      }

      if (refresh) {
        state = AsyncValue.data(products);
      } else {
        final currentProducts = state.value ?? [];
        state = AsyncValue.data([...currentProducts, ...products]);
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;
    await loadProducts();
    _isLoadingMore = false;
  }

  void refresh() {
    loadProducts(refresh: true);
  }

  /// زيادة عدد المشاهدات للمنتج
  Future<void> incrementViewCount(String productId) async {
    try {
      final productRef =
          FirebaseFirestore.instance.collection('products').doc(productId);

      await productRef.update({
        'views': FieldValue.increment(1),
      });
    } catch (e) {
      debugPrint('خطأ في تحديث المشاهدات: $e');
    }
  }

  /// زيادة عدد المشاهدات للمنتج (نسخة آمنة بدون await)
  void incrementViewCountFireAndForget(String productId) {
    incrementViewCount(productId);
  }
}

final productModeProvider = StateNotifierProvider.family<ProductModeNotifier,
    AsyncValue<List<ProductModel>>, String>((ref, modeKey) {
  final type = ProductType.fromModeName(modeKey);
  return ProductModeNotifier(type);
});
