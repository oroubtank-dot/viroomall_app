// lib/features/auth/data/repositories/auth_repository_impl.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl(this._remoteDataSource, this._firestore);

  @override
  Future<String> sendOTP(String phoneNumber) async {
    return await _remoteDataSource.sendOTP(phoneNumber);
  }

  @override
  Future<UserEntity> verifyOTP(String verificationId, String otp) async {
    final userCredential =
        await _remoteDataSource.verifyOTP(verificationId, otp);
    final user = userCredential.user;
    if (user == null) throw Exception('User not found');

    final userModel = UserModel(
        uid: user.uid, phone: user.phoneNumber ?? '', name: user.displayName);

    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(userModel.toFirestore(), SetOptions(merge: true));

    return userModel.toEntity();
  }

  @override
  Future<void> logout() async {
    await _remoteDataSource.logout();
  }

  @override
  UserEntity? getCurrentUser() {
    final user = _remoteDataSource.getCurrentUser();
    if (user == null) return null;
    return UserEntity(
        uid: user.uid, phone: user.phoneNumber ?? '', name: user.displayName);
  }

  @override
  Stream<UserEntity?> get authStateChanges =>
      _remoteDataSource.authStateChanges.map((user) {
        if (user == null) return null;
        return UserEntity(
            uid: user.uid,
            phone: user.phoneNumber ?? '',
            name: user.displayName);
      });
}
