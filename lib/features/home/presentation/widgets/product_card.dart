// lib/features/home/presentation/widgets/product_card.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/product_model.dart';

class VirooProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onCartTap;
  final bool isFavorite;

  const VirooProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onFavoriteTap,
    this.onCartTap,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    print('🔥🔥🔥 الكارت الجديد شغال 🔥🔥🔥');
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: VirooColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: VirooColors.glassBorder, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildImageSection(),
            _buildDetailsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          child: CachedNetworkImage(
            imageUrl: product.images.isNotEmpty ? product.images.first : '',
            height: 100,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: VirooColors.glassDark,
              highlightColor: VirooColors.glassMedium,
              child: Container(height: 100, color: VirooColors.surface),
            ),
            errorWidget: (context, url, error) => Container(
              height: 100,
              color: VirooColors.glassDark,
              child: const Icon(Icons.image_not_supported,
                  color: VirooColors.textSecondary, size: 28),
            ),
            memCacheWidth: 150,
            memCacheHeight: 150,
          ),
        ),
        if (product.discountPercentage != null)
          Positioned(
            top: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: VirooColors.error,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '-${product.discountPercentage}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 7,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        Positioned(
          bottom: 4,
          left: 4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
            decoration: BoxDecoration(
              color: product.modeColor.withOpacity(0.85),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              product.modeLabel.split(' ').first,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 7,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        if (onFavoriteTap != null)
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: onFavoriteTap,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  size: 10,
                  color: isFavorite ? VirooColors.error : Colors.white,
                ),
              ),
            ),
          ),
        if (onCartTap != null)
          Positioned(
            bottom: 4,
            right: 4,
            child: GestureDetector(
              onTap: onCartTap,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: VirooColors.amberPrimary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.add_shopping_cart_rounded,
                  size: 10,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDetailsSection() {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Icon(Icons.store_rounded,
                  size: 7, color: VirooColors.textSecondary),
              const SizedBox(width: 2),
              Expanded(
                child: Text(
                  _getSellerName(product.sellerId),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 7,
                    color: VirooColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Text(
                '${product.price.toStringAsFixed(0)} ج.م',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: VirooColors.amberPrimary,
                ),
              ),
              if (product.originalPrice != null &&
                  product.originalPrice! > product.price)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    '${product.originalPrice!.toStringAsFixed(0)} ج.م',
                    style: const TextStyle(
                      fontSize: 7,
                      decoration: TextDecoration.lineThrough,
                      color: VirooColors.textSecondary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 1),
          Row(
            children: [
              const Icon(Icons.star_rounded,
                  size: 7, color: VirooColors.warning),
              const SizedBox(width: 1),
              Text(
                product.averageRating.toStringAsFixed(1),
                style: const TextStyle(fontSize: 7, color: Colors.white),
              ),
              const SizedBox(width: 2),
              Container(width: 1, height: 5, color: VirooColors.textSecondary),
              const SizedBox(width: 2),
              Text(
                '${product.ratingCount}',
                style: const TextStyle(
                    fontSize: 6, color: VirooColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getSellerName(String sellerId) {
    const Map<String, String> sellers = {
      'seller_123': 'متجر الإلكترونيات',
      'seller_456': 'متجر الأزياء',
      'seller_789': 'متجر المنزل',
    };
    return sellers[sellerId] ?? 'متجر';
  }
}
