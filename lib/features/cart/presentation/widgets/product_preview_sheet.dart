// lib/features/cart/presentation/widgets/product_preview_sheet.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../../../../core/models/product_model.dart';

class ProductPreviewSheet extends StatelessWidget {
  final ProductModel product;

  const ProductPreviewSheet({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final modeColor = product.modeColor;
    final imageUrl = product.images.isNotEmpty ? product.images[0] : '';

    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: const BoxDecoration(
        color: VirooColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          // مقبض للسحب
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          // المحتوى
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // صورة المنتج
                  Container(
                    height: 180,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: modeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: imageUrl.isNotEmpty
                          ? (imageUrl.startsWith('http')
                              ? Image.network(imageUrl, fit: BoxFit.contain)
                              : Image.memory(base64Decode(imageUrl),
                                  fit: BoxFit.contain))
                          : Icon(Icons.shopping_bag_rounded,
                              size: 80, color: modeColor),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // تفاصيل المنتج
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              '${product.price.toStringAsFixed(0)} ج.م',
                              style: TextStyle(
                                fontSize: 26,
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
                                  fontSize: 16,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                  fontFamily: 'Orbitron',
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 16),

                        // معلومات البائع
                        GlassContainer(
                          padding: const EdgeInsets.all(12),
                          borderRadius: BorderRadius.circular(16),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: modeColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child:
                                    Icon(Icons.store_rounded, color: modeColor),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'بائع VirooMall',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontFamily: 'Cairo',
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Icon(Icons.star_rounded,
                                            color: Colors.amber, size: 14),
                                        SizedBox(width: 4),
                                        Text(
                                          '4.5 (120 تقييم)',
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
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // وصف المنتج
                        const Text(
                          'وصف المنتج',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: VirooColors.textSecondary,
                            fontFamily: 'Cairo',
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
