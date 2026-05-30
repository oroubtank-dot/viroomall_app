// lib/features/product/presentation/widgets/product_image_section.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../../../../core/models/product_model.dart';

class ProductImageSection extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onBackPressed;

  const ProductImageSection({
    super.key,
    required this.product,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = product.images.isNotEmpty ? product.images[0] : '';
    final modeColor = product.modeColor;
    final discountPercentage = product.discountPercentage;

    return Hero(
      tag: 'product_${product.id}',
      child: Container(
        height: 350,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              modeColor.withOpacity(0.3),
              modeColor.withOpacity(0.05),
            ],
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      height: 300,
                      errorBuilder: (context, error, stack) {
                        return Icon(
                          Icons.image_not_supported_rounded,
                          size: 100,
                          color: modeColor,
                        );
                      },
                    )
                  : Icon(
                      Icons.shopping_bag_rounded,
                      size: 120,
                      color: modeColor,
                    ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: GestureDetector(
                onTap: onBackPressed,
                child: GlassContainer(
                  padding: const EdgeInsets.all(12),
                  borderRadius: BorderRadius.circular(15),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: modeColor,
                    size: 24,
                  ),
                ),
              ),
            ),
            if (discountPercentage != null)
              Positioned(
                top: 10,
                right: 10,
                child: GlassContainer(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  borderRadius: BorderRadius.circular(20),
                  child: Text(
                    'خصم $discountPercentage%',
                    style: const TextStyle(
                      color: VirooColors.error,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            Positioned(
              bottom: 10,
              left: 10,
              child: GlassContainer(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                borderRadius: BorderRadius.circular(20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(product.modeIcon,
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 6),
                    Text(
                      _getProductTypeArabic(product.productType),
                      style: TextStyle(
                        color: modeColor,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Cairo',
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getProductTypeArabic(String type) {
    switch (type) {
      case 'wholesale':
        return 'جملة';
      case 'used':
        return 'مستعمل';
      case 'outlet':
        return 'فرز إنتاج';
      default:
        return 'جديد';
    }
  }
}
