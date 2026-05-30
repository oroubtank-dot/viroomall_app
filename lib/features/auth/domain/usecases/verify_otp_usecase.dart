// lib/features/auth/domain/usecases/verify_otp_usecase.dart
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class VerifyOTPUseCase {
  final AuthRepository _repository;

  VerifyOTPUseCase(this._repository);

  Future<UserEntity> call(String verificationId, String otp) async {
    return await _repository.verifyOTP(verificationId, otp);
  }
}
