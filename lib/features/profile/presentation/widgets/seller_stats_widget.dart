// Seller Stats Widget
// lib/features/profile/presentation/widgets/seller_stats_widget.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../../domain/models/seller_stats.dart';

class SellerStatsWidget extends StatelessWidget {
  final SellerStats stats;
  final Color themeColor;

  const SellerStatsWidget({
    super.key,
    required this.stats,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildMainStats(),
        const SizedBox(height: 12),
        _buildProductStats(),
      ],
    );
  }

  Widget _buildMainStats() {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('👁️ مشاهدات', stats.totalViews.toString()),
          _buildStatItem('👀 نقرات', stats.totalClicks.toString()),
          _buildStatItem('🛒 مبيعات', stats.totalSales.toString()),
          _buildStatItem('💰 المحفظة', '${stats.walletBalance.toInt()} ج.م'),
        ],
      ),
    );
  }

  Widget _buildProductStats() {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('📦 نشطة', stats.activeProducts.toString(),
              color: VirooColors.success),
          _buildStatItem('⏳ تنتهي قريباً', stats.expiringProducts.toString(),
              color: VirooColors.warning),
          _buildStatItem('🔴 منتهية', stats.expiredProducts.toString(),
              color: VirooColors.error),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, {Color? color}) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color ?? Colors.white,
            fontFamily: 'Orbitron',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: VirooColors.textSecondary,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }
}
