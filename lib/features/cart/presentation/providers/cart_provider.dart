// lib/features/cart/presentation/providers/cart_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/product_model.dart';

// 👈 نموذج عنصر السلة (منتج + كمية)
class CartItem {
  final ProductModel product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice => product.price * quantity;
}

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  // =============================================
  // إضافة منتج للسلة
  // =============================================
  void addToCart(ProductModel product) {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      // المنتج موجود بالفعل → نزود الكمية
      final updatedItem = CartItem(
        product: state[index].product,
        quantity: state[index].quantity + 1,
      );
      state = [...state]..[index] = updatedItem;
    } else {
      // منتج جديد
      state = [...state, CartItem(product: product, quantity: 1)];
    }
  }

  // =============================================
  // حذف منتج من السلة
  // =============================================
  void removeFromCart(String productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }

  // =============================================
  // زيادة الكمية
  // =============================================
  void increaseQuantity(String productId) {
    final index = state.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      final updatedItem = CartItem(
        product: state[index].product,
        quantity: state[index].quantity + 1,
      );
      state = [...state]..[index] = updatedItem;
    }
  }

  // =============================================
  // تقليل الكمية
  // =============================================
  void decreaseQuantity(String productId) {
    final index = state.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      if (state[index].quantity > 1) {
        final updatedItem = CartItem(
          product: state[index].product,
          quantity: state[index].quantity - 1,
        );
        state = [...state]..[index] = updatedItem;
      } else {
        // لو الكمية 1، نحذف المنتج
        removeFromCart(productId);
      }
    }
  }

  // =============================================
  // تفريغ السلة
  // =============================================
  void clearCart() {
    state = [];
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
  return CartNotifier();
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
