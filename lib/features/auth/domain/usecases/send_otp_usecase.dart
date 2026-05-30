// lib/features/auth/domain/usecases/send_otp_usecase.dart
import '../repositories/auth_repository.dart';

class SendOTPUseCase {
  final AuthRepository _repository;

  SendOTPUseCase(this._repository);

  Future<String> call(String phoneNumber) async {
    return await _repository.sendOTP(phoneNumber);
  }
}
