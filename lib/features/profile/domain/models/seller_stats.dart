// lib/features/profile/domain/models/seller_stats.dart

class SellerStats {
  final int totalViews;
  final int totalClicks;
  final int totalSales;
  final double walletBalance;
  final int activeProducts;
  final int expiringProducts;
  final int expiredProducts;
  final int totalProducts;
  final int totalPoints;

  SellerStats({
    this.totalViews = 0,
    this.totalClicks = 0,
    this.totalSales = 0,
    this.walletBalance = 0.0,
    this.activeProducts = 0,
    this.expiringProducts = 0,
    this.expiredProducts = 0,
    this.totalProducts = 0,
    this.totalPoints = 0,
  });

  factory SellerStats.fromFirestore(Map<String, dynamic> data) {
    return SellerStats(
      totalViews: data['totalViews'] ?? 0,
      totalClicks: data['totalClicks'] ?? 0,
      totalSales: data['totalSales'] ?? 0,
      walletBalance: (data['walletBalance'] ?? 0).toDouble(),
      activeProducts: data['activeProducts'] ?? 0,
      expiringProducts: data['expiringProducts'] ?? 0,
      expiredProducts: data['expiredProducts'] ?? 0,
      totalProducts: data['totalProducts'] ?? 0,
      totalPoints: data['totalPoints'] ?? 0,
    );
  }

  static SellerStats mock() {
    return SellerStats(
      totalViews: 127,
      totalClicks: 2456,
      totalSales: 89,
      walletBalance: 15600.0,
      activeProducts: 12,
      expiringProducts: 3,
      expiredProducts: 2,
      totalProducts: 17,
      totalPoints: 2450,
    );
  }
}
