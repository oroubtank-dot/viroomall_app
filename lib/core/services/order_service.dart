// lib/core/services/order_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';
import 'auth_service.dart';
import 'notification_service.dart';
import '../../features/cart/presentation/providers/cart_provider.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // =============================================
  // 🆕 إنشاء طلب جديد من السلة
  // =============================================
  Future<void> createOrder({
    required List<CartItem> items,
    required double totalPrice,
    required String sellerId,
    required String sellerName,
    required String productId,
    required String productName,
    required String productImage,
  }) async {
    try {
      final user = AuthService.currentUser;
      if (user == null) throw Exception('الرجاء تسجيل الدخول');

      final order = OrderModel(
        id: '',
        buyerId: user.uid,
        buyerName: user.displayName ?? 'مستخدم VirooMall',
        sellerId: sellerId,
        sellerName: sellerName,
        productId: productId,
        productName: productName,
        productImage: productImage,
        price: totalPrice,
        quantity: 1,
        status: OrderStatus.pending,
        sellerConfirmed: false,
        buyerConfirmed: false,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('orders').add(order.toMap());

      // ✅ إشعار للبائع (بالمعاملات الصحيحة)
      VirooNotificationService.notifySellerNewOrder(
        sellerId: sellerId,
        productName: productName,
        buyerName: user.displayName ?? 'مشتري',
      );

      // تحديث المحفظة (خصم المبلغ)
      // await ref.read(walletServiceProvider).deduct(user.uid, totalPrice, 'شراء منتج');

    } catch (e) {
      // ignore: avoid_print
      print('❌ خطأ في إنشاء الطلب: $e');
      rethrow;
    }
  }

  // =============================================
  // 📦 جلب طلبات المشتري
  // =============================================
  Stream<List<OrderModel>> getBuyerOrders(String buyerId) {
    return _firestore
        .collection('orders')
        .where('buyerId', isEqualTo: buyerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OrderModel.fromFirestore(doc))
            .toList());
  }

  // =============================================
  // 📦 جلب طلبات البائع
  // =============================================
  Stream<List<OrderModel>> getSellerOrders(String sellerId) {
    return _firestore
        .collection('orders')
        .where('sellerId', isEqualTo: sellerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OrderModel.fromFirestore(doc))
            .toList());
  }

  // =============================================
  // ✅ تحديث حالة الطلب
  // =============================================
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': status.name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // =============================================
  // ✅ قبول الطلب (للبائع)
  // =============================================
  Future<void> acceptOrder({
    required String orderId,
    required String buyerId,
    required String productName,
  }) async {
    await updateOrderStatus(orderId, OrderStatus.accepted);
    
    // ✅ إشعار للمشتري (بالمعاملات الصحيحة)
    VirooNotificationService.notifyBuyerOrderAccepted(
      buyerId: buyerId,
      productName: productName,
    );
  }

  // =============================================
  // ✅ تأكيد استلام الطلب (للمشتري)
  // =============================================
  Future<void> confirmDelivery(String orderId, String sellerId) async {
    await updateOrderStatus(orderId, OrderStatus.confirmed);
    
    // تحديث إحصائيات البائع
    await _firestore.collection('users').doc(sellerId).update({
      'totalSales': FieldValue.increment(1),
    });
  }

  // =============================================
  // ❌ إلغاء الطلب
  // =============================================
  Future<void> cancelOrder(String orderId) async {
    await updateOrderStatus(orderId, OrderStatus.cancelled);
  }
}