// lib/features/ads/domain/models/ad_subscription_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

/// =============================================
/// 📊 نموذج الاشتراك الإعلاني
/// =============================================
///
/// نظام الاشتراكات الإعلانية:
/// - 4 أوضاع (تسوق، جملة، مستعمل، فرز)
/// - الصفحات 1-5: مزاد كل 10 أيام
/// - الصفحات 6-10: سعر ثابت 150 ج
/// - الصفحات 11-20: سعر ثابت 100 ج
/// - المدد: 5 أيام لـ سنة
/// =============================================
class AdSubscriptionModel {
  final String id;
  final String advertiserId; // معرف المعلن (البائع)
  final String advertiserName; // اسم المعلن
  final String productId; // معرف المنتج المعلن عنه
  final String mode; // shopping, wholesale, used, outlet
  final int pageNumber; // 1-20
  final String pricingType; // bidding (مزاد), fixed (ثابت)
  final int tier; // 1=1-5, 2=6-10, 3=11-20
  final double pricePaid; // السعر المدفوع
  final String
      duration; // 5_days, 10_days, 20_days, 1_month, 3_months, 6_months, 12_months
  final DateTime startDate;
  final DateTime endDate;
  final String status; // active, expired, cancelled
  final int subscriberNumber; // رقم المشترك (للتحكم بالتسعير)
  final DateTime createdAt;

  AdSubscriptionModel({
    required this.id,
    required this.advertiserId,
    required this.advertiserName,
    required this.productId,
    required this.mode,
    required this.pageNumber,
    required this.pricingType,
    required this.tier,
    required this.pricePaid,
    required this.duration,
    required this.startDate,
    required this.endDate,
    this.status = 'active',
    this.subscriberNumber = 0,
    required this.createdAt,
  });

  /// =============================================
  /// 📅 حساب مدة الاشتراك
  /// =============================================
  static int getDurationDays(String duration) {
    switch (duration) {
      case '5_days':
        return 5;
      case '10_days':
        return 10;
      case '20_days':
        return 20;
      case '1_month':
        return 30;
      case '3_months':
        return 90;
      case '6_months':
        return 180;
      case '12_months':
        return 365;
      default:
        return 10;
    }
  }

  /// =============================================
  /// 💰 حساب السعر حسب المستوى والصفحة والمدة
  /// =============================================
  static double calculatePrice({
    required int tier,
    required int pageNumber,
    required String duration,
    required int subscriberNumber,
  }) {
    // السعر الأساسي
    double basePrice;
    if (tier == 1) {
      // الصفحات 1-5 - مزاد
      switch (pageNumber) {
        case 1:
          basePrice = 500;
          break;
        case 2:
          basePrice = 400;
          break;
        case 3:
          basePrice = 300;
          break;
        case 4:
          basePrice = 250;
          break;
        case 5:
          basePrice = 200;
          break;
        default:
          basePrice = 200;
      }
    } else if (tier == 2) {
      // الصفحات 6-10 - سعر ثابت
      basePrice = 150;
    } else {
      // الصفحات 11-20 - سعر ثابت
      basePrice = 100;
    }

    // خصم حسب عدد المشتركين
    double subscriberDiscount = 1.0;
    if (subscriberNumber <= 10) {
      subscriberDiscount = 0.7; // خصم 30%
    } else if (subscriberNumber <= 20) {
      subscriberDiscount = 0.8; // خصم 20%
    }

    // خصم حسب المدة
    double durationMultiplier;
    double durationDiscount;
    switch (duration) {
      case '5_days':
        durationMultiplier = 5.0 / 30.0;
        durationDiscount = 1.0;
        break;
      case '10_days':
        durationMultiplier = 10.0 / 30.0;
        durationDiscount = 0.95;
        break;
      case '20_days':
        durationMultiplier = 20.0 / 30.0;
        durationDiscount = 0.90;
        break;
      case '1_month':
        durationMultiplier = 1.0;
        durationDiscount = 0.85;
        break;
      case '3_months':
        durationMultiplier = 3.0;
        durationDiscount = 0.80;
        break;
      case '6_months':
        durationMultiplier = 6.0;
        durationDiscount = 0.75;
        break;
      case '12_months':
        durationMultiplier = 12.0;
        durationDiscount = 0.70;
        break;
      default:
        durationMultiplier = 10.0 / 30.0;
        durationDiscount = 1.0;
    }

    double price =
        basePrice * durationMultiplier * subscriberDiscount * durationDiscount;
    return double.parse(price.toStringAsFixed(0));
  }

  /// =============================================
  /// 🏷️ اسم المدة بالعربي
  /// =============================================
  static String getDurationLabel(String duration) {
    switch (duration) {
      case '5_days':
        return '5 أيام';
      case '10_days':
        return '10 أيام';
      case '20_days':
        return '20 يوم';
      case '1_month':
        return 'شهر';
      case '3_months':
        return '3 شهور';
      case '6_months':
        return '6 شهور';
      case '12_months':
        return 'سنة';
      default:
        return '10 أيام';
    }
  }

  /// =============================================
  /// 🏷️ اسم المستوى بالعربي
  /// =============================================
  static String getTierLabel(int tier) {
    switch (tier) {
      case 1:
        return '🥇 مميز (مزاد)';
      case 2:
        return '🥈 متوسط';
      case 3:
        return '🥉 أساسي';
      default:
        return 'أساسي';
    }
  }

  /// =============================================
  /// 📄 من Firestore
  /// =============================================
  factory AdSubscriptionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AdSubscriptionModel(
      id: doc.id,
      advertiserId: data['advertiserId'] ?? '',
      advertiserName: data['advertiserName'] ?? '',
      productId: data['productId'] ?? '',
      mode: data['mode'] ?? 'shopping',
      pageNumber: data['pageNumber'] ?? 1,
      pricingType: data['pricingType'] ?? 'fixed',
      tier: data['tier'] ?? 3,
      pricePaid: (data['pricePaid'] ?? 0).toDouble(),
      duration: data['duration'] ?? '10_days',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      status: data['status'] ?? 'active',
      subscriberNumber: data['subscriberNumber'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  /// =============================================
  /// 📤 إلى Firestore
  /// =============================================
  Map<String, dynamic> toFirestore() {
    return {
      'advertiserId': advertiserId,
      'advertiserName': advertiserName,
      'productId': productId,
      'mode': mode,
      'pageNumber': pageNumber,
      'pricingType': pricingType,
      'tier': tier,
      'pricePaid': pricePaid,
      'duration': duration,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'status': status,
      'subscriberNumber': subscriberNumber,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
