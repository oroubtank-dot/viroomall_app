// lib/features/home/presentation/widgets/empty_products.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class EmptyProducts extends StatelessWidget {
  const EmptyProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 48,
            color: VirooColors.textSecondary,
          ),
          const SizedBox(height: 12),
          Text(
            'لا توجد منتجات حالياً',
            style: TextStyle(
              color: VirooColors.textSecondary,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }
}
