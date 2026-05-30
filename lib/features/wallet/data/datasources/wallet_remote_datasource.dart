// lib/features/wallet/data/datasources/wallet_remote_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class WalletRemoteDataSource {
  final FirebaseFirestore _firestore;

  WalletRemoteDataSource(this._firestore);

  Future<Map<String, dynamic>?> getWallet(String userId) async {
    final snapshot = await _firestore
        .collection('wallets')
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first.data();
  }

  Future<String> createWallet(String userId) async {
    final docRef = await _firestore.collection('wallets').add({
      'userId': userId,
      'balance': 0.0,
      'totalDeposited': 0.0,
      'totalSpent': 0.0,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    });
    return docRef.id;
  }

  Future<void> updateBalance(String walletId, double newBalance) async {
    await _firestore.collection('wallets').doc(walletId).update({
      'balance': newBalance,
      'updatedAt': Timestamp.now(),
    });
  }

  Future<void> addTransaction(
      String userId, double amount, String type, String description,
      {String? method}) async {
    await _firestore.collection('transactions').add({
      'userId': userId,
      'amount': amount,
      'type': type,
      'description': description,
      'status': 'completed',
      'paymentMethod': method,
      'createdAt': Timestamp.now(),
    });
  }

  Stream<double> watchBalance(String walletId) {
    return _firestore
        .collection('wallets')
        .doc(walletId)
        .snapshots()
        .map((doc) => (doc.data()?['balance'] ?? 0).toDouble());
  }

  Future<double> getBalance(String walletId) async {
    final doc = await _firestore.collection('wallets').doc(walletId).get();
    return (doc.data()?['balance'] ?? 0).toDouble();
  }
}
