import 'package:cloud_firestore/cloud_firestore.dart';
import '../enums/order_status.dart';

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
  });

  double get totalPrice => price * quantity;

  factory OrderModel.fromMap(Map<String, dynamic> map, String docId) {
    return OrderModel(
      id: docId,
      buyerId: map['buyerId'] ?? '',
      buyerName: map['buyerName'] ?? '',
      sellerId: map['sellerId'] ?? '',
      sellerName: map['sellerName'] ?? '',
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      productImage: map['productImage'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 1,
      status: _parseStatus(map['status']),
      sellerConfirmed: map['sellerConfirmed'] ?? false,
      buyerConfirmed: map['buyerConfirmed'] ?? false,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

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
    };
  }

  static OrderStatus _parseStatus(String? status) {
    return OrderStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => OrderStatus.pending,
    );
  }

  static OrderModel mock() {
    return OrderModel(
      id: 'order_123',
      buyerId: 'buyer_001',
      buyerName: 'احمد محمد',
      sellerId: 'seller_001',
      sellerName: 'متجر الالكترونيات',
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
