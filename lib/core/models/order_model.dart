// lib/core/models/order_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderStatus {
  pending, // المشتري أكد الطلب - مستني البائع
  confirmed, // البائع أكد الطلب
  preparing, // جاري التجهيز
  shipped, // تم التسليم لشركة الشحن
  inTransit, // في الطريق
  delivered, // تم الاستلام
  suspended, // معلق (البائع ما أكدش في ٤٨ ساعة)
  cancelled, // ملغي
}

enum BuyerAction {
  waiting, // منتظر البائع
  browsingAlternatives, // بيتفرج على منتجات مشابهة
  cancelled, // ألغى الطلب
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
  final BuyerAction? buyerAction;
  final String? trackingNumber;
  final String? shippingCompany;
  final String? suspendReason;
  final bool isRated;
  final DateTime createdAt;
  final DateTime? confirmedAt;
  final DateTime? shippedAt;
  final DateTime? deliveredAt;
  final DateTime? suspendedAt;
  final DateTime? updatedAt;
  final int sellerMissedOrders; // عداد سري للبائع
  final String? convertedToOrderId; // لو المشتري حول لبائع تاني

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
    this.buyerAction,
    this.trackingNumber,
    this.shippingCompany,
    this.suspendReason,
    this.isRated = false,
    required this.createdAt,
    this.confirmedAt,
    this.shippedAt,
    this.deliveredAt,
    this.suspendedAt,
    this.updatedAt,
    this.sellerMissedOrders = 0,
    this.convertedToOrderId,
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
      'buyerAction': buyerAction?.name,
      'trackingNumber': trackingNumber,
      'shippingCompany': shippingCompany,
      'suspendReason': suspendReason,
      'isRated': isRated,
      'createdAt': Timestamp.fromDate(createdAt),
      'confirmedAt':
          confirmedAt != null ? Timestamp.fromDate(confirmedAt!) : null,
      'shippedAt': shippedAt != null ? Timestamp.fromDate(shippedAt!) : null,
      'deliveredAt':
          deliveredAt != null ? Timestamp.fromDate(deliveredAt!) : null,
      'suspendedAt':
          suspendedAt != null ? Timestamp.fromDate(suspendedAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'sellerMissedOrders': sellerMissedOrders,
      'convertedToOrderId': convertedToOrderId,
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
      buyerAction: _parseBuyerAction(map['buyerAction']),
      trackingNumber: map['trackingNumber'],
      shippingCompany: map['shippingCompany'],
      suspendReason: map['suspendReason'],
      isRated: map['isRated'] ?? false,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      confirmedAt: map['confirmedAt'] != null
          ? (map['confirmedAt'] as Timestamp).toDate()
          : null,
      shippedAt: map['shippedAt'] != null
          ? (map['shippedAt'] as Timestamp).toDate()
          : null,
      deliveredAt: map['deliveredAt'] != null
          ? (map['deliveredAt'] as Timestamp).toDate()
          : null,
      suspendedAt: map['suspendedAt'] != null
          ? (map['suspendedAt'] as Timestamp).toDate()
          : null,
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
      sellerMissedOrders: map['sellerMissedOrders'] ?? 0,
      convertedToOrderId: map['convertedToOrderId'],
    );
  }

  static OrderStatus _parseStatus(String? status) {
    return OrderStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => OrderStatus.pending,
    );
  }

  static BuyerAction? _parseBuyerAction(String? action) {
    if (action == null) return null;
    return BuyerAction.values.firstWhere(
      (e) => e.name == action,
      orElse: () => BuyerAction.waiting,
    );
  }

  // نسخة مع تعديل بعض الحقول
  OrderModel copyWith({
    String? id,
    String? buyerId,
    String? buyerName,
    String? sellerId,
    String? productId,
    String? productName,
    double? price,
    int? quantity,
    OrderStatus? status,
    BuyerAction? buyerAction,
    String? trackingNumber,
    String? shippingCompany,
    String? suspendReason,
    bool? isRated,
    DateTime? createdAt,
    DateTime? confirmedAt,
    DateTime? shippedAt,
    DateTime? deliveredAt,
    DateTime? suspendedAt,
    DateTime? updatedAt,
    int? sellerMissedOrders,
    String? convertedToOrderId,
  }) {
    return OrderModel(
      id: id ?? this.id,
      buyerId: buyerId ?? this.buyerId,
      buyerName: buyerName ?? this.buyerName,
      sellerId: sellerId ?? this.sellerId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
      buyerAction: buyerAction ?? this.buyerAction,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      shippingCompany: shippingCompany ?? this.shippingCompany,
      suspendReason: suspendReason ?? this.suspendReason,
      isRated: isRated ?? this.isRated,
      createdAt: createdAt ?? this.createdAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      shippedAt: shippedAt ?? this.shippedAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      suspendedAt: suspendedAt ?? this.suspendedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sellerMissedOrders: sellerMissedOrders ?? this.sellerMissedOrders,
      convertedToOrderId: convertedToOrderId ?? this.convertedToOrderId,
    );
  }
}
