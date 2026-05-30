// lib/features/product/data/models/product_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/market_type.dart';
import '../../domain/entities/product_entity.dart';

class ProductModel {
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

  ProductModel({
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

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      sellerId: data['sellerId'] ?? '',
      sellerName: data['sellerName'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      originalPrice: data['originalPrice']?.toDouble(),
      marketType: _parseMarketType(data['marketType'] ?? 'tasawok'),
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

  Map<String, dynamic> toFirestore() {
    return {
      'sellerId': sellerId,
      'sellerName': sellerName,
      'title': title,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'marketType': marketType.name,
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

  ProductEntity toEntity() => ProductEntity(
        id: id,
        sellerId: sellerId,
        sellerName: sellerName,
        title: title,
        description: description,
        price: price,
        originalPrice: originalPrice,
        marketType: marketType,
        categoryId: categoryId,
        images: images,
        videoUrl: videoUrl,
        condition: condition,
        defects: defects,
        location: location,
        views: views,
        favorites: favorites,
        status: status,
        qualityScore: qualityScore,
        createdAt: createdAt,
        expiresAt: expiresAt,
        averageRating: averageRating,
        ratingCount: ratingCount,
      );

  static MarketType _parseMarketType(String value) {
    switch (value) {
      case 'gomla':
        return MarketType.gomla;
      case 'farz':
        return MarketType.farz;
      case 'mosta3mal':
        return MarketType.mosta3mal;
      default:
        return MarketType.tasawok;
    }
  }

  Color get modeColor {
    switch (marketType) {
      case MarketType.tasawok:
        return const Color(0xFFFF8C00);
      case MarketType.gomla:
        return const Color(0xFF2196F3);
      case MarketType.mosta3mal:
        return const Color(0xFF4CAF50);
      case MarketType.farz:
        return const Color(0xFFF44336);
    }
  }

  String modeLabel(String lang) {
    if (lang == 'ar') {
      switch (marketType) {
        case MarketType.tasawok:
          return '🛍️ تسوق';
        case MarketType.gomla:
          return '🏪 جملة';
        case MarketType.mosta3mal:
          return '♻️ مستعمل';
        case MarketType.farz:
          return '🔥 فرز إنتاج وتصفية';
      }
    } else {
      switch (marketType) {
        case MarketType.tasawok:
          return '🛍️ Shopping';
        case MarketType.gomla:
          return '🏪 Wholesale';
        case MarketType.mosta3mal:
          return '♻️ Used';
        case MarketType.farz:
          return '🔥 Outlet';
      }
    }
  }

  int? get discountPercentage {
    if (originalPrice != null && originalPrice! > price) {
      return ((originalPrice! - price) / originalPrice! * 100).round();
    }
    return null;
  }
}
