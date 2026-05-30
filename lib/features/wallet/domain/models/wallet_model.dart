import 'package:cloud_firestore/cloud_firestore.dart';

class WalletModel {
  final String id;
  final String userId;
  final double balance;
  final double totalDeposited;
  final double totalSpent;
  final DateTime createdAt;
  final DateTime updatedAt;

  WalletModel({
    required this.id, required this.userId, this.balance = 0.0,
    this.totalDeposited = 0.0, this.totalSpent = 0.0,
    required this.createdAt, required this.updatedAt,
  });

  factory WalletModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WalletModel(
      id: doc.id, userId: data['userId'] ?? '',
      balance: (data['balance'] ?? 0).toDouble(),
      totalDeposited: (data['totalDeposited'] ?? 0).toDouble(),
      totalSpent: (data['totalSpent'] ?? 0).toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'userId': userId, 'balance': balance,
    'totalDeposited': totalDeposited, 'totalSpent': totalSpent,
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
  };
}