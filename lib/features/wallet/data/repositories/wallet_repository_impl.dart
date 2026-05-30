// lib/features/wallet/data/repositories/wallet_repository_impl.dart
import '../../domain/entities/wallet_entity.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../datasources/wallet_remote_datasource.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource _remoteDataSource;

  WalletRepositoryImpl(this._remoteDataSource);

  @override
  Future<WalletEntity> getOrCreateWallet(String userId) async {
    final data = await _remoteDataSource.getWallet(userId);
    if (data != null) {
      return WalletEntity(
        id: data['id'] ?? '',
        userId: userId,
        balance: (data['balance'] ?? 0).toDouble(),
        totalDeposited: (data['totalDeposited'] ?? 0).toDouble(),
        totalSpent: (data['totalSpent'] ?? 0).toDouble(),
      );
    }
    final id = await _remoteDataSource.createWallet(userId);
    return WalletEntity(id: id, userId: userId);
  }

  @override
  Future<void> addFunds(String userId, double amount, String method) async {
    final wallet = await getOrCreateWallet(userId);
    await _remoteDataSource.updateBalance(wallet.id, wallet.balance + amount);
    await _remoteDataSource.addTransaction(
        userId, amount, 'deposit', 'شحن محفظة عبر $method',
        method: method);
  }

  @override
  Future<bool> deductFunds(
      String userId, double amount, String description) async {
    final wallet = await getOrCreateWallet(userId);
    if (wallet.balance < amount) return false;
    await _remoteDataSource.updateBalance(wallet.id, wallet.balance - amount);
    await _remoteDataSource.addTransaction(
        userId, amount, 'payment', description);
    return true;
  }

  @override
  Stream<double> watchBalance(String userId) async* {
    final wallet = await getOrCreateWallet(userId);
    yield* _remoteDataSource.watchBalance(wallet.id);
  }

  @override
  Future<double> getBalance(String userId) async {
    final wallet = await getOrCreateWallet(userId);
    return await _remoteDataSource.getBalance(wallet.id);
  }
}
