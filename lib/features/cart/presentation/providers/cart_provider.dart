// lib/features/cart/presentation/providers/cart_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/models/product_model.dart';
import '../../../../core/services/auth_service.dart';

// 👈 نموذج عنصر السلة (منتج + كمية)
class CartItem {
  final ProductModel product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice => product.price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'productId': product.id,
      'quantity': quantity,
    };
  }
}

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  String? get _userId => AuthService.currentUser?.uid;

  // =============================================
  // 🆕 جلب السلة من Firebase
  // =============================================
  Future<void> loadCart() async {
    if (_userId == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('carts')
          .where('userId', isEqualTo: _userId)
          .get();

      if (snapshot.docs.isEmpty) {
        state = [];
        return;
      }

      final doc = snapshot.docs.first;
      final items = doc.data()['items'] as List? ?? [];
      final List<CartItem> cartItems = [];

      for (var item in items) {
        final productId = item['productId'] as String?;
        final quantity = item['quantity'] as int? ?? 1;
        if (productId != null) {
          final productDoc = await FirebaseFirestore.instance
              .collection('products')
              .doc(productId)
              .get();
          if (productDoc.exists) {
            final product = ProductModel.fromFirestore(productDoc);
            cartItems.add(CartItem(product: product, quantity: quantity));
          }
        }
      }
      state = cartItems;
    } catch (e) {
      print('❌ خطأ في جلب السلة: $e');
    }
  }

  // =============================================
  // 🆕 حفظ السلة في Firebase
  // =============================================
  Future<void> _saveCart() async {
    if (_userId == null) return;

    try {
      final items = state.map((item) => item.toMap()).toList();
      final snapshot = await FirebaseFirestore.instance
          .collection('carts')
          .where('userId', isEqualTo: _userId)
          .get();

      if (snapshot.docs.isEmpty) {
        await FirebaseFirestore.instance.collection('carts').add({
          'userId': _userId,
          'items': items,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        await snapshot.docs.first.reference.update({
          'items': items,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('❌ خطأ في حفظ السلة: $e');
    }
  }

  // =============================================
  // إضافة منتج للسلة
  // =============================================
  void addToCart(ProductModel product) async {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      state[index].quantity++;
      state = [...state];
    } else {
      state = [...state, CartItem(product: product, quantity: 1)];
    }
    await _saveCart();
  }

  // =============================================
  // حذف منتج من السلة
  // =============================================
  void removeFromCart(String productId) async {
    state = state.where((item) => item.product.id != productId).toList();
    await _saveCart();
  }

  // =============================================
  // زيادة الكمية
  // =============================================
  void increaseQuantity(String productId) async {
    final index = state.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      state[index].quantity++;
      state = [...state];
      await _saveCart();
    }
  }

  // =============================================
  // تقليل الكمية
  // =============================================
  void decreaseQuantity(String productId) async {
    final index = state.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      if (state[index].quantity > 1) {
        state[index].quantity--;
        state = [...state];
        await _saveCart();
      } else {
        removeFromCart(productId);
      }
    }
  }

  // =============================================
  // تفريغ السلة
  // =============================================
  void clearCart() async {
    state = [];
    await _saveCart();
  }

  // =============================================
  // التحقق من وجود منتج في السلة
  // =============================================
  bool isInCart(String productId) {
    return state.any((item) => item.product.id == productId);
  }

  // =============================================
  // عدد العناصر في السلة (بالكميات)
  // =============================================
  int get itemCount => state.fold(0, (sum, item) => sum + item.quantity);

  // =============================================
  // الإجمالي الكلي
  // =============================================
  double get totalPrice =>
      state.fold(0.0, (sum, item) => sum + item.totalPrice);
}

// =============================================
// Providers
// =============================================
final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  final notifier = CartNotifier();
  notifier.loadCart();
  return notifier;
});

final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).fold(0, (sum, item) => sum + item.quantity);
});

final cartTotalPriceProvider = Provider<double>((ref) {
  final cartItems = ref.watch(cartProvider);
  return cartItems.fold(
      0.0, (sum, item) => sum + (item.product.price * item.quantity));
});

final isInCartProvider = Provider.family<bool, String>((ref, productId) {
  return ref.watch(cartProvider).any((item) => item.product.id == productId);
});
