// lib/presentation/screens/auth/providers/auth_provider.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/auth_service.dart';

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return AuthService.authStateChanges;
});

final currentUserProvider = Provider<User?>((ref) {
  return AuthService.currentUser;
});

final isLoggedInProvider = Provider<bool>((ref) {
  return AuthService.currentUser != null;
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final signOutProvider = FutureProvider.autoDispose<void>((ref) async {
  await AuthService.signOut();
});
