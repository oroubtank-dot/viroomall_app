// lib/features/product/presentation/widgets/product_details/product_info_section.dart
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_widgets.dart';
import '../../../../../core/models/product_model.dart';

class ProductInfoSection extends StatelessWidget {
  final ProductModel product;

  const ProductInfoSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // السعر والخصم
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${product.price.toStringAsFixed(0)} ج.م',
              style: const TextStyle(
                color: VirooColors.amberPrimary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'Orbitron',
              ),
            ),
            if (product.discountPercentage != null) ...[
              const SizedBox(width: 10),
              Text(
                '${product.originalPrice?.toStringAsFixed(0)} ج.م',
                style: const TextStyle(
                  color: VirooColors.textTertiary,
                  fontSize: 16,
                  fontFamily: 'Cairo',
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: VirooColors.error.withAlpha(51),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '-${product.discountPercentage}%',
                  style: const TextStyle(
                    color: VirooColors.error,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),

        // اسم المنتج
        Text(
          product.title,
          style: const TextStyle(
            color: VirooColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 8),

        // نوع المنتج
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: product.modeColor.withAlpha(51),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                product.modeLabel,
                style: TextStyle(
                  color: product.modeColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // مشاهدات وتقييم
        Row(
          children: [
            const Icon(Icons.remove_red_eye_rounded,
                color: VirooColors.textSecondary, size: 16),
            const SizedBox(width: 4),
            Text(
              '${product.views} مشاهدة',
              style: const TextStyle(
                color: VirooColors.textSecondary,
                fontSize: 13,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(width: 16),
            const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
            const SizedBox(width: 4),
            Text(
              '${product.averageRating} (${product.ratingCount})',
              style: const TextStyle(
                color: VirooColors.textSecondary,
                fontSize: 13,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // وصف المنتج
        GlassContainer(
          padding: const EdgeInsets.all(16),
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '📝 الوصف',
                style: TextStyle(
                  color: VirooColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product.description.isNotEmpty
                    ? product.description
                    : 'لا يوجد وصف',
                style: const TextStyle(
                  color: VirooColors.textSecondary,
                  fontSize: 14,
                  fontFamily: 'Cairo',
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
