// lib/features/profile/presentation/providers/dashboard/seller_dashboard_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../core/services/auth_service.dart';
import '../../../../../core/models/product_model.dart';
import '../../../../../core/models/order_model.dart';

class SellerDashboardStats {
  final int totalProducts;
  final int totalViews;
  final int totalSales;
  final double totalRevenue;
  final int pendingOrders;
  final List<ProductModel> topProducts;
  final Map<String, int> salesByDay;
  final List<OrderModel> recentOrders;

  SellerDashboardStats({
    required this.totalProducts,
    required this.totalViews,
    required this.totalSales,
    required this.totalRevenue,
    required this.pendingOrders,
    required this.topProducts,
    required this.salesByDay,
    required this.recentOrders,
  });
}

class SellerDashboardNotifier
    extends StateNotifier<AsyncValue<SellerDashboardStats>> {
  SellerDashboardNotifier() : super(const AsyncValue.loading());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> loadDashboard() async {
    try {
      final currentUser = AuthService.currentUser;
      if (currentUser == null) {
        state = AsyncValue.error('الرجاء تسجيل الدخول', StackTrace.current);
        return;
      }

      final sellerId = currentUser.uid;

      // 1. جلب منتجات البائع
      final productsSnapshot = await _firestore
          .collection('products')
          .where('sellerId', isEqualTo: sellerId)
          .where('status', isEqualTo: 'approved')
          .get();

      final products = productsSnapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();

      final totalProducts = products.length;
      final totalViews = products.fold(0, (sum, p) => sum + p.views);

      // 2. جلب الطلبات للبائع
      final ordersSnapshot = await _firestore
          .collection('orders')
          .where('sellerId', isEqualTo: sellerId)
          .orderBy('createdAt', descending: true)
          .get();

      // ✅ لو مفيش طلبات، نستخدم قائمة فاضية
      List<OrderModel> orders = [];
      for (var doc in ordersSnapshot.docs) {
        try {
          final order = OrderModel.fromFirestore(doc);
          orders.add(order);
        } catch (e) {
          print('⚠️ خطأ في تحويل الطلب ${doc.id}: $e');
        }
      }

      final totalSales = orders.length;
      final pendingOrders = orders
          .where((o) =>
              o.status == OrderStatus.pending ||
              o.status == OrderStatus.accepted)
          .length;

      double totalRevenue = 0;
      for (var order in orders) {
        totalRevenue += order.price * order.quantity;
      }

      // 3. أكثر المنتجات مشاهدة
      final topProducts = products.where((p) => p.views > 0).toList()
        ..sort((a, b) => b.views.compareTo(a.views));

      // 4. المبيعات حسب اليوم (آخر 7 أيام)
      final salesByDay = <String, int>{};
      final now = DateTime.now();
      for (int i = 0; i < 7; i++) {
        final date = now.subtract(Duration(days: i));
        final key = '${date.day}/${date.month}';
        salesByDay[key] = 0;
      }

      for (var order in orders) {
        try {
          if (order.status == OrderStatus.confirmed ||
              order.status == OrderStatus.delivered) {
            final date = order.createdAt;
            final diff = now.difference(date).inDays;
            if (diff < 7) {
              final key = '${date.day}/${date.month}';
              salesByDay[key] = (salesByDay[key] ?? 0) + 1;
            }
          }
        } catch (_) {}
      }

      // 5. آخر 5 طلبات
      final recentOrders = orders.take(5).toList();

      state = AsyncValue.data(SellerDashboardStats(
        totalProducts: totalProducts,
        totalViews: totalViews,
        totalSales: totalSales,
        totalRevenue: totalRevenue,
        pendingOrders: pendingOrders,
        topProducts: topProducts.take(5).toList(),
        salesByDay: salesByDay,
        recentOrders: recentOrders,
      ));
    } catch (e, stack) {
      print('🔥🔥🔥 Dashboard Error: $e');
      print('🔥🔥🔥 Stack: $stack');
      state = AsyncValue.error(e, stack);
    }
  }

  void refresh() {
    loadDashboard();
  }
}

final sellerDashboardProvider = StateNotifierProvider<SellerDashboardNotifier,
    AsyncValue<SellerDashboardStats>>((ref) {
  return SellerDashboardNotifier()..loadDashboard();
});
