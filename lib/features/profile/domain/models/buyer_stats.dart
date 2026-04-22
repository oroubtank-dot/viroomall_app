// lib/features/profile/domain/models/buyer_stats.dart

class BuyerStats {
  final int totalOrders;
  final int favoritesCount;
  final int points;

  BuyerStats({
    this.totalOrders = 0,
    this.favoritesCount = 0,
    this.points = 0,
  });

  factory BuyerStats.fromFirestore(Map<String, dynamic> data) {
    return BuyerStats(
      totalOrders: data['totalOrders'] ?? 0,
      favoritesCount: data['favoritesCount'] ?? 0,
      points: data['points'] ?? 0,
    );
  }

  static BuyerStats mock() {
    return BuyerStats(
      totalOrders: 8,
      favoritesCount: 45,
      points: 2450,
    );
  }
}
