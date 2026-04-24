// lib/features/favorites/domain/models/favorite_model.dart
import '../../../../core/models/product_model.dart';

class FavoriteModel {
  final String id;
  final String userId;
  final String productId;
  final DateTime addedAt;
  final ProductModel? product;

  FavoriteModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.addedAt,
    this.product,
  });
}
