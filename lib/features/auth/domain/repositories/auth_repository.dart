// lib/features/auth/domain/repositories/auth_repository.dart
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<String> sendOTP(String phoneNumber);
  Future<UserEntity> verifyOTP(String verificationId, String otp);
  Future<void> logout();
  UserEntity? getCurrentUser();
  Stream<UserEntity?> get authStateChanges;
}
