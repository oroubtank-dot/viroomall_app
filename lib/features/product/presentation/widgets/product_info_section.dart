// lib/features/product/presentation/widgets/product_info_section.dart
import 'package:flutter/material.dart';
import '../../../../core/models/product_model.dart';

class ProductInfoSection extends StatelessWidget {
  final ProductModel product;

  const ProductInfoSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final modeColor = product.modeColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Cairo',
            height: 1.3,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${product.price.toStringAsFixed(0)} ج.م',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: modeColor,
                fontFamily: 'Orbitron',
              ),
            ),
            if (product.originalPrice != null) ...[
              const SizedBox(width: 12),
              Text(
                '${product.originalPrice!.toStringAsFixed(0)} ج.م',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                  fontFamily: 'Orbitron',
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
