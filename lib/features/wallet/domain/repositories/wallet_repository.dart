// lib/features/wallet/domain/repositories/wallet_repository.dart
import '../entities/wallet_entity.dart';

abstract class WalletRepository {
  Future<WalletEntity> getOrCreateWallet(String userId);
  Future<void> addFunds(String userId, double amount, String method);
  Future<bool> deductFunds(String userId, double amount, String description);
  Stream<double> watchBalance(String userId);
  Future<double> getBalance(String userId);
}
