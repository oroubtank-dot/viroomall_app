// lib/core/services/notification_service.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class VirooNotificationService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// تهيئة الإشعارات
  static Future<void> init() async {
    // طلب إذن الإشعارات
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('🔔 Notification permission granted');
    }

    // إعدادات Android
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // إعدادات iOS
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // تهيئة الإشعارات المحلية
    await _localNotifications.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );

    // الحصول على FCM Token
    final token = await _fcm.getToken();
    print('🔑 FCM Token: $token');
  }

  /// إشعار فوري
  static Future<void> showInstantNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'viroomall_channel',
      'VirooMall Notifications',
      channelDescription: 'إشعارات VirooMall',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _localNotifications.show(
      DateTime.now().millisecond.hashCode,
      title,
      body,
      details,
    );
  }

  /// إشعار للبائع: طلب جديد
  static Future<void> notifySellerNewOrder(String productName, String buyerName,
      {String lang = 'ar'}) async {
    final title = lang == 'ar' ? '🛒 طلب جديد!' : '🛒 New Order!';
    final body = lang == 'ar'
        ? '$buyerName طلب منتجك: $productName'
        : '$buyerName ordered your: $productName';
    await showInstantNotification(title, body);
  }

  /// إشعار للمشتري: البائع أكد طلبك
  static Future<void> notifyBuyerOrderConfirmed(String productName,
      {String lang = 'ar'}) async {
    final title = lang == 'ar' ? '✅ تم تأكيد الطلب' : '✅ Order Confirmed';
    final body = lang == 'ar'
        ? 'البائع أكد طلبك: $productName'
        : 'Seller confirmed your order: $productName';
    await showInstantNotification(title, body);
  }

  /// إشعار للمشتري: البائع بيجهز طلبك
  static Future<void> notifyBuyerOrderPreparing(String productName,
      {String lang = 'ar'}) async {
    final title = lang == 'ar' ? '📦 جاري التجهيز' : '📦 Preparing';
    final body = lang == 'ar'
        ? 'البائع بيجهز طلبك: $productName'
        : 'Seller is preparing: $productName';
    await showInstantNotification(title, body);
  }

  /// إشعار للمشتري: طلبك في الطريق
  static Future<void> notifyBuyerOrderShipped(
      String productName, String trackingNumber,
      {String lang = 'ar'}) async {
    final title = lang == 'ar' ? '🚚 تم الشحن' : '🚚 Shipped';
    final body = lang == 'ar'
        ? 'طلبك في الطريق: $productName - $trackingNumber'
        : 'Your order is on the way: $productName - $trackingNumber';
    await showInstantNotification(title, body);
  }

  /// تذكير المشتري بالتقييم
  static Future<void> notifyBuyerRemindRating(String productName,
      {String lang = 'ar'}) async {
    final title = lang == 'ar' ? '⭐ قيم المنتج' : '⭐ Rate Product';
    final body = lang == 'ar'
        ? 'ما رأيك في $productName؟ قيمه الآن!'
        : 'How was $productName? Rate it now!';
    await showInstantNotification(title, body);
  }

  /// البائع يذكر المشتري
  static Future<void> notifySellerRemindBuyer(String buyerName,
      {String lang = 'ar'}) async {
    final title = lang == 'ar' ? '📢 تذكير' : '📢 Reminder';
    final body = lang == 'ar'
        ? 'ذكر $buyerName بالتقييم'
        : 'Reminded $buyerName to rate';
    await showInstantNotification(title, body);
  }

  /// تذكير البائع بطلب جديد
  static Future<void> notifySellerReminder(String orderId,
      {String lang = 'ar'}) async {
    final title = lang == 'ar' ? '⏰ تذكير' : '⏰ Reminder';
    final body = lang == 'ar'
        ? 'لديك طلب معلق: #$orderId'
        : 'You have a pending order: #$orderId';
    await showInstantNotification(title, body);
  }

  /// إشعار للبائع: فاتك طلب
  static Future<void> notifySellerMissedOrder(String orderId,
      {String lang = 'ar'}) async {
    final title = lang == 'ar' ? '⚠️ طلب فاتك' : '⚠️ Missed Order';
    final body =
        lang == 'ar' ? 'فاتك طلب: #$orderId' : 'You missed order: #$orderId';
    await showInstantNotification(title, body);
  }
}
