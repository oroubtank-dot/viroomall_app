// Profile Header
// lib/features/profile/presentation/widgets/profile_header.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../../domain/models/user_model.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel user;
  final Color themeColor;

  const ProfileHeader({
    super.key,
    required this.user,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        _buildProfileImage(),
        const SizedBox(height: 16),
        _buildUserInfo(),
      ],
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: GlassContainer(
        padding: const EdgeInsets.all(20),
        borderRadius: BorderRadius.circular(50),
        child: Icon(
          Icons.person_rounded,
          size: 60,
          color: themeColor,
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      children: [
        Text(
          user.name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '@${user.phone.substring(1)}',
          style: const TextStyle(
            fontSize: 14,
            color: VirooColors.textSecondary,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 8),
        if (user.rating > 0)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
              const SizedBox(width: 4),
              Text(
                '${user.rating.toStringAsFixed(1)} (${user.ratingCount} تقييم)',
                style: const TextStyle(
                  color: VirooColors.textSecondary,
                  fontFamily: 'Cairo',
                  fontSize: 13,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
