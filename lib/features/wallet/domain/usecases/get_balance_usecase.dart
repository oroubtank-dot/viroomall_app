// lib/features/wallet/domain/usecases/get_balance_usecase.dart
import '../repositories/wallet_repository.dart';

class GetBalanceUseCase {
  final WalletRepository _repository;
  GetBalanceUseCase(this._repository);

  Stream<double> call(String userId) {
    return _repository.watchBalance(userId);
  }
}
