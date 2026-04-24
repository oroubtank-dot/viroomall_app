// Product Stats Card
// lib/features/profile/presentation/widgets/product_stats_card.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../models/seller_product.dart';

class ProductStatsCard extends StatelessWidget {
  final SellerProduct product;
  final Color themeColor;
  final VoidCallback onTap;
  final VoidCallback onShare;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductStatsCard({
    super.key,
    required this.product,
    required this.themeColor,
    required this.onTap,
    required this.onShare,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (product.status) {
      case 'active':
        statusColor = VirooColors.success;
        statusText = 'نشط';
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'expiring':
        statusColor = VirooColors.warning;
        statusText = 'ينتهي خلال ${product.daysLeft} أيام';
        statusIcon = Icons.hourglass_empty_rounded;
        break;
      case 'expired':
        statusColor = VirooColors.error;
        statusText = 'منتهي';
        statusIcon = Icons.cancel_rounded;
        break;
      default:
        statusColor = Colors.grey;
        statusText = '';
        statusIcon = Icons.info_rounded;
    }

    Color performanceColor;
    if (product.views > 1000 && product.clicks > 300) {
      performanceColor = VirooColors.success;
    } else if (product.views > 500 && product.clicks > 100) {
      performanceColor = VirooColors.warning;
    } else {
      performanceColor = VirooColors.textSecondary;
    }

    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            _buildProductInfo(statusColor, statusText, statusIcon),
            const SizedBox(height: 12),
            _buildMetrics(performanceColor),
            const SizedBox(height: 8),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductInfo(
      Color statusColor, String statusText, IconData statusIcon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            product.imageUrl,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) => Container(
              width: 80,
              height: 80,
              color: themeColor.withOpacity(0.1),
              child: Icon(Icons.image_not_supported, color: themeColor),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  fontSize: 15,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '${product.price.toStringAsFixed(0)} ج.م',
                style: TextStyle(
                  color: themeColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Orbitron',
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(statusIcon, color: statusColor, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    statusText,
                    style: TextStyle(
                        color: statusColor, fontFamily: 'Cairo', fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetrics(Color performanceColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: performanceColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMetricItem(
            icon: Icons.visibility_rounded,
            value: _formatNumber(product.views),
            label: 'مشاهدة',
            color: performanceColor,
          ),
          _buildMetricItem(
            icon: Icons.touch_app_rounded,
            value: _formatNumber(product.clicks),
            label: 'نقرة',
            color: performanceColor,
          ),
          _buildMetricItem(
            icon: Icons.shopping_cart_rounded,
            value: _formatNumber(product.sales),
            label: 'مبيعة',
            color: performanceColor,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Orbitron',
                fontSize: 14,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: VirooColors.textSecondary,
                fontFamily: 'Cairo',
                fontSize: 9,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          icon: Icons.share_rounded,
          label: 'مشاركة',
          color: VirooColors.info,
          onTap: onShare,
        ),
        _buildActionButton(
          icon: Icons.edit_rounded,
          label: 'تعديل',
          color: VirooColors.warning,
          onTap: onEdit,
        ),
        _buildActionButton(
          icon: product.status == 'expired'
              ? Icons.refresh_rounded
              : Icons.delete_rounded,
          label: product.status == 'expired' ? 'تجديد' : 'حذف',
          color: product.status == 'expired'
              ? VirooColors.success
              : VirooColors.error,
          onTap: onDelete,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(color: color, fontFamily: 'Cairo', fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
