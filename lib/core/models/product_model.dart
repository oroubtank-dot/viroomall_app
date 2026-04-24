// lib/core/models/product_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// =============================================
/// نموذج المنتج - Product Model
/// =============================================
class ProductModel {
  final String id;
  final String sellerId;
  final String title;
  final String description;
  final double price;
  final double? originalPrice;
  final String productType; // 'new', 'used', 'wholesale', 'outlet'
  final String categoryId;
  final List<String> images;
  final String? videoUrl;
  final String condition; // 'new', 'like_new', 'good', 'acceptable'
  final String? defects;
  final String location;
  final int views;
  final int favorites;
  final String status; // 'pending', 'approved', 'rejected', 'expired'
  final int qualityScore;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final double averageRating;
  final int ratingCount;

  ProductModel({
    required this.id,
    required this.sellerId,
    required this.title,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.productType,
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

  /// تحويل من Firestore Document لـ ProductModel
  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      sellerId: data['sellerId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      originalPrice: data['originalPrice']?.toDouble(),
      productType: data['productType'] ?? 'new',
      categoryId: data['categoryId'] ?? '',
      images: data['images'] is List ? List<String>.from(data['images']) : [],
      videoUrl: data['videoUrl'],
      condition: data['condition'] ?? 'new',
      defects: data['defects'],
      location: data['location'] ?? '',
      views: data['views'] ?? 0,
      favorites: data['favorites'] ?? 0,
      status: data['status'] ?? 'approved',
      qualityScore: data['qualityScore'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      expiresAt: (data['expiresAt'] as Timestamp?)?.toDate(),
      averageRating: (data['averageRating'] ?? 0).toDouble(),
      ratingCount: data['ratingCount'] ?? 0,
    );
  }

  /// تحويل من ProductModel لـ Map (للحفظ في Firestore)
  Map<String, dynamic> toFirestore() {
    return {
      'sellerId': sellerId,
      'title': title,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'productType': productType,
      'categoryId': categoryId,
      'images': images,
      'videoUrl': videoUrl,
      'condition': condition,
      'defects': defects,
      'location': location,
      'views': views,
      'favorites': favorites,
      'status': status,
      'qualityScore': qualityScore,
      'createdAt': Timestamp.fromDate(createdAt),
      'expiresAt': expiresAt != null ? Timestamp.fromDate(expiresAt!) : null,
      'averageRating': averageRating,
      'ratingCount': ratingCount,
    };
  }

  /// نسخة من المنتج مع تعديل بعض الحقول
  ProductModel copyWith({
    String? id,
    String? sellerId,
    String? title,
    String? description,
    double? price,
    double? originalPrice,
    String? productType,
    String? categoryId,
    List<String>? images,
    String? videoUrl,
    String? condition,
    String? defects,
    String? location,
    int? views,
    int? favorites,
    String? status,
    int? qualityScore,
    DateTime? createdAt,
    DateTime? expiresAt,
    double? averageRating,
    int? ratingCount,
  }) {
    return ProductModel(
      id: id ?? this.id,
      sellerId: sellerId ?? this.sellerId,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      productType: productType ?? this.productType,
      categoryId: categoryId ?? this.categoryId,
      images: images ?? this.images,
      videoUrl: videoUrl ?? this.videoUrl,
      condition: condition ?? this.condition,
      defects: defects ?? this.defects,
      location: location ?? this.location,
      views: views ?? this.views,
      favorites: favorites ?? this.favorites,
      status: status ?? this.status,
      qualityScore: qualityScore ?? this.qualityScore,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      averageRating: averageRating ?? this.averageRating,
      ratingCount: ratingCount ?? this.ratingCount,
    );
  }

  /// الحصول على لون المنتج حسب نوعه
  Color get modeColor {
    switch (productType) {
      case 'new':
        return const Color(0xFFFF6B35);
      case 'wholesale':
        return const Color(0xFF2196F3);
      case 'used':
        return const Color(0xFF4CAF50);
      case 'outlet':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFFFF6B35);
    }
  }

  /// الحصول على أيقونة المنتج حسب نوعه
  String get modeIcon {
    switch (productType) {
      case 'new':
        return '🛍️';
      case 'wholesale':
        return '🏪';
      case 'used':
        return '♻️';
      case 'outlet':
        return '🔥';
      default:
        return '🛍️';
    }
  }

  /// الحصول على اسم الوضع بالعربي
  String get modeLabel {
    switch (productType) {
      case 'new':
        return '🛍️ تسوق';
      case 'wholesale':
        return '🏪 جملة';
      case 'used':
        return '♻️ مستعمل';
      case 'outlet':
        return '🔥 فرز إنتاج وتصفية';
      default:
        return '🛍️ تسوق';
    }
  }

  /// حساب نسبة الخصم
  int? get discountPercentage {
    if (originalPrice != null && originalPrice! > price) {
      return ((originalPrice! - price) / originalPrice! * 100).round();
    }
    return null;
  }

  /// منتج وهمي للتجربة
  static ProductModel mock() {
    return ProductModel(
      id: 'mock_${DateTime.now().millisecondsSinceEpoch}',
      sellerId: 'seller_123',
      title: 'منتج تجريبي',
      description: 'وصف المنتج التجريبي',
      price: 999.0,
      originalPrice: 1299.0,
      productType: 'new',
      categoryId: 'electronics',
      images: [],
      condition: 'new',
      location: 'القاهرة',
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(days: 30)),
    );
  }
}
