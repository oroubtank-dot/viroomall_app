// lib/features/home/presentation/widgets/product_card.dart
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/product_model.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../../core/widgets/cart_notification.dart';

class VirooProductCard extends ConsumerWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const VirooProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartNotifier = ref.read(cartProvider.notifier);
    final isInCart = ref.watch(isInCartProvider(product.id));
    final themeColor = _getModeColor(product.productType);
    final modeLabel = _getModeLabel(product.productType);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: themeColor.withOpacity(0.15),
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
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.08),
                    Colors.white.withOpacity(0.02),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildImageSection(themeColor, modeLabel),
                  ),
                  _buildProductInfo(
                      context, themeColor, isInCart, cartNotifier),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(Color themeColor, String modeLabel) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: themeColor.withOpacity(0.05),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: product.images.isNotEmpty
              ? ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.memory(
                    base64Decode(product.images.first),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildPlaceholder(themeColor);
                    },
                  ),
                )
              : _buildPlaceholder(themeColor),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.85),
              borderRadius: BorderRadius.circular(8),
              border:
                  Border.all(color: Colors.white.withOpacity(0.2), width: 0.5),
            ),
            child: Text(modeLabel,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo')),
          ),
        ),
        Positioned(
          top: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(6)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.remove_red_eye_rounded,
                    color: Colors.white60, size: 12),
                const SizedBox(width: 3),
                Text(_formatViews(product.views),
                    style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 10,
                        fontFamily: 'Cairo')),
              ],
            ),
          ),
        ),
        if (product.discountPercentage != null)
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                  color: VirooColors.error.withOpacity(0.85),
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

  Widget _buildProductInfo(BuildContext context, Color themeColor,
      bool isInCart, CartNotifier cartNotifier) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: VirooColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      fontFamily: 'Cairo'),
                ),
                const SizedBox(height: 2),
                Text(
                  '${product.price.toStringAsFixed(0)} ج',
                  style: TextStyle(
                      color: themeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: 'Orbitron'),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              if (isInCart) {
                cartNotifier.removeFromCart(product.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('🗑️ تم حذف "${product.title}" من السلة',
                        style: const TextStyle(fontFamily: 'Cairo')),
                    backgroundColor: VirooColors.error,
                    duration: const Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else {
                cartNotifier.addToCart(product);
                CartNotification.show(context, product);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isInCart
                    ? VirooColors.error.withOpacity(0.2)
                    : themeColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: isInCart
                        ? VirooColors.error.withOpacity(0.4)
                        : themeColor.withOpacity(0.3),
                    width: 1),
              ),
              child: Icon(
                  isInCart
                      ? Icons.shopping_cart_rounded
                      : Icons.add_shopping_cart_rounded,
                  color: isInCart ? VirooColors.error : themeColor,
                  size: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(Color themeColor) {
    return Center(
        child: Icon(Icons.image_rounded,
            color: themeColor.withOpacity(0.3), size: 40));
  }

  Color _getModeColor(String productType) {
    switch (productType) {
      case 'new':
        return VirooColors.shopping;
      case 'wholesale':
        return VirooColors.wholesale;
      case 'used':
        return VirooColors.used;
      case 'outlet':
        return VirooColors.outlet;
      default:
        return VirooColors.shopping;
    }
  }

  String _getModeLabel(String productType) {
    switch (productType) {
      case 'new':
        return '🛍️ تسوق';
      case 'wholesale':
        return '🏪 جملة';
      case 'used':
        return '♻️ مستعمل';
      case 'outlet':
        return '🔥 فرز إنتاج';
      default:
        return '🛍️ تسوق';
    }
  }

  String _formatViews(int views) {
    if (views >= 1000) return '${(views / 1000).toStringAsFixed(1)}k';
    return views.toString();
  }
}
