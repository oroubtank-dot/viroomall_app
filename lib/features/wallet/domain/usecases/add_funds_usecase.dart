// lib/features/wallet/domain/usecases/add_funds_usecase.dart
import '../repositories/wallet_repository.dart';

class AddFundsUseCase {
  final WalletRepository _repository;
  AddFundsUseCase(this._repository);

  Future<void> call(String userId, double amount, String method) async {
    await _repository.addFunds(userId, amount, method);
  }
}
