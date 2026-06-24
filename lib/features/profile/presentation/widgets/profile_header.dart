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
    final isSeller = user.isSeller;

    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(20),
      child: Column(
        children: [
          Row(
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
                          isSeller ? Icons.store_rounded : Icons.person_rounded,
                          size: 40,
                          color: VirooColors.textSecondary,
                        ),
                ),
              ),
              const SizedBox(width: 16),

              // الاسم والمعلومات
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // الاسم (أو اسم المتجر للبائع)
                    Text(
                      isSeller && user.storeName.isNotEmpty
                          ? user.storeName
                          : user.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 4),

                    // وصف المتجر (للبائع)
                    if (isSeller && user.storeDescription.isNotEmpty) ...[
                      Text(
                        user.storeDescription,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: VirooColors.textSecondary,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],

                    // التقييم
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

                    // نوع الحساب
                    Text(
                      isSeller ? '📦 بائع محترف' : '🛍️ مشتري',
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
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/edit-store');
                },
                icon: Icon(Icons.edit_rounded, color: themeColor, size: 20),
              ),
            ],
          ),

          // إحصائيات البائع (عدد المنتجات - المشاهدات - المبيعات)
          if (isSeller) ...[
            const SizedBox(height: 16),
            const Divider(color: VirooColors.glassBorder),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('📦 منتجات', user.totalProducts.toString()),
                _buildStatItem('👁️ مشاهدات', user.totalViews.toString()),
                _buildStatItem('🛒 مبيعات', user.totalSales.toString()),
              ],
            ),
          ],
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
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Orbitron',
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: VirooColors.textSecondary,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }
}