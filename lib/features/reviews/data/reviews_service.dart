// lib/features/reviews/data/reviews_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/models/review_model.dart';

class ReviewsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // =============================================
  // ⭐ جلب تقييمات منتج
  // =============================================
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

  // =============================================
  // 📊 حساب متوسط التقييم
  // =============================================
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

  // =============================================
  // 🔢 عدد التقييمات
  // =============================================
  Future<int> getReviewCount(String productId) async {
    final snapshot = await _firestore
        .collection('reviews')
        .where('productId', isEqualTo: productId)
        .get();
    return snapshot.docs.length;
  }

  // =============================================
  // ✍️ إضافة تقييم
  // =============================================
  Future<void> addReview(ReviewModel review) async {
    await _firestore.collection('reviews').add(review.toFirestore());

    // تحديث متوسط التقييم في المنتج
    await _updateProductRating(review.productId);
  }

  // =============================================
  // 🔄 تحديث تقييم المنتج
  // =============================================
  Future<void> _updateProductRating(String productId) async {
    final avg = await getAverageRating(productId);
    final count = await getReviewCount(productId);

    await _firestore.collection('products').doc(productId).update({
      'averageRating': avg,
      'ratingCount': count,
    });
  }

  // =============================================
  // 💬 رد البائع على تقييم
  // =============================================
  Future<void> updateSellerReply(String reviewId, String reply) async {
    await _firestore.collection('reviews').doc(reviewId).update({
      'sellerReply': reply,
    });
  }

  // =============================================
  // 🗑️ حذف تقييم
  // =============================================
  Future<void> deleteReview(String reviewId) async {
    final doc = await _firestore.collection('reviews').doc(reviewId).get();
    final productId = doc.data()?['productId'];
    await doc.reference.delete();
    if (productId != null) {
      await _updateProductRating(productId);
    }
  }
}
