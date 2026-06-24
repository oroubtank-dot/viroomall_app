// lib/features/profile/domain/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String photoUrl;
  final bool isSeller;
  final bool isBuyer;
  final DateTime createdAt;
  final double rating;
  final int totalSales;
  final int totalProducts;
  final int totalViews;

  // 🆕 حقول المتجر (للبائع)
  final String storeName;
  final String storeDescription;
  final String storePhone;
  final String storeAddress;
  final String coverPhoto;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.photoUrl,
    required this.isSeller,
    required this.isBuyer,
    required this.createdAt,
    this.rating = 0.0,
    this.totalSales = 0,
    this.totalProducts = 0,
    this.totalViews = 0,
    this.storeName = '',
    this.storeDescription = '',
    this.storePhone = '',
    this.storeAddress = '',
    this.coverPhoto = '',
  });

  /// تحويل من Firestore Document إلى UserModel
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      isSeller: data['isSeller'] ?? false,
      isBuyer: data['isBuyer'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      rating: (data['rating'] ?? 0).toDouble(),
      totalSales: data['totalSales'] ?? 0,
      totalProducts: data['totalProducts'] ?? 0,
      totalViews: data['totalViews'] ?? 0,
      storeName: data['storeName'] ?? data['name'] ?? '',
      storeDescription: data['storeDescription'] ?? '',
      storePhone: data['storePhone'] ?? data['phone'] ?? '',
      storeAddress: data['storeAddress'] ?? '',
      coverPhoto: data['coverPhoto'] ?? '',
    );
  }

  /// تحويل UserModel إلى Map للحفظ في Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'isSeller': isSeller,
      'isBuyer': isBuyer,
      'createdAt': Timestamp.fromDate(createdAt),
      'rating': rating,
      'totalSales': totalSales,
      'totalProducts': totalProducts,
      'totalViews': totalViews,
      'storeName': storeName,
      'storeDescription': storeDescription,
      'storePhone': storePhone,
      'storeAddress': storeAddress,
      'coverPhoto': coverPhoto,
    };
  }

  /// نسخة من المستخدم مع تعديل بعض الحقول
  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    bool? isSeller,
    bool? isBuyer,
    double? rating,
    int? totalSales,
    int? totalProducts,
    int? totalViews,
    String? storeName,
    String? storeDescription,
    String? storePhone,
    String? storeAddress,
    String? coverPhoto,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      isSeller: isSeller ?? this.isSeller,
      isBuyer: isBuyer ?? this.isBuyer,
      createdAt: createdAt,
      rating: rating ?? this.rating,
      totalSales: totalSales ?? this.totalSales,
      totalProducts: totalProducts ?? this.totalProducts,
      totalViews: totalViews ?? this.totalViews,
      storeName: storeName ?? this.storeName,
      storeDescription: storeDescription ?? this.storeDescription,
      storePhone: storePhone ?? this.storePhone,
      storeAddress: storeAddress ?? this.storeAddress,
      coverPhoto: coverPhoto ?? this.coverPhoto,
    );
  }

  /// مستخدم وهمي للتجربة
  static UserModel mockSeller() {
    return UserModel(
      id: 'seller_001',
      name: 'أحمد محمد',
      email: 'ahmed@example.com',
      phone: '01000000000',
      photoUrl: '',
      isSeller: true,
      isBuyer: true,
      createdAt: DateTime.now(),
      rating: 4.5,
      totalSales: 128,
      totalProducts: 45,
      totalViews: 12500,
      storeName: 'متجر الإلكترونيات',
      storeDescription: 'متجر متخصص في الإلكترونيات والأجهزة الحديثة',
      storePhone: '01000000000',
      storeAddress: 'القاهرة - مصر',
      coverPhoto: '',
    );
  }

  static UserModel mockBuyer() {
    return UserModel(
      id: 'buyer_001',
      name: 'محمد علي',
      email: 'mohamed@example.com',
      phone: '01100000000',
      photoUrl: '',
      isSeller: false,
      isBuyer: true,
      createdAt: DateTime.now(),
      rating: 0,
      totalSales: 0,
      totalProducts: 0,
      totalViews: 0,
      storeName: '',
      storeDescription: '',
      storePhone: '',
      storeAddress: '',
      coverPhoto: '',
    );
  }
}
