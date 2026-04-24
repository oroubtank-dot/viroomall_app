// lib/features/reviews/data/reviews_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/models/review_model.dart';

class ReviewsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // الحصول على تقييمات منتج
  Stream<List<ReviewModel>> getProductReviews(String productId) {
    return _firestore
        .collection('reviews')
        .where('productId', isEqualTo: productId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ReviewModel.fromFirestore(doc))
            .toList());
  }

  // الحصول على متوسط التقييم
  Future<double> getAverageRating(String productId) async {
    final snapshot = await _firestore
        .collection('reviews')
        .where('productId', isEqualTo: productId)
        .get();

    if (snapshot.docs.isEmpty) return 0.0;

    double total = 0;
    for (var doc in snapshot.docs) {
      total += (doc.data()['rating'] ?? 5).toDouble();
    }
    return double.parse((total / snapshot.docs.length).toStringAsFixed(1));
  }

  // الحصول على عدد التقييمات
  Future<int> getReviewCount(String productId) async {
    final snapshot = await _firestore
        .collection('reviews')
        .where('productId', isEqualTo: productId)
        .get();
    return snapshot.docs.length;
  }

  // إضافة تقييم
  Future<void> addReview(ReviewModel review) async {
    await _firestore.collection('reviews').add(review.toFirestore());
  }

  // تحديث رد البائع
  Future<void> updateSellerReply(String reviewId, String reply) async {
    await _firestore.collection('reviews').doc(reviewId).update({
      'sellerReply': reply,
    });
  }

  // حذف تقييم
  Future<void> deleteReview(String reviewId) async {
    await _firestore.collection('reviews').doc(reviewId).delete();
  }
}
