// lib/features/wallet/data/wallet_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/models/wallet_model.dart';
import '../domain/models/transaction_model.dart';

class WalletService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // الحصول على محفظة المستخدم
  Future<WalletModel?> getWallet(String userId) async {
    final snapshot = await _firestore
        .collection('wallets')
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return WalletModel.fromFirestore(snapshot.docs.first);
  }

  // إنشاء محفظة جديدة
  Future<WalletModel> createWallet(String userId) async {
    final wallet = WalletModel(
      id: '',
      userId: userId,
      balance: 0.0,
      totalDeposited: 0.0,
      totalSpent: 0.0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final docRef =
        await _firestore.collection('wallets').add(wallet.toFirestore());
    return WalletModel(
      id: docRef.id,
      userId: userId,
      balance: 0.0,
      totalDeposited: 0.0,
      totalSpent: 0.0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  // الحصول على أو إنشاء المحفظة
  Future<WalletModel> getOrCreateWallet(String userId) async {
    final wallet = await getWallet(userId);
    return wallet ?? await createWallet(userId);
  }

  // شحن المحفظة
  Future<void> deposit(
      String userId, double amount, String paymentMethod) async {
    final wallet = await getOrCreateWallet(userId);

    // تحديث الرصيد
    await _firestore.collection('wallets').doc(wallet.id).update({
      'balance': FieldValue.increment(amount),
      'totalDeposited': FieldValue.increment(amount),
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });

    // إضافة سجل المعاملة
    await _firestore.collection('transactions').add({
      'userId': userId,
      'amount': amount,
      'type': 'deposit',
      'description': 'شحن محفظة عبر $paymentMethod',
      'status': 'completed',
      'paymentMethod': paymentMethod,
      'referenceId': 'pay_${DateTime.now().millisecondsSinceEpoch}',
      'createdAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  // خصم من المحفظة
  Future<bool> deduct(String userId, double amount, String description) async {
    final wallet = await getWallet(userId);
    if (wallet == null || wallet.balance < amount) return false;

    await _firestore.collection('wallets').doc(wallet.id).update({
      'balance': FieldValue.increment(-amount),
      'totalSpent': FieldValue.increment(amount),
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });

    await _firestore.collection('transactions').add({
      'userId': userId,
      'amount': amount,
      'type': 'payment',
      'description': description,
      'status': 'completed',
      'createdAt': Timestamp.fromDate(DateTime.now()),
    });

    return true;
  }

  // سجل المعاملات
  Stream<List<TransactionModel>> getTransactions(String userId) {
    return _firestore
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TransactionModel.fromFirestore(doc))
            .toList());
  }

  // Stream لمراقبة رصيد المحفظة
  Stream<double> watchBalance(String userId) async* {
    final wallet = await getWallet(userId);
    if (wallet == null) {
      yield 0.0;
      return;
    }

    yield* _firestore
        .collection('wallets')
        .doc(wallet.id)
        .snapshots()
        .map((doc) => (doc.data()?['balance'] ?? 0).toDouble());
  }
}
