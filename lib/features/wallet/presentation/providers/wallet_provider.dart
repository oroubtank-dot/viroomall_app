// lib/features/wallet/presentation/providers/wallet_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/wallet_service.dart';
import '../../domain/models/transaction_model.dart';
import '../../../../core/services/auth_service.dart';

final walletServiceProvider = Provider<WalletService>((ref) {
  return WalletService();
});

final walletBalanceProvider = StreamProvider<double>((ref) {
  final user = AuthService.currentUser;
  if (user == null) return Stream.value(0.0);
  return ref.watch(walletServiceProvider).watchBalance(user.uid);
});

final transactionsProvider = StreamProvider<List<TransactionModel>>((ref) {
  final user = AuthService.currentUser;
  if (user == null) return Stream.value([]);
  return ref.watch(walletServiceProvider).getTransactions(user.uid);
});

// 🆕 Provider للخصم من المحفظة
final deductFromWalletProvider =
    FutureProvider.family<bool, ({double amount, String description})>(
        (ref, params) async {
  final user = AuthService.currentUser;
  if (user == null) return false;
  return await ref
      .watch(walletServiceProvider)
      .deduct(user.uid, params.amount, params.description);
});
