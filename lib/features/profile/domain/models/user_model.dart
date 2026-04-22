// lib/features/profile/domain/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? photoUrl;
  final String userType; // 'buyer', 'seller', 'store'
  final double rating;
  final int ratingCount;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.photoUrl,
    required this.userType,
    this.rating = 0.0,
    this.ratingCount = 0,
    required this.createdAt,
  });

  bool get isSeller => userType == 'seller' || userType == 'store';
  bool get isBuyer => userType == 'buyer';

  factory UserModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'],
      photoUrl: data['photoUrl'],
      userType: data['userType'] ?? 'buyer',
      rating: (data['rating'] ?? 0).toDouble(),
      ratingCount: data['ratingCount'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'photoUrl': photoUrl,
      'userType': userType,
      'rating': rating,
      'ratingCount': ratingCount,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  static UserModel mockBuyer() {
    return UserModel(
      id: 'buyer_001',
      name: 'سارة أحمد',
      phone: '+201001234567',
      email: 'sara@example.com',
      photoUrl: null,
      userType: 'buyer',
      rating: 0.0,
      ratingCount: 0,
      createdAt: DateTime.now(),
    );
  }

  static UserModel mockSeller() {
    return UserModel(
      id: 'seller_001',
      name: 'أحمد محمد',
      phone: '+201001234567',
      email: 'ahmed@example.com',
      photoUrl: null,
      userType: 'seller',
      rating: 4.8,
      ratingCount: 156,
      createdAt: DateTime.now(),
    );
  }
}
