// lib/core/services/notification_service.dart
// ignore_for_file: avoid_print

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';

class VirooNotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // =============================================
  // 🚀 تهيئة الإشعارات
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
          message.notification.hashCode,
          message.notification!.title,
          message.notification!.body,
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

    // الحصول على FCM Token وحفظه
    _messaging.getToken().then((token) {
      print('🔑 FCM Token: $token');
      _saveToken(token);
    });
  }

  // =============================================
  // 💾 حفظ الـ Token في Firestore
  // =============================================
  static Future<void> _saveToken(String? token) async {
    if (token == null) return;
    try {
      final user = AuthService.currentUser;
      if (user == null) return;
      
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'fcmToken': token,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('❌ خطأ في حفظ الـ FCM Token: $e');
    }
  }

  // =============================================
  // 📤 إرسال إشعار لبائع معين
  // =============================================
  static Future<void> sendNotificationToUser({
    required String userId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      // جلب Token المستخدم
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      
      final token = doc.data()?['fcmToken'];
      if (token == null || token.isEmpty) return;

      // حفظ الإشعار في Firestore
      await FirebaseFirestore.instance.collection('notifications').add({
        'userId': userId,
        'title': title,
        'body': body,
        'data': data ?? {},
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // TODO: إرسال الإشعار عبر FCM (هيضاف بعدين)
      
    } catch (e) {
      print('❌ خطأ في إرسال الإشعار: $e');
    }
  }

  // =============================================
  // 📦 إشعار للبائع عند طلب جديد
  // =============================================
  static Future<void> notifySellerNewOrder({
    required String sellerId,
    required String productName,
    required String buyerName,
  }) async {
    await sendNotificationToUser(
      userId: sellerId,
      title: '🛍️ طلب جديد!',
      body: '$buyerName طلب منتج "$productName"',
      data: {
        'type': 'new_order',
        'productName': productName,
      },
    );
    
    // إشعار محلي فوري (للتجربة)
    showInstantNotification(
      '🛍️ طلب جديد!',
      '$buyerName طلب منتج "$productName"',
    );
  }

  // =============================================
  // ✅ إشعار للمشتري عند قبول الطلب
  // =============================================
  static Future<void> notifyBuyerOrderAccepted({
    required String buyerId,
    required String productName,
  }) async {
    await sendNotificationToUser(
      userId: buyerId,
      title: '✅ تم قبول طلبك',
      body: 'البائع وافق على طلبك لمنتج "$productName"',
      data: {
        'type': 'order_accepted',
        'productName': productName,
      },
    );
    
    showInstantNotification(
      '✅ تم قبول طلبك',
      'البائع وافق على طلبك لمنتج "$productName"',
    );
  }

  // =============================================
  // 📦 إشعار بتغيير حالة الطلب
  // =============================================
  static Future<void> notifyOrderStatusChanged({
    required String userId,
    required String productName,
    required String status,
  }) async {
    final statusLabels = {
      'preparing': 'جاري التجهيز',
      'shipped': 'تم الشحن',
      'outForDelivery': 'خارج للتوصيل',
      'delivered': 'تم التسليم',
    };
    
    final label = statusLabels[status] ?? status;
    
    await sendNotificationToUser(
      userId: userId,
      title: '📦 تحديث الطلب',
      body: 'طلبك للمنتج "$productName" أصبح بحالة "$label"',
      data: {
        'type': 'order_status_changed',
        'status': status,
        'productName': productName,
      },
    );
    
    showInstantNotification(
      '📦 تحديث الطلب',
      'طلبك للمنتج "$productName" أصبح بحالة "$label"',
    );
  }

  // =============================================
  // 🔔 إشعار فوري (محلي)
  // =============================================
  static void showInstantNotification(String title, String body) {
    _localNotifications.show(
      DateTime.now().millisecond,
      title,
      body,
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
  // ❌ إلغاء كل الإشعارات
  // =============================================
  static Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  // =============================================
  // ❌ إلغاء إشعار معين
  // =============================================
  static Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }
}