// lib/features/reviews/presentation/providers/reviews_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/review_model.dart';
import '../../data/reviews_service.dart';

final reviewsServiceProvider = Provider<ReviewsService>((ref) {
  return ReviewsService();
});

final productReviewsProvider =
    StreamProvider.family<List<ReviewModel>, String>((ref, productId) {
  final service = ref.watch(reviewsServiceProvider);
  return service.getProductReviews(productId);
});

final productRatingProvider =
    FutureProvider.family<double, String>((ref, productId) {
  final service = ref.watch(reviewsServiceProvider);
  return service.getAverageRating(productId);
});

final productReviewCountProvider =
    FutureProvider.family<int, String>((ref, productId) {
  final service = ref.watch(reviewsServiceProvider);
  return service.getReviewCount(productId);
});
