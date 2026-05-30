// lib/features/product/domain/entities/product_entity.dart
import '../../../../core/constants/market_type.dart';

class ProductEntity {
  final String id;
  final String sellerId;
  final String sellerName;
  final String title;
  final String description;
  final double price;
  final double? originalPrice;
  final MarketType marketType;
  final String categoryId;
  final List<String> images;
  final String? videoUrl;
  final String condition;
  final String? defects;
  final String location;
  final int views;
  final int favorites;
  final String status;
  final int qualityScore;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final double averageRating;
  final int ratingCount;

  ProductEntity({
    required this.id,
    required this.sellerId,
    required this.sellerName,
    required this.title,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.marketType,
    required this.categoryId,
    required this.images,
    this.videoUrl,
    required this.condition,
    this.defects,
    required this.location,
    this.views = 0,
    this.favorites = 0,
    this.status = 'approved',
    this.qualityScore = 0,
    required this.createdAt,
    this.expiresAt,
    this.averageRating = 0.0,
    this.ratingCount = 0,
  });
}
