// lib/core/services/orders/order_actions.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../features/orders/domain/models/order_model.dart';
import '../../../features/orders/domain/enums/order_status.dart';
import '../notification_service.dart';
import '../storage_service.dart';

class OrderActions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> _getLang() async {
    return await StorageService.getLanguage();
  }

  // =============================================
  // 1. المشتري يعمل طلب جديد
  // =============================================
  Future<void> createOrder(OrderModel order) async {
    await _firestore.collection('orders').doc(order.id).set(order.toMap());
    final lang = await _getLang();
    VirooNotificationService.notifySellerNewOrder(
        order.productName, order.buyerName,
        lang: lang);
    _startSellerResponseTimer(order.id, order.sellerId);
  }

  // =============================================
  // 2. البائع يؤكد الطلب
  // =============================================
  Future<void> confirmOrder(
      String orderId, String buyerId, String productName) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': OrderStatus.confirmed.name,
      'confirmedAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    });
    final lang = await _getLang();
    VirooNotificationService.notifyBuyerOrderConfirmed(productName, lang: lang);
  }

  // =============================================
  // 3. البائع يجهز الطلب
  // =============================================
  Future<void> markAsPreparing(String orderId, String productName) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': OrderStatus.preparing.name,
      'updatedAt': Timestamp.now(),
    });
    final lang = await _getLang();
    VirooNotificationService.notifyBuyerOrderPreparing(productName, lang: lang);
  }

  // =============================================
  // 4. البائع يسلم للشحن
  // =============================================
  Future<void> markAsShipped({
    required String orderId,
    required String productName,
    required String trackingNumber,
    required String shippingCompany,
  }) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': OrderStatus.shipped.name,
      'trackingNumber': trackingNumber,
      'shippingCompany': shippingCompany,
      'shippedAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    });
    final lang = await _getLang();
    VirooNotificationService.notifyBuyerOrderShipped(
        productName, trackingNumber,
        lang: lang);
  }

  // =============================================
  // 5. المشتري يؤكد الاستلام + تقييم
  // =============================================
  Future<void> confirmReceipt({
    required String orderId,
    required String sellerId,
    required String productId,
    int? rating,
    String? comment,
    List<String>? reviewImages,
  }) async {
    final updates = <String, dynamic>{
      'status': OrderStatus.delivered.name,
      'deliveredAt': Timestamp.now(),
      'isRated': rating != null,
      'updatedAt': Timestamp.now(),
    };

    if (rating != null) {
      updates['rating'] = rating;
      updates['review'] = comment;
      updates['reviewImages'] = reviewImages ?? [];
    }

    await _firestore.collection('orders').doc(orderId).update(updates);
    await _firestore.collection('users').doc(sellerId).update({
      'successfulOrders': FieldValue.increment(1),
    });

    if (rating != null) {
      await _firestore.collection('users').doc(sellerId).update({
        'totalRating': FieldValue.increment(rating),
        'ratingCount': FieldValue.increment(1),
      });
      await _firestore.collection('reviews').add({
        'orderId': orderId,
        'productId': productId,
        'sellerId': sellerId,
        'rating': rating,
        'comment': comment,
        'images': reviewImages ?? [],
        'createdAt': Timestamp.now(),
      });
    }

    final lang = await _getLang();
    if (rating != null) {
      VirooNotificationService.showInstantNotification(
          lang == 'ar' ? '✅ تم الاستلام والتقييم' : '✅ Received & Rated',
          lang == 'ar' ? 'شكرًا لتقييمك!' : 'Thanks for your review!');
    } else {
      VirooNotificationService.showInstantNotification(
          lang == 'ar' ? '✅ تم الاستلام' : '✅ Received',
          lang == 'ar' ? 'تم تأكيد الاستلام بنجاح.' : 'Receipt confirmed.');
    }
  }

  // =============================================
  // 6. إلغاء الطلب
  // =============================================
  Future<void> cancelOrder(String orderId) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': OrderStatus.cancelled.name,
      'updatedAt': Timestamp.now(),
    });

    final lang = await _getLang();
    VirooNotificationService.showInstantNotification(
        lang == 'ar' ? '❌ تم الإلغاء' : '❌ Cancelled',
        lang == 'ar' ? 'تم إلغاء الطلب بنجاح.' : 'Order cancelled.');
  }

  // =============================================
  // 7. تذكير المشتري بالتقييم
  // =============================================
  Future<void> remindBuyerToRate({
    required String orderId,
    required String productName,
  }) async {
    final lang = await _getLang();
    VirooNotificationService.notifyBuyerRemindRating(productName, lang: lang);
  }

  // =============================================
  // 8. البائع يذكّر المشتري بالتقييم
  // =============================================
  Future<void> remindBuyerFromSeller({
    required String orderId,
    required String buyerName,
  }) async {
    final lang = await _getLang();
    VirooNotificationService.notifySellerRemindBuyer(buyerName, lang: lang);
  }

  // =============================================
  // مؤقت الـ ٤٨ ساعة
  // =============================================
  void _startSellerResponseTimer(String orderId, String sellerId) {
    Future.delayed(const Duration(hours: 1), () async {
      final lang = await _getLang();
      VirooNotificationService.notifySellerReminder(orderId, lang: lang);
    });

    Future.delayed(const Duration(hours: 12), () async {
      final lang = await _getLang();
      VirooNotificationService.notifySellerReminder(orderId, lang: lang);
    });
  }
}
