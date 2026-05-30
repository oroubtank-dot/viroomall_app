// lib/features/ads/data/repositories/ads_repository_impl.dart
import '../../domain/entities/ad_entity.dart';
import '../../domain/repositories/ads_repository.dart';
import '../datasources/ads_remote_datasource.dart';
import '../models/ad_model.dart';

class AdsRepositoryImpl implements AdsRepository {
  final AdsRemoteDataSource _remoteDataSource;

  AdsRepositoryImpl(this._remoteDataSource);

  @override
  Stream<List<AdEntity>> getActiveAuctions(String mode) {
    return _remoteDataSource.getActiveAuctions(mode).map(
        (ads) => ads.map((a) => a.toEntity()).toList());
  }

  @override
  Stream<List<AdEntity>> getFixedAds(String mode, int tier) {
    return _remoteDataSource.getFixedAds(mode, tier).map(
        (ads) => ads.map((a) => a.toEntity()).toList());
  }

  @override
  Stream<List<AdEntity>> getAdsForDisplay(String mode) {
    return _remoteDataSource.getAdsForDisplay(mode).map(
        (ads) => ads.map((a) => a.toEntity()).toList());
  }

  @override
  Future<void> placeBid(String adId, double amount, String bidderId, String bidderName) async {
    await _remoteDataSource.placeBid(adId, amount, bidderId, bidderName);
  }

  @override
  Future<void> bookFixedAd(AdEntity ad) async {
    final model = AdModel(
      id: ad.id,
      advertiserId: ad.advertiserId,
      advertiserName: ad.advertiserName,
      productId: ad.productId,
      mode: ad.mode,
      pageNumber: ad.pageNumber,
      pricingType: ad.pricingType,
      tier: ad.tier,
      pricePaid: ad.pricePaid,
      duration: ad.duration,
      startDate: ad.startDate,
      endDate: ad.endDate,
      status: ad.status,
    );
    await _remoteDataSource.bookFixedAd(model);
  }

  @override
  Future<void> cancelAd(String adId) async {
    await _remoteDataSource.cancelAd(adId);
  }
}