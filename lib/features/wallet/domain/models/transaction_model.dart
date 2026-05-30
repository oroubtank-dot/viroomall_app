import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TransactionModel {
  final String id;
  final String userId;
  final double amount;
  final String type;
  final String description;
  final String status;
  final String? paymentMethod;
  final String? referenceId;
  final DateTime createdAt;

  TransactionModel({
    required this.id, required this.userId, required this.amount,
    required this.type, required this.description, this.status = 'pending',
    this.paymentMethod, this.referenceId, required this.createdAt,
  });

  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TransactionModel(
      id: doc.id, userId: data['userId'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      type: data['type'] ?? 'deposit',
      description: data['description'] ?? '',
      status: data['status'] ?? 'pending',
      paymentMethod: data['paymentMethod'],
      referenceId: data['referenceId'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'userId': userId, 'amount': amount, 'type': type,
    'description': description, 'status': status,
    'paymentMethod': paymentMethod, 'referenceId': referenceId,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  Color get statusColor {
    switch (status) {
      case 'completed': return const Color(0xFF4ADE80);
      case 'pending': return const Color(0xFFFBBF24);
      case 'failed': return const Color(0xFFF87171);
      default: return const Color(0xFF9CA3AF);
    }
  }

  String get statusLabel {
    switch (status) {
      case 'completed': return '✅ مكتمل';
      case 'pending': return '⏳ قيد الانتظار';
      case 'failed': return '❌ فشل';
      default: return 'غير معروف';
    }
  }

  IconData get typeIcon {
    switch (type) {
      case 'deposit': return Icons.arrow_downward_rounded;
      case 'withdrawal': return Icons.arrow_upward_rounded;
      case 'payment': return Icons.shopping_cart_rounded;
      default: return Icons.swap_horiz_rounded;
    }
  }

  Color get typeColor {
    switch (type) {
      case 'deposit': return const Color(0xFF4ADE80);
      case 'withdrawal': return const Color(0xFFF87171);
      case 'payment': return const Color(0xFF60A5FA);
      default: return const Color(0xFF9CA3AF);
    }
  }
}