// lib/core/providers/loading_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/loading_notifier.dart';
import '../states/loading_state.dart';

/// 🔄 Global Loading Provider
/// مزود حالة التحميل العام
final loadingProvider =
    StateNotifierProvider<LoadingNotifier, LoadingState>((ref) {
  return LoadingNotifier();
});

/// 🔄 Feature-specific Loading Providers
/// مزودات التحميل الخاصة بكل ميزة

/// Loading state for products
final productsLoadingProvider =
    StateNotifierProvider<LoadingNotifier, LoadingState>((ref) {
  return LoadingNotifier();
});

/// Loading state for cart
final cartLoadingProvider =
    StateNotifierProvider<LoadingNotifier, LoadingState>((ref) {
  return LoadingNotifier();
});

/// Loading state for auth
final authLoadingProvider =
    StateNotifierProvider<LoadingNotifier, LoadingState>((ref) {
  return LoadingNotifier();
});

/// Loading state for orders
final ordersLoadingProvider =
    StateNotifierProvider<LoadingNotifier, LoadingState>((ref) {
  return LoadingNotifier();
});

/// Loading state for profile
final profileLoadingProvider =
    StateNotifierProvider<LoadingNotifier, LoadingState>((ref) {
  return LoadingNotifier();
});
