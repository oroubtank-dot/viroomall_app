// lib/features/auth/domain/entities/user_entity.dart

class UserEntity {
  final String uid;
  final String phone;
  final String? name;
  final bool isVerified;

  UserEntity({
    required this.uid,
    required this.phone,
    this.name,
    this.isVerified = false,
  });
}
