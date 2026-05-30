// lib/features/product/presentation/widgets/product_details/outlet_section.dart
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_widgets.dart';

class OutletSection extends StatelessWidget {
  final double originalPrice;
  final double outletPrice;
  final String? reason;
  final int? remainingQuantity;

  const OutletSection({
    super.key,
    required this.originalPrice,
    required this.outletPrice,
    this.reason,
    this.remainingQuantity,
  });

  @override
  Widget build(BuildContext context) {
    final discount =
        ((originalPrice - outletPrice) / originalPrice * 100).round();

    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.local_fire_department_rounded,
                  color: VirooColors.outlet, size: 22),
              SizedBox(width: 8),
              Text(
                '🔥 فرز إنتاج وتصفية',
                style: TextStyle(
                  color: VirooColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.arrow_downward_rounded,
                  color: VirooColors.outlet, size: 16),
              const SizedBox(width: 4),
              Text(
                'خصم $discount%',
                style: const TextStyle(
                  color: VirooColors.outlet,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'Orbitron',
                ),
              ),
              const Spacer(),
              Text(
                '${originalPrice.toStringAsFixed(0)} ج',
                style: const TextStyle(
                  color: VirooColors.textTertiary,
                  fontSize: 14,
                  fontFamily: 'Cairo',
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${outletPrice.toStringAsFixed(0)} ج',
                style: const TextStyle(
                  color: VirooColors.outlet,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'Orbitron',
                ),
              ),
            ],
          ),
          if (reason != null && reason!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              '📌 سبب التصفية: $reason',
              style: const TextStyle(
                color: VirooColors.textSecondary,
                fontSize: 13,
                fontFamily: 'Cairo',
              ),
            ),
          ],
          if (remainingQuantity != null && remainingQuantity! > 0) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: VirooColors.error.withAlpha(38),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: VirooColors.error.withAlpha(76)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.inventory_2_rounded,
                      color: VirooColors.error, size: 16),
                  SizedBox(width: 8),
                  Text(
                    '⚠️ الكمية محدودة!',
                    style: TextStyle(
                      color: VirooColors.error,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
