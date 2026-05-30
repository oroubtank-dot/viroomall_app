// lib/features/ads/data/repositories/ads_repository_impl.dart
import '../../domain/models/ad_subscription_model.dart';
import '../../domain/repositories/ads_repository.dart';
import '../datasources/ads_remote_datasource.dart';
import '../../domain/entities/ad_entity.dart';

class AdsRepositoryImpl implements AdsRepository {
  final AdsRemoteDataSource _remoteDataSource;

  AdsRepositoryImpl(this._remoteDataSource);

  @override
  Stream<List<AdEntity>> getActiveAuctions(String mode) {
    return _remoteDataSource
        .getActiveAuctions(mode)
        .map((ads) => ads.map((a) => _toEntity(a)).toList());
  }

  @override
  Stream<List<AdEntity>> getFixedAds(String mode, int tier) {
    return _remoteDataSource
        .getFixedAds(mode, tier)
        .map((ads) => ads.map((a) => _toEntity(a)).toList());
  }

  @override
  Stream<List<AdEntity>> getAdsForDisplay(String mode) {
    return _remoteDataSource
        .getAdsForDisplay(mode)
        .map((ads) => ads.map((a) => _toEntity(a)).toList());
  }

  AdEntity _toEntity(AdSubscriptionModel model) {
    return AdEntity(
      id: model.id,
      advertiserId: model.advertiserId,
      advertiserName: model.advertiserName,
      productId: model.productId,
      mode: model.mode,
      pageNumber: model.pageNumber,
      pricingType: model.pricingType,
      tier: model.tier,
      pricePaid: model.pricePaid,
      duration: model.duration,
      startDate: model.startDate,
      endDate: model.endDate,
      status: model.status,
    );
  }

  @override
  Future<void> placeBid(
      String adId, double amount, String bidderId, String bidderName) async {
    // Use the old ads_service for bidding
  }

  @override
  Future<void> bookFixedAd(AdEntity ad) async {
    // Use the old ads_service for booking
  }

  @override
  Future<void> cancelAd(String adId) async {
    // Use the old ads_service for cancel
  }
}
