// lib/core/models/order_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderStatus {
  pending,
  accepted,
  preparing,
  shipped,
  outForDelivery,
  delivered,
  confirmed,
  cancelled,
}

class OrderModel {
  final String id;
  final String buyerId;
  final String buyerName;
  final String sellerId;
  final String sellerName;
  final String productId;
  final String productName;
  final String productImage;
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
    required this.sellerName,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    this.quantity = 1,
    this.status = OrderStatus.pending,
    this.sellerConfirmed = false,
    this.buyerConfirmed = false,
    required this.createdAt,
    this.updatedAt,
  });

  double get totalPrice => price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'buyerId': buyerId,
      'buyerName': buyerName,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'price': price,
      'quantity': quantity,
      'status': status.name,
      'sellerConfirmed': sellerConfirmed,
      'buyerConfirmed': buyerConfirmed,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      buyerId: data['buyerId'] ?? '',
      buyerName: data['buyerName'] ?? '',
      sellerId: data['sellerId'] ?? '',
      sellerName: data['sellerName'] ?? '',
      productId: data['productId'] ?? '',
      productName: data['productName'] ?? '',
      productImage: data['productImage'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      quantity: data['quantity'] ?? 1,
      status: _parseStatus(data['status']),
      sellerConfirmed: data['sellerConfirmed'] ?? false,
      buyerConfirmed: data['buyerConfirmed'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  static OrderStatus _parseStatus(String? status) {
    if (status == null) return OrderStatus.pending;
    switch (status) {
      case 'pending':
        return OrderStatus.pending;
      case 'accepted':
        return OrderStatus.accepted;
      case 'preparing':
        return OrderStatus.preparing;
      case 'shipped':
        return OrderStatus.shipped;
      case 'outForDelivery':
        return OrderStatus.outForDelivery;
      case 'delivered':
        return OrderStatus.delivered;
      case 'confirmed':
        return OrderStatus.confirmed;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }

  static OrderModel mock() {
    return OrderModel(
      id: 'order_123',
      buyerId: 'buyer_001',
      buyerName: 'أحمد محمد',
      sellerId: 'seller_001',
      sellerName: 'متجر الإلكترونيات',
      productId: 'product_001',
      productName: 'ايفون 15 برو ماكس',
      productImage: '',
      price: 45999,
      quantity: 1,
      status: OrderStatus.pending,
      sellerConfirmed: false,
      buyerConfirmed: false,
      createdAt: DateTime.now(),
    );
  }
}
