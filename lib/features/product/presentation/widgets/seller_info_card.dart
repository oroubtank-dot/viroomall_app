// lib/features/product/presentation/widgets/seller_info_card.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../../../../core/models/product_model.dart';

class SellerInfoCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onContactPressed;

  const SellerInfoCard({
    super.key,
    required this.product,
    required this.onContactPressed,
  });

  @override
  Widget build(BuildContext context) {
    final modeColor = product.modeColor;

    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(20),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: modeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(Icons.store_rounded, color: modeColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'بائع VirooMall',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      color: VirooColors.textSecondary,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      product.location,
                      style: TextStyle(
                        fontSize: 12,
                        color: VirooColors.textSecondary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GlowingButton(
            onPressed: onContactPressed,
            text: 'تواصل',
            icon: Icons.chat_bubble_rounded,
            width: 100,
            height: 40,
          ),
        ],
      ),
    );
  }
}
