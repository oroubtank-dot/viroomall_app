// lib/core/services/orders/order_actions.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../features/orders/domain/models/order_model.dart';
import '../../../features/orders/domain/enums/order_status.dart'; // 👈 أضفنا الإستيراد
import '../notification_service.dart';

class OrderActions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createOrder(OrderModel order) async {
    await _firestore.collection('orders').doc(order.id).set(order.toMap());
    VirooNotificationService.notifySellerNewOrder(
        order.productName, order.buyerName);
  }

  Future<void> acceptOrder(String orderId) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': OrderStatus.accepted.name,
    });
  }

  Future<void> markAsDelivered(String orderId, String productName) async {
    await _firestore.collection('orders').doc(orderId).update({
      'sellerConfirmed': true,
      'status': OrderStatus.delivered.name,
    });
    VirooNotificationService.notifyBuyerOrderAccepted(productName);
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
