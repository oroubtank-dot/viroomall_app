// My Orders Screen
// lib/features/profile/presentation/screens/my_orders_screen.dart
import 'package:flutter/material.dart';
import '../../../orders/presentation/screens/orders_list_screen.dart';

class MyOrdersScreen extends StatelessWidget {
  final bool isSeller;
  const MyOrdersScreen({super.key, required this.isSeller});

  @override
  Widget build(BuildContext context) {
    return OrdersListScreen(isSeller: isSeller);
  }
}
