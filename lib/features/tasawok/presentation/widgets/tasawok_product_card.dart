// lib/features/tasawok/presentation/widgets/tasawok_product_card.dart
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/product_model.dart';
import 'tasawok_mode_color.dart';

class TasawokProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const TasawokProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: TasawokModeColor.primary.withAlpha(38),
              blurRadius: 15,
              spreadRadius: -2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              decoration: BoxDecoration(
                color: VirooColors.glassDark,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: VirooColors.glassBorder, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildImage(),
                  ),
                  _buildInfo(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: TasawokModeColor.primary.withAlpha(12),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: product.images.isNotEmpty
              ? ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.memory(
                    base64Decode(product.images.first),
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Icon(Icons.image_rounded,
                        color: TasawokModeColor.primary, size: 40),
                  ),
                )
              : Icon(Icons.image_rounded,
                  color: TasawokModeColor.primary, size: 40),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: TasawokModeColor.primary.withAlpha(217),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(TasawokModeColor.arabicLabel,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo')),
          ),
        ),
        if (product.discountPercentage != null)
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                  color: VirooColors.error.withAlpha(217),
                  borderRadius: BorderRadius.circular(6)),
              child: Text('-${product.discountPercentage}%',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo')),
            ),
          ),
      ],
    );
  }

  Widget _buildInfo() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(product.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: VirooColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  fontFamily: 'Cairo')),
          const SizedBox(height: 4),
          Text('${product.price.toStringAsFixed(0)} ج',
              style: TextStyle(
                  color: TasawokModeColor.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  fontFamily: 'Orbitron')),
        ],
      ),
    );
  }
}
