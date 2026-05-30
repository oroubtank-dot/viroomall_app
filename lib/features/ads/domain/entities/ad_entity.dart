// lib/features/ads/domain/entities/ad_entity.dart

class AdEntity {
  final String id;
  final String advertiserId;
  final String advertiserName;
  final String productId;
  final String mode;
  final int pageNumber;
  final String pricingType;
  final int tier;
  final double pricePaid;
  final String duration;
  final DateTime startDate;
  final DateTime endDate;
  final String status;

  AdEntity({
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
  });

  bool get isActive => status == 'active';
  bool get isBidding => pricingType == 'bidding';
  bool get isExpired => endDate.isBefore(DateTime.now());
  int get daysLeft => endDate.difference(DateTime.now()).inDays;
}
