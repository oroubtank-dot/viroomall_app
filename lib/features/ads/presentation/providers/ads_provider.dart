// lib/features/ads/presentation/providers/ads_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/ad_subscription_model.dart';
import '../../data/ads_service.dart';

/// =============================================
/// 🎯 Ads Provider - إدارة حالة الإعلانات
/// =============================================
final adsServiceProvider = Provider<AdsService>((ref) {
  return AdsService();
});

/// المزادات النشطة حسب الوضع
final activeAuctionsProvider =
    StreamProvider.family<List<AdSubscriptionModel>, String>((ref, mode) {
  final adsService = ref.watch(adsServiceProvider);
  return adsService.getActiveAuctions(mode);
});

/// الحجوزات الثابتة حسب الوضع والمستوى
final activeFixedAdsProvider =
    StreamProvider.family<List<AdSubscriptionModel>, ({String mode, int tier})>(
        (ref, params) {
  final adsService = ref.watch(adsServiceProvider);
  return adsService.getActiveFixedAds(params.mode, params.tier);
});

/// إعلانات السلايدر حسب الوضع
final displayAdsProvider =
    StreamProvider.family<List<AdSubscriptionModel>, String>((ref, mode) {
  final adsService = ref.watch(adsServiceProvider);
  return adsService.getActiveAdsForDisplay(mode);
});

/// إعلانات الصفحة الأولى
final firstPageAdsProvider =
    StreamProvider.family<List<AdSubscriptionModel>, String>((ref, mode) {
  final adsService = ref.watch(adsServiceProvider);
  return adsService.getFirstPageAds(mode);
});
