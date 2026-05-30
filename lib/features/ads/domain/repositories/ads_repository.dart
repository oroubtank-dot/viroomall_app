// lib/features/ads/domain/repositories/ads_repository.dart
import '../entities/ad_entity.dart';

abstract class AdsRepository {
  Stream<List<AdEntity>> getActiveAuctions(String mode);
  Stream<List<AdEntity>> getFixedAds(String mode, int tier);
  Stream<List<AdEntity>> getAdsForDisplay(String mode);
  Future<void> placeBid(
      String adId, double amount, String bidderId, String bidderName);
  Future<void> bookFixedAd(AdEntity ad);
  Future<void> cancelAd(String adId);
}
