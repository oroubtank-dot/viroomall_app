// lib/core/providers/order_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order_model.dart';

// Provider لحالة الطلبات (مؤقت - هتطوره بعدين)
final orderListProvider = StateProvider<List<OrderModel>>((ref) => []);

// Provider للطلب الحالي
final currentOrderProvider = StateProvider<OrderModel?>((ref) => null);
