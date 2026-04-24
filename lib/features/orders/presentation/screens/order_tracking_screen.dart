import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/viroo_background.dart';
import '../../domain/models/order_model.dart';

class OrderTrackingScreen extends ConsumerWidget {
  final OrderModel order;

  const OrderTrackingScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تتبع الطلب'),
        centerTitle: true,
      ),
      body: VirooBackground(
        showOrbs: true,
        themeColor: VirooColors.primary,
        child: Center(
          child: Text('Order: ${order.productName}'),
        ),
      ),
    );
  }
}
