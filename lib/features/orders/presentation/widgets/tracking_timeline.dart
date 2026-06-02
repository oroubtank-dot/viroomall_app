// lib/features/orders/presentation/widgets/tracking_timeline.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/order_model.dart';

class TrackingTimeline extends StatelessWidget {
  final OrderStatus currentStatus;
  final bool isBuyer;
  final Function(OrderStatus) onStatusChanged;

  const TrackingTimeline({
    super.key,
    required this.currentStatus,
    required this.isBuyer,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final steps = _getTimelineSteps();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: steps.length,
      itemBuilder: (context, index) {
        final step = steps[index];
        final isCompleted = _isStepCompleted(step.status);
        final isCurrent = currentStatus == step.status;
        final isLast = index == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? VirooColors.success
                        : isCurrent
                            ? VirooColors.amberPrimary
                            : VirooColors.glassDark,
                    border: Border.all(
                      color: isCompleted || isCurrent
                          ? Colors.transparent
                          : VirooColors.glassBorder,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    isCompleted ? Icons.check : step.icon,
                    size: 18,
                    color: isCompleted || isCurrent
                        ? Colors.white
                        : VirooColors.textSecondary,
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 60,
                    color: isCompleted
                        ? VirooColors.success.withAlpha(51)
                        : VirooColors.glassBorder,
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isCompleted || isCurrent
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isCompleted || isCurrent
                            ? Colors.white
                            : VirooColors.textSecondary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      step.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: VirooColors.textSecondary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<StepModel> _getTimelineSteps() {
    return [
      StepModel(
        status: OrderStatus.pending,
        title: 'تم إنشاء الطلب',
        description: 'بانتظار قبول البائع',
        icon: Icons.receipt_rounded,
      ),
      StepModel(
        status: OrderStatus.accepted,
        title: 'تم قبول الطلب',
        description: 'البائع قام بقبول طلبك',
        icon: Icons.check_circle_rounded,
      ),
      StepModel(
        status: OrderStatus.preparing,
        title: 'جاري تجهيز الطلب',
        description: 'البائع يقوم بتجهيز المنتج',
        icon: Icons.inventory_2_rounded,
      ),
      StepModel(
        status: OrderStatus.shipped,
        title: 'تم الشحن',
        description: 'تم تسليم الطلب لشركة الشحن',
        icon: Icons.local_shipping_rounded,
      ),
      StepModel(
        status: OrderStatus.outForDelivery,
        title: 'خارج للتوصيل',
        description: 'طلبك في طريقه إليك',
        icon: Icons.delivery_dining_rounded,
      ),
      StepModel(
        status: OrderStatus.delivered,
        title: 'تم التسليم',
        description: 'تم توصيل الطلب إليك',
        icon: Icons.home_rounded,
      ),
      StepModel(
        status: OrderStatus.confirmed,
        title: 'تم التأكيد',
        description: 'تم تأكيد استلام الطلب',
        icon: Icons.verified_rounded,
      ),
    ];
  }

  bool _isStepCompleted(OrderStatus stepStatus) {
    final orderIndex = OrderStatus.values.indexOf(currentStatus);
    final stepIndex = OrderStatus.values.indexOf(stepStatus);
    return stepIndex < orderIndex;
  }
}

class StepModel {
  final OrderStatus status;
  final String title;
  final String description;
  final IconData icon;

  StepModel({
    required this.status,
    required this.title,
    required this.description,
    required this.icon,
  });
}
