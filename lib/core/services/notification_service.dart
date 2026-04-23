// lib/core/services/notification_service.dart
// ignore_for_file: avoid_print

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class VirooNotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // =============================================
  // تهيئة الإشعارات
  // =============================================
  static Future<void> init() async {
    // طلب إذن المستخدم للإشعارات
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // إعدادات الأندرويد
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // إعدادات iOS
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // إعدادات التهيئة
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(initializationSettings);

    // إنشاء Channel للأندرويد
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'viroo_channel',
      'Viroo Orders',
      description: 'إشعارات الطلبات والعروض',
      importance: Importance.max,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // استقبال الإشعارات لما التطبيق مفتوح
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _localNotifications.show(
          message.notification.hashCode, // id
          message.notification!.title, // title
          message.notification!.body, // body
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'viroo_channel',
              'Viroo Orders',
              channelDescription: 'إشعارات الطلبات والعروض',
              importance: Importance.max,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          payload: message.data.toString(),
        );
      }
    });

    // الحصول على FCM Token
    _messaging.getToken().then((token) {
      print('🔑 FCM Token: $token');
    });
  }

  // =============================================
  // إشعار فوري
  // =============================================
  static void showInstantNotification(String title, String body) {
    _localNotifications.show(
      0, // id
      title, // title
      body, // body
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'viroo_channel',
          'Viroo Orders',
          channelDescription: 'إشعارات الطلبات والعروض',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  // =============================================
  // إشعار للبائع عند طلب جديد
  // =============================================
  static void notifySellerNewOrder(String productName, String buyerName) {
    showInstantNotification(
      '🛍️ طلب جديد!',
      '$buyerName طلب منتج "$productName"',
    );
  }

  // =============================================
  // إشعار للمشتري عند قبول الطلب
  // =============================================
  static void notifyBuyerOrderAccepted(String productName) {
    showInstantNotification(
      '✅ تم قبول طلبك',
      'البائع وافق على طلبك لمنتج "$productName"',
    );
  }

  // =============================================
  // إشعار تذكيري
  // =============================================
  static void showReminderNotification(String title, String body) {
    _localNotifications.show(
      DateTime.now().millisecond, // id
      title, // title
      body, // body
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'viroo_reminder',
          'Viroo Reminders',
          channelDescription: 'تذكيرات وعروض',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  // =============================================
  // إلغاء كل الإشعارات
  // =============================================
  static Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  // =============================================
  // إلغاء إشعار معين
  // =============================================
  static Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }
}
