// lib/features/profile/presentation/widgets/dashboard/dashboard_top_products.dart
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_widgets.dart';
import '../../../../../core/models/product_model.dart';

class DashboardTopProducts extends StatelessWidget {
  final List<ProductModel> products;

  const DashboardTopProducts({super.key, required this.products});

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
              Icon(Icons.trending_up_rounded,
                  color: VirooColors.amberPrimary, size: 20),
              SizedBox(width: 8),
              Text(
                '🚀 الأكثر مشاهدة',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (products.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'لا توجد منتجات حتى الآن',
                  style: TextStyle(
                    color: VirooColors.textSecondary,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            )
          else
            ...products.map((product) => _buildProductItem(product)),
        ],
      ),
    );
  }

  Widget _buildProductItem(ProductModel product) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: VirooColors.glassDark,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: product.images.isNotEmpty
                  ? Image.network(product.images.first, fit: BoxFit.cover)
                  : const Icon(Icons.image, color: VirooColors.textSecondary),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontFamily: 'Cairo',
                  ),
                ),
                Text(
                  '👁️ ${product.views} مشاهدة',
                  style: const TextStyle(
                    fontSize: 10,
                    color: VirooColors.textSecondary,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${product.price.toStringAsFixed(0)} ج.م',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: VirooColors.amberPrimary,
              fontFamily: 'Orbitron',
            ),
          ),
        ],
      ),
    );
  }
}
