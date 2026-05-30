// lib/core/models/order_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderStatus {
  pending,
  accepted,
  preparing,
  delivered,
  confirmed,
  cancelled,
}

class OrderModel {
  final String id;
  final String buyerId;
  final String buyerName;
  final String sellerId;
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final OrderStatus status;
  final bool sellerConfirmed;
  final bool buyerConfirmed;
  final DateTime createdAt;
  final DateTime? updatedAt;

  OrderModel({
    required this.id,
    required this.buyerId,
    required this.buyerName,
    required this.sellerId,
    required this.productId,
    required this.productName,
    required this.price,
    this.quantity = 1,
    this.status = OrderStatus.pending,
    this.sellerConfirmed = false,
    this.buyerConfirmed = false,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'buyerId': buyerId,
      'buyerName': buyerName,
      'sellerId': sellerId,
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'status': status.name,
      'sellerConfirmed': sellerConfirmed,
      'buyerConfirmed': buyerConfirmed,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      id: id,
      buyerId: map['buyerId'] ?? '',
      buyerName: map['buyerName'] ?? '',
      sellerId: map['sellerId'] ?? '',
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 1,
      status: _parseStatus(map['status']),
      sellerConfirmed: map['sellerConfirmed'] ?? false,
      buyerConfirmed: map['buyerConfirmed'] ?? false,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  static OrderStatus _parseStatus(String? status) {
    return OrderStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => OrderStatus.pending,
    );
  }
}
