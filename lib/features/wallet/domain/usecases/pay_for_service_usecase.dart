// lib/features/wallet/domain/usecases/pay_for_service_usecase.dart
import '../repositories/wallet_repository.dart';

class PayForServiceUseCase {
  final WalletRepository _repository;
  PayForServiceUseCase(this._repository);

  Future<bool> call(String userId, double amount, String description) async {
    return await _repository.deductFunds(userId, amount, description);
  }
}
