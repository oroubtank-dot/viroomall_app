// lib/features/product/presentation/widgets/product_details/wholesale_section.dart
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_widgets.dart';

class WholesaleSection extends StatelessWidget {
  final double price;
  final int minQuantity;

  const WholesaleSection({
    super.key,
    required this.price,
    this.minQuantity = 10,
  });

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
              Icon(Icons.inventory_2_rounded,
                  color: VirooColors.wholesale, size: 22),
              SizedBox(width: 8),
              Text(
                '🏪 أسعار الجملة',
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
          Text(
            '⚡ الحد الأدنى للطلب: $minQuantity قطع',
            style: const TextStyle(
              color: VirooColors.textSecondary,
              fontSize: 13,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 10),
          _priceRow('$minQuantity+ قطعة', price * 0.9),
          _priceRow('${(minQuantity * 5)}+ قطعة', price * 0.8),
          _priceRow('${(minQuantity * 10)}+ قطعة', price * 0.7),
        ],
      ),
    );
  }

  Widget _priceRow(String quantity, double price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            quantity,
            style: const TextStyle(
              color: VirooColors.textSecondary,
              fontSize: 13,
              fontFamily: 'Cairo',
            ),
          ),
          Text(
            '${price.toStringAsFixed(0)} ج/قطعة',
            style: const TextStyle(
              color: VirooColors.wholesale,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              fontFamily: 'Orbitron',
            ),
          ),
        ],
      ),
    );
  }
}
