// Buyer Stats Widget
// lib/features/profile/presentation/widgets/buyer_stats_widget.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../../domain/models/buyer_stats.dart';

class BuyerStatsWidget extends StatelessWidget {
  final BuyerStats stats;
  final Color themeColor;

  const BuyerStatsWidget({
    super.key,
    required this.stats,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('📦 طلبات', stats.totalOrders.toString()),
          _buildStatItem('❤️ مفضلة', stats.favoritesCount.toString()),
          _buildStatItem('🎁 نقاط', stats.points.toString()),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
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
