// lib/features/orders/presentation/providers/order_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/order_service.dart';

final orderServiceProvider = Provider<OrderService>((ref) {
  return OrderService();
});

// OrderActions بقى هي OrderService نفسها
final orderActionsProvider = Provider<OrderService>((ref) {
  return OrderService();
});
