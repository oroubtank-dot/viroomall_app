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
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(20),
      child: Row(
        children: [
          // الصورة الشخصية
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: VirooColors.glassDark,
              border: Border.all(color: themeColor, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: user.photoUrl.isNotEmpty
                  ? Image.network(user.photoUrl, fit: BoxFit.cover)
                  : Icon(
                      user.isSeller
                          ? Icons.store_rounded
                          : Icons.person_rounded,
                      size: 40,
                      color: VirooColors.textSecondary,
                    ),
            ),
          ),
          const SizedBox(width: 16),

          // الاسم والإحصائيات
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        size: 14, color: VirooColors.warning),
                    const SizedBox(width: 4),
                    Text(
                      user.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${user.totalSales})',
                      style: const TextStyle(
                        fontSize: 10,
                        color: VirooColors.textSecondary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  user.isSeller ? '📦 بائع محترف' : '🛍️ مشتري',
                  style: const TextStyle(
                    fontSize: 11,
                    color: VirooColors.textSecondary,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),

          // زر تعديل (للمستخدم فقط)
          if (user.isSeller)
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.edit_rounded, color: themeColor, size: 20),
            ),
        ],
      ),
    );
  }
}
