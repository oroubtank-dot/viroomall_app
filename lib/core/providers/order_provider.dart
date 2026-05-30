// lib/core/providers/order_provider.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order_model.dart';
import '../services/notification_service.dart';

final orderActionsProvider = Provider((ref) => OrderActions());

class OrderActions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// =============================================
// 6. تأكيد الاستلام مع التقييم
// =============================================
  Future<void> confirmReceiptWithRating(
    String orderId,
    String sellerId,
    int rating,
    String? comment,
  ) async {
    await _firestore.collection('orders').doc(orderId).update({
      'buyerConfirmed': true,
      'status': OrderStatus.confirmed.name,
      'isRated': true,
      'rating': rating,
      'review': comment,
      'updatedAt': Timestamp.now(),
    });

    await _firestore.collection('users').doc(sellerId).update({
      'successful_orders': FieldValue.increment(1),
      'total_rating': FieldValue.increment(rating),
      'rating_count': FieldValue.increment(1),
    });

    VirooNotificationService.showInstantNotification(
      '✅ مبروك!',
      'تم إكمال الطلب بنجاح ورفع تقييم البائع.',
    );
  }

  // =============================================
  // 1. لما المشتري يعمل طلب جديد
  // =============================================
  Future<void> createNewOrder(OrderModel order, String buyerName) async {
    await _firestore.collection('orders').doc(order.id).set(order.toMap());

    // إشعار فوري للبائع
    VirooNotificationService.notifySellerNewOrder(order.productName, buyerName);
  }

  // =============================================
  // 2. لما البائع يقبل الطلب
  // =============================================
  Future<void> acceptOrder(
      String orderId, String buyerId, String productName) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': OrderStatus.accepted.name,
      'updatedAt': Timestamp.now(),
    });

    // إشعار للمشتري
    VirooNotificationService.notifyBuyerOrderAccepted(productName);
  }

  // =============================================
  // 3. لما البائع يدوس "تم التسليم"
  // =============================================
  Future<void> markAsDelivered(String orderId, String productName) async {
    await _firestore.collection('orders').doc(orderId).update({
      'sellerConfirmed': true,
      'status': OrderStatus.delivered.name,
      'updatedAt': Timestamp.now(),
    });

    // إشعار فوري للمشتري: "البائع سلم الطلب، طمنا؟"
    VirooNotificationService.notifyBuyerOrderAccepted(productName);
  }

  // =============================================
  // 4. لما المشتري يأكد الاستلام النهائي
  // =============================================
  Future<void> confirmReceipt(String orderId, String sellerId) async {
    await _firestore.collection('orders').doc(orderId).update({
      'buyerConfirmed': true,
      'status': OrderStatus.confirmed.name,
      'updatedAt': Timestamp.now(),
    });

    // تحديث عداد نجاح البائع
    await _firestore.collection('users').doc(sellerId).update({
      'successful_orders': FieldValue.increment(1),
    });

    VirooNotificationService.showInstantNotification(
      '✅ مبروك!',
      'تم إكمال الطلب بنجاح ورفع تقييم البائع.',
    );
  }

  // =============================================
  // 5. إلغاء الطلب
  // =============================================
  Future<void> cancelOrder(String orderId) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': OrderStatus.cancelled.name,
      'updatedAt': Timestamp.now(),
    });
  }
}
