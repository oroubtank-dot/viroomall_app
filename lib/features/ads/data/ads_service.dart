// lib/features/ads/data/ads_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/models/ad_subscription_model.dart';

/// =============================================
/// 🗄️ Ads Service - التعامل مع Firestore
/// =============================================
class AdsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // =============================================
  // 📊 المزادات (Auction)
  // =============================================

  /// الحصول على المزادات النشطة لوضع معين
  Stream<List<AdSubscriptionModel>> getActiveAuctions(String mode) {
    return _firestore
        .collection('ad_subscriptions')
        .where('mode', isEqualTo: mode)
        .where('pricingType', isEqualTo: 'bidding')
        .where('status', isEqualTo: 'active')
        .orderBy('pageNumber', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AdSubscriptionModel.fromFirestore(doc))
            .toList());
  }

  /// تقديم عرض في مزاد
  Future<void> placeBid({
    required String subscriptionId,
    required double bidAmount,
    required String bidderId,
    required String bidderName,
  }) async {
    await _firestore.collection('ad_subscriptions').doc(subscriptionId).update({
      'pricePaid': bidAmount,
      'advertiserId': bidderId,
      'advertiserName': bidderName,
    });

    // تسجيل سجل المزايدة
    await _firestore.collection('ad_bids').add({
      'subscriptionId': subscriptionId,
      'bidderId': bidderId,
      'bidderName': bidderName,
      'amount': bidAmount,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// إنشاء مزاد جديد (لأول مرة)
  Future<String> createAuction({
    required String advertiserId,
    required String advertiserName,
    required String productId,
    required String mode,
    required int pageNumber,
    required double pricePaid,
    required String duration,
  }) async {
    final startDate = DateTime.now();
    final endDate = startDate
        .add(Duration(days: AdSubscriptionModel.getDurationDays(duration)));

    final docRef = await _firestore.collection('ad_subscriptions').add({
      'advertiserId': advertiserId,
      'advertiserName': advertiserName,
      'productId': productId,
      'mode': mode,
      'pageNumber': pageNumber,
      'pricingType': 'bidding',
      'tier': 1,
      'pricePaid': pricePaid,
      'duration': duration,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'status': 'active',
      'subscriberNumber': 0,
      'createdAt': Timestamp.fromDate(startDate),
    });

    return docRef.id;
  }

  /// إلغاء مزاد
  Future<void> cancelAuction(String subscriptionId) async {
    await _firestore.collection('ad_subscriptions').doc(subscriptionId).update({
      'status': 'cancelled',
    });
  }

  // =============================================
  // 📝 الحجوزات (Fixed Price)
  // =============================================

  /// الحصول على الحجوزات النشطة لوضع معين
  Stream<List<AdSubscriptionModel>> getActiveFixedAds(String mode, int tier) {
    return _firestore
        .collection('ad_subscriptions')
        .where('mode', isEqualTo: mode)
        .where('pricingType', isEqualTo: 'fixed')
        .where('tier', isEqualTo: tier)
        .where('status', isEqualTo: 'active')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AdSubscriptionModel.fromFirestore(doc))
            .toList());
  }

  /// حجز إعلان بسعر ثابت
  Future<void> bookFixedAd({
    required String advertiserId,
    required String advertiserName,
    required String productId,
    required String mode,
    required int tier,
    required int pageNumber,
    required double pricePaid,
    required String duration,
  }) async {
    final startDate = DateTime.now();
    final endDate = startDate
        .add(Duration(days: AdSubscriptionModel.getDurationDays(duration)));

    // التحقق من عدد المشتركين الحاليين
    final countSnapshot = await _firestore
        .collection('ad_subscriptions')
        .where('mode', isEqualTo: mode)
        .where('pricingType', isEqualTo: 'fixed')
        .where('tier', isEqualTo: tier)
        .where('status', isEqualTo: 'active')
        .get();

    final subscriberNumber = countSnapshot.docs.length + 1;

    // حساب السعر النهائي
    final finalPrice = AdSubscriptionModel.calculatePrice(
      tier: tier,
      pageNumber: pageNumber,
      duration: duration,
      subscriberNumber: subscriberNumber,
    );

    await _firestore.collection('ad_subscriptions').add({
      'advertiserId': advertiserId,
      'advertiserName': advertiserName,
      'productId': productId,
      'mode': mode,
      'pageNumber': pageNumber,
      'pricingType': 'fixed',
      'tier': tier,
      'pricePaid': finalPrice,
      'duration': duration,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'status': 'active',
      'subscriberNumber': subscriberNumber,
      'createdAt': Timestamp.fromDate(startDate),
    });
  }

  /// إلغاء حجز
  Future<void> cancelFixedAd(String subscriptionId) async {
    await _firestore.collection('ad_subscriptions').doc(subscriptionId).update({
      'status': 'cancelled',
    });
  }

  // =============================================
  // 🎯 الإعلانات النشطة للعرض
  // =============================================

  /// الحصول على الإعلانات النشطة للسلايدر
  Stream<List<AdSubscriptionModel>> getActiveAdsForDisplay(String mode) {
    return _firestore
        .collection('ad_subscriptions')
        .where('mode', isEqualTo: mode)
        .where('status', isEqualTo: 'active')
        .orderBy('pageNumber', descending: false)
        .limit(6)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AdSubscriptionModel.fromFirestore(doc))
            .toList());
  }

  /// الحصول على إعلانات الصفحة الأولى فقط
  Stream<List<AdSubscriptionModel>> getFirstPageAds(String mode) {
    return _firestore
        .collection('ad_subscriptions')
        .where('mode', isEqualTo: mode)
        .where('pageNumber', isEqualTo: 1)
        .where('status', isEqualTo: 'active')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AdSubscriptionModel.fromFirestore(doc))
            .toList());
  }
}
