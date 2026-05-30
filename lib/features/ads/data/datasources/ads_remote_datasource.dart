// lib/features/ads/data/datasources/ads_remote_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ad_model.dart';

class AdsRemoteDataSource {
  final FirebaseFirestore _firestore;

  AdsRemoteDataSource(this._firestore);

  Stream<List<AdModel>> getActiveAuctions(String mode) {
    return _firestore
        .collection('ad_subscriptions')
        .where('mode', isEqualTo: mode)
        .where('pricingType', isEqualTo: 'bidding')
        .where('status', isEqualTo: 'active')
        .orderBy('pageNumber', descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => AdModel.fromFirestore(doc)).toList());
  }

  Stream<List<AdModel>> getFixedAds(String mode, int tier) {
    return _firestore
        .collection('ad_subscriptions')
        .where('mode', isEqualTo: mode)
        .where('pricingType', isEqualTo: 'fixed')
        .where('tier', isEqualTo: tier)
        .where('status', isEqualTo: 'active')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => AdModel.fromFirestore(doc)).toList());
  }

  Stream<List<AdModel>> getAdsForDisplay(String mode) {
    return _firestore
        .collection('ad_subscriptions')
        .where('mode', isEqualTo: mode)
        .where('status', isEqualTo: 'active')
        .orderBy('pageNumber', descending: false)
        .limit(6)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => AdModel.fromFirestore(doc)).toList());
  }

  Future<void> placeBid(
      String adId, double amount, String bidderId, String bidderName) async {
    await _firestore.collection('ad_subscriptions').doc(adId).update({
      'pricePaid': amount,
      'advertiserId': bidderId,
      'advertiserName': bidderName,
    });
    await _firestore.collection('ad_bids').add({
      'adId': adId,
      'bidderId': bidderId,
      'bidderName': bidderName,
      'amount': amount,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> bookFixedAd(AdModel ad) async {
    await _firestore.collection('ad_subscriptions').add(ad.toFirestore());
  }

  Future<void> cancelAd(String adId) async {
    await _firestore
        .collection('ad_subscriptions')
        .doc(adId)
        .update({'status': 'cancelled'});
  }
}
