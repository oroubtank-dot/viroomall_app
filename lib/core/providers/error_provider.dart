// lib/core/providers/error_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/error_notifier.dart';
import '../states/error_state.dart';

/// 🔴 Global Error Provider
final errorProvider =
    StateNotifierProvider<ErrorNotifier, ErrorState?>((ref) {
  return ErrorNotifier();
});

/// 🔴 Feature-specific Error Providers

/// Error state for auth
final authErrorProvider =
    StateNotifierProvider<ErrorNotifier, ErrorState?>((ref) {
  return ErrorNotifier();
});

/// Error state for products
final productsErrorProvider =
    StateNotifierProvider<ErrorNotifier, ErrorState?>((ref) {
  return ErrorNotifier();
});

/// Error state for cart
final cartErrorProvider =
    StateNotifierProvider<ErrorNotifier, ErrorState?>((ref) {
  return ErrorNotifier();
});

/// Error state for orders
final ordersErrorProvider =
    StateNotifierProvider<ErrorNotifier, ErrorState?>((ref) {
  return ErrorNotifier();
});

/// Error state for profile
final profileErrorProvider =
    StateNotifierProvider<ErrorNotifier, ErrorState?>((ref) {
  return ErrorNotifier();
});
