// lib/core/constants/pricing_config.dart
import 'product_type.dart';

class MarketPricing {
  final double publishFee;
  final double verifyBadgeMonthly;
  final double pinProductDaily;
  final double fixedBanner10Days;
  final double auctionSlot1Start;
  final double auctionSlot2Start;
  final double auctionSlot3Start;
  final double auctionIncrement;
  final int freeAdsPerMonth;

  const MarketPricing({
    required this.publishFee,
    required this.verifyBadgeMonthly,
    required this.pinProductDaily,
    required this.fixedBanner10Days,
    required this.auctionSlot1Start,
    required this.auctionSlot2Start,
    required this.auctionSlot3Start,
    required this.auctionIncrement,
    this.freeAdsPerMonth = 0,
  });
}

class PricingConfig {
  static const bool isFreePublishingPeriod = true;

  // 🏪 جملة
  static const MarketPricing wholesale = MarketPricing(
    publishFee: 50,
    verifyBadgeMonthly: 1000,
    pinProductDaily: 300,
    fixedBanner10Days: 2500,
    auctionSlot1Start: 5000,
    auctionSlot2Start: 3500,
    auctionSlot3Start: 2500,
    auctionIncrement: 500,
  );

  // 🛍️ تسوق
  static const MarketPricing shopping = MarketPricing(
    publishFee: 40,
    verifyBadgeMonthly: 800,
    pinProductDaily: 250,
    fixedBanner10Days: 2000,
    auctionSlot1Start: 4000,
    auctionSlot2Start: 3000,
    auctionSlot3Start: 2000,
    auctionIncrement: 400,
  );

  // ♻️ مستعمل
  static const MarketPricing used = MarketPricing(
    publishFee: 15,
    verifyBadgeMonthly: 300,
    pinProductDaily: 100,
    fixedBanner10Days: 1000,
    auctionSlot1Start: 1500,
    auctionSlot2Start: 1000,
    auctionSlot3Start: 700,
    auctionIncrement: 100,
  );

  // 🔥 تخفيضات وتصفية
  static const MarketPricing outlet = MarketPricing(
    publishFee: 5,
    verifyBadgeMonthly: 100,
    pinProductDaily: 30,
    fixedBanner10Days: 300,
    auctionSlot1Start: 400,
    auctionSlot2Start: 250,
    auctionSlot3Start: 150,
    auctionIncrement: 50,
    freeAdsPerMonth: 1,
  );

  static MarketPricing getPricing(ProductType type) {
    switch (type) {
      case ProductType.wholesale:
        return wholesale;
      case ProductType.shopping:
        return shopping;
      case ProductType.used:
        return used;
      case ProductType.outlet:
        return outlet;
    }
  }
}
