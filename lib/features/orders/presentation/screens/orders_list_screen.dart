// lib/features/orders/presentation/screens/orders_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../../../../core/widgets/viroo_background.dart';
import '../../domain/models/order_model.dart';
import '../../domain/enums/order_status.dart'; // 👈 أضفنا الإستيراد
import 'order_tracking_screen.dart';

class OrdersListScreen extends StatelessWidget {
  final bool isSeller;

  const OrdersListScreen({super.key, required this.isSeller});

  @override
  Widget build(BuildContext context) {
    // بيانات وهمية للتجربة
    final mockOrders = [
      OrderModel.mock(),
      OrderModel.mock(),
      OrderModel.mock(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isSeller ? 'الطلبات الواردة' : 'طلباتي',
          style:
              const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: VirooBackground(
        showOrbs: true,
        themeColor: VirooColors.primary,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: mockOrders.length,
          itemBuilder: (context, index) {
            final order = mockOrders[index];
            return _buildOrderCard(context, order);
          },
        ),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderModel order) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderTrackingScreen(order: order),
          ),
        );
      },
      child: GlassContainer(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: VirooColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.shopping_bag_rounded,
                      color: VirooColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.productName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${order.price.toStringAsFixed(0)} ج.م',
                        style: TextStyle(
                          color: VirooColors.primary,
                          fontFamily: 'Orbitron',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isSeller
                            ? 'المشتري: ${order.buyerName}'
                            : 'البائع: ${order.sellerName}',
                        style: TextStyle(
                          color: VirooColors.textSecondary,
                          fontFamily: 'Cairo',
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getStatusText(order.status),
                    style: TextStyle(
                      color: _getStatusColor(order.status),
                      fontFamily: 'Cairo',
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            if (isSeller && order.status == OrderStatus.pending) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: GlowingButton(
                      onPressed: () {
                        // قبول الطلب
                      },
                      text: 'قبول',
                      icon: Icons.check_circle_rounded,
                      height: 40,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // رفض الطلب
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: VirooColors.error),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text('رفض',
                          style: TextStyle(
                              color: VirooColors.error, fontFamily: 'Cairo')),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return VirooColors.warning;
      case OrderStatus.accepted:
      case OrderStatus.preparing:
        return VirooColors.info;
      case OrderStatus.shipped:
      case OrderStatus.delivered:
        return VirooColors.primary;
      case OrderStatus.confirmed:
        return VirooColors.success;
      case OrderStatus.cancelled:
        return VirooColors.error;
    }
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'قيد الانتظار';
      case OrderStatus.accepted:
        return 'تم القبول';
      case OrderStatus.preparing:
        return 'جاري التجهيز';
      case OrderStatus.shipped:
        return 'تم الشحن';
      case OrderStatus.delivered:
        return 'تم التسليم';
      case OrderStatus.confirmed:
        return 'مكتمل';
      case OrderStatus.cancelled:
        return 'ملغي';
    }
  }
}
