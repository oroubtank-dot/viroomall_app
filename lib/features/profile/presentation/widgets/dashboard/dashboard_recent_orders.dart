// lib/features/profile/presentation/widgets/dashboard/dashboard_recent_orders.dart
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_widgets.dart';
import '../../../../../core/models/order_model.dart';

class DashboardRecentOrders extends StatelessWidget {
  final List<OrderModel> orders;

  const DashboardRecentOrders({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.receipt_rounded,
                  color: VirooColors.amberPrimary, size: 20),
              SizedBox(width: 8),
              Text(
                '📦 آخر الطلبات',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (orders.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'لا توجد طلبات حتى الآن',
                  style: TextStyle(
                    color: VirooColors.textSecondary,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            )
          else
            ...orders.map((order) => _buildOrderItem(order)),
        ],
      ),
    );
  }

  Widget _buildOrderItem(OrderModel order) {
    final statusColor = _getStatusColor(order.status);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: VirooColors.glassDark,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.shopping_bag_rounded,
                color: VirooColors.amberPrimary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontFamily: 'Cairo',
                  ),
                ),
                Text(
                  '${order.price.toStringAsFixed(0)} ج.م × ${order.quantity}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: VirooColors.textSecondary,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withAlpha(38),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _getStatusText(order.status),
              style: TextStyle(
                fontSize: 9,
                color: statusColor,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ],
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
        return VirooColors.info;
      case OrderStatus.outForDelivery:
        return VirooColors.amberPrimary;
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
      case OrderStatus.outForDelivery:
        return 'خارج للتوصيل';
      case OrderStatus.delivered:
        return 'تم التسليم';
      case OrderStatus.confirmed:
        return 'مكتمل';
      case OrderStatus.cancelled:
        return 'ملغي';
    }
  }
}
