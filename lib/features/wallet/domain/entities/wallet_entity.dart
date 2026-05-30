// lib/features/wallet/domain/entities/wallet_entity.dart

class WalletEntity {
  final String id;
  final String userId;
  final double balance;
  final double totalDeposited;
  final double totalSpent;

  WalletEntity({
    required this.id,
    required this.userId,
    this.balance = 0.0,
    this.totalDeposited = 0.0,
    this.totalSpent = 0.0,
  });

  bool canAfford(double amount) => balance >= amount;
}
