// lib/features/reviews/domain/models/review_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final List<String> images;
  final int likes;
  final String sellerReply;

  ReviewModel({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.images = const [],
    this.likes = 0,
    this.sellerReply = '',
  });

  factory ReviewModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReviewModel(
      id: doc.id,
      productId: data['productId'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'مستخدم VirooMall',
      rating: (data['rating'] ?? 5).toDouble(),
      comment: data['comment'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      images: data['images'] is List ? List<String>.from(data['images']) : [],
      likes: data['likes'] ?? 0,
      sellerReply: data['sellerReply'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'productId': productId,
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'createdAt': Timestamp.fromDate(createdAt),
      'images': images,
      'likes': likes,
      'sellerReply': sellerReply,
    };
  }

  String get ratingLabel {
    if (rating >= 5) return '⭐ ممتاز';
    if (rating >= 4) return '👍 جيد جداً';
    if (rating >= 3) return '👌 جيد';
    if (rating >= 2) return '😐 مقبول';
    return '👎 سيء';
  }
}
