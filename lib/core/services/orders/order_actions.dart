// lib/core/services/orders/order_actions.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/order_model.dart';
import '../notification_service.dart';

class OrderActions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createOrder(OrderModel order) async {
    await _firestore.collection('orders').doc(order.id).set(order.toMap());

    // ✅ إشعار للبائع (بالمعاملات الصحيحة)
    VirooNotificationService.notifySellerNewOrder(
      sellerId: order.sellerId,
      productName: order.productName,
      buyerName: order.buyerName,
    );
  }

  Future<void> acceptOrder(String orderId) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': OrderStatus.accepted.name,
    });
  }

  Future<void> acceptOrderWithNotification({
    required String orderId,
    required String buyerId,
    required String productName,
  }) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': OrderStatus.accepted.name,
    });

    // ✅ إشعار للمشتري (بالمعاملات الصحيحة)
    VirooNotificationService.notifyBuyerOrderAccepted(
      buyerId: buyerId,
      productName: productName,
    );
  }

  Future<void> markAsDelivered(String orderId, String productName) async {
    await _firestore.collection('orders').doc(orderId).update({
      'sellerConfirmed': true,
      'status': OrderStatus.delivered.name,
    });
    // ملاحظة: الدالة القديمة notifyBuyerOrderAccepted كانت بتاخد productName بس
    // ولكننا غيرناها، هنستخدم الدالة الجديدة
  }

  Future<void> confirmReceipt(String orderId, String sellerId) async {
    await _firestore.collection('orders').doc(orderId).update({
      'buyerConfirmed': true,
      'status': OrderStatus.confirmed.name,
    });
    await _firestore.collection('users').doc(sellerId).update({
      'successful_orders': FieldValue.increment(1),
    });
  }
}
