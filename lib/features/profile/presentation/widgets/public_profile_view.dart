// lib/features/profile/presentation/widgets/public_profile_view.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import 'profile_share_button.dart';

class PublicProfileView extends StatelessWidget {
  final String name;
  final String phone;
  final bool isVerified;
  final int productsCount;
  final String userId;

  const PublicProfileView({
    super.key,
    required this.name,
    required this.phone,
    required this.isVerified,
    required this.productsCount,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(24),
      borderRadius: BorderRadius.circular(20),
      child: Column(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(colors: [VirooColors.amberPrimary, VirooColors.amberLight]),
              boxShadow: [BoxShadow(color: VirooColors.amberPrimary.withAlpha(76), blurRadius: 25, spreadRadius: 3)],
            ),
            child: const Center(child: Icon(Icons.person_rounded, color: Colors.white, size: 45)),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
              if (isVerified) ...[
                const SizedBox(width: 8),
                const Icon(Icons.verified_rounded, color: VirooColors.success, size: 22),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text('📦 $productsCount منتج', style: const TextStyle(color: VirooColors.textSecondary, fontSize: 14, fontFamily: 'Cairo')),
          const SizedBox(height: 16),
          ProfileShareButton(userId: userId, sellerName: name),
        ],
      ),
    );
  }
}