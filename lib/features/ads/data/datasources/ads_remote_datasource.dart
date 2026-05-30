// lib/features/ads/data/datasources/ads_remote_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/ad_subscription_model.dart';

class AdsRemoteDataSource {
  final FirebaseFirestore _firestore;

  AdsRemoteDataSource(this._firestore);

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

  Stream<List<AdSubscriptionModel>> getFixedAds(String mode, int tier) {
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

  Stream<List<AdSubscriptionModel>> getAdsForDisplay(String mode) {
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
}
