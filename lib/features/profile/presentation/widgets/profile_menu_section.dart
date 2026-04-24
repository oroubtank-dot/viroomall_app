// lib/features/profile/presentation/widgets/profile_menu_section.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../../../../core/services/auth_service.dart';
import '../../domain/models/user_model.dart';
import '../../domain/models/seller_stats.dart';
import '../../domain/models/buyer_stats.dart';
import '../screens/my_products_screen.dart';
import '../screens/seller_dashboard_screen.dart';
import '../screens/wallet_screen.dart';
import '../screens/points_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/my_orders_screen.dart';

class ProfileMenuSection extends StatelessWidget {
  final UserModel user;
  final Color themeColor;
  final SellerStats? sellerStats;
  final BuyerStats? buyerStats;
  final BuildContext parentContext;

  const ProfileMenuSection({
    super.key,
    required this.user,
    required this.themeColor,
    required this.parentContext,
    this.sellerStats,
    this.buyerStats,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(20),
      child: Column(
        children: [
          // تحذيرات المنتجات المنتهية
          if (user.isSeller && sellerStats != null) ...[
            if (sellerStats!.expiringProducts > 0) ...[
              _buildWarningBanner(
                '⚠️ لديك ${sellerStats!.expiringProducts} منتجات قاربت على الانتهاء',
                'جددها الآن',
                () {
                  Navigator.push(
                    parentContext,
                    MaterialPageRoute(
                        builder: (context) => const MyProductsScreen()),
                  );
                },
                VirooColors.warning,
              ),
              _buildDivider(),
            ],
            if (sellerStats!.expiredProducts > 0) ...[
              _buildWarningBanner(
                '🔴 لديك ${sellerStats!.expiredProducts} منتجات منتهية',
                'أعد نشرها',
                () {
                  Navigator.push(
                    parentContext,
                    MaterialPageRoute(
                        builder: (context) => const MyProductsScreen()),
                  );
                },
                VirooColors.error,
              ),
              _buildDivider(),
            ],
          ],

          // =============================================
          // طلباتي
          // =============================================
          _buildMenuItem(
            icon: Icons.shopping_bag_rounded,
            title: 'طلباتي',
            onTap: () {
              Navigator.push(
                parentContext,
                MaterialPageRoute(
                  builder: (context) => MyOrdersScreen(isSeller: user.isSeller),
                ),
              );
            },
          ),
          _buildDivider(),

          // =============================================
          // المفضلة
          // =============================================
          _buildMenuItem(
            icon: Icons.favorite_rounded,
            title: user.isBuyer && buyerStats != null
                ? 'المفضلة (${buyerStats!.favoritesCount})'
                : 'المفضلة',
            onTap: () {
              Navigator.push(
                parentContext,
                MaterialPageRoute(
                    builder: (context) => const FavoritesScreen()),
              );
            },
          ),

          // =============================================
          // قائمة البائع
          // =============================================
          if (user.isSeller && sellerStats != null) ...[
            _buildDivider(),

            // منتجاتي
            _buildMenuItem(
              icon: Icons.inventory_2_rounded,
              title: 'منتجاتي (${sellerStats!.totalProducts})',
              subtitle: _getProductsSubtitle(sellerStats!),
              hasWarning: sellerStats!.expiringProducts > 0 ||
                  sellerStats!.expiredProducts > 0,
              onTap: () {
                Navigator.push(
                  parentContext,
                  MaterialPageRoute(
                      builder: (context) => const MyProductsScreen()),
                );
              },
            ),
            _buildDivider(),

            // لوحة تحكم البائع
            _buildMenuItem(
              icon: Icons.dashboard_rounded,
              title: 'لوحة تحكم البائع',
              onTap: () {
                Navigator.push(
                  parentContext,
                  MaterialPageRoute(
                      builder: (context) => const SellerDashboardScreen()),
                );
              },
            ),
            _buildDivider(),

            // المحفظة
            _buildMenuItem(
              icon: Icons.account_balance_wallet_rounded,
              title: 'المحفظة (${sellerStats!.walletBalance.toInt()} ج.م)',
              onTap: () {
                Navigator.push(
                  parentContext,
                  MaterialPageRoute(builder: (context) => const WalletScreen()),
                );
              },
            ),
          ],

          _buildDivider(),

          // =============================================
          // النقاط والمكافآت
          // =============================================
          _buildMenuItem(
            icon: Icons.card_giftcard_rounded,
            title: _getPointsTitle(),
            onTap: () {
              Navigator.push(
                parentContext,
                MaterialPageRoute(builder: (context) => const PointsScreen()),
              );
            },
          ),
          _buildDivider(),

          // =============================================
          // دعوة صديق
          // =============================================
          _buildMenuItem(
            icon: Icons.person_add_rounded,
            title: 'دعوة صديق',
            onTap: () {},
          ),
          _buildDivider(),

          // =============================================
          // تقييم التطبيق
          // =============================================
          _buildMenuItem(
            icon: Icons.star_border_rounded,
            title: 'تقييم التطبيق',
            onTap: () {},
          ),
          _buildDivider(),

          // =============================================
          // اتصل بنا
          // =============================================
          _buildMenuItem(
            icon: Icons.headset_mic_rounded,
            title: 'اتصل بنا',
            onTap: () {},
          ),
          _buildDivider(),

          // =============================================
          // الإعدادات
          // =============================================
          _buildMenuItem(
            icon: Icons.settings_rounded,
            title: 'الإعدادات',
            onTap: () {},
          ),
          _buildDivider(),

          // =============================================
          // تسجيل الخروج
          // =============================================
          _buildMenuItem(
            icon: Icons.logout_rounded,
            title: 'تسجيل الخروج',
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: parentContext,
                builder: (context) => AlertDialog(
                  backgroundColor: VirooColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: const Text(
                    'تسجيل الخروج',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: const Text(
                    'هل أنت متأكد أنك تريد تسجيل الخروج؟',
                    style: TextStyle(
                      color: Colors.white70,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text(
                        'إلغاء',
                        style: TextStyle(
                          color: VirooColors.textSecondary,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: VirooColors.error,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'خروج',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ],
                ),
              );

              if (confirm == true && parentContext.mounted) {
                await AuthService.signOut();
                Navigator.pushReplacementNamed(parentContext, '/');
              }
            },
            isLogout: true,
          ),
        ],
      ),
    );
  }

  String _getPointsTitle() {
    if (user.isSeller && sellerStats != null) {
      return 'النقاط والمكافآت (${sellerStats!.totalPoints})';
    } else if (user.isBuyer && buyerStats != null) {
      return 'النقاط والمكافآت (${buyerStats!.points})';
    }
    return 'النقاط والمكافآت';
  }

  String _getProductsSubtitle(SellerStats stats) {
    if (stats.expiringProducts > 0 && stats.expiredProducts > 0) {
      return '${stats.expiringProducts} تنتهي قريباً • ${stats.expiredProducts} منتهية';
    } else if (stats.expiringProducts > 0) {
      return '${stats.expiringProducts} منتجات تنتهي قريباً';
    } else if (stats.expiredProducts > 0) {
      return '${stats.expiredProducts} منتجات منتهية';
    }
    return 'كل المنتجات نشطة ✅';
  }

  Widget _buildWarningBanner(
      String message, String action, VoidCallback onTap, Color color) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: color,
                fontFamily: 'Cairo',
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: onTap,
            child: Text(
              action,
              style: TextStyle(
                color: color,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    bool hasWarning = false,
    bool isLogout = false,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isLogout ? VirooColors.error : themeColor,
        size: 22,
      ),
      title: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: isLogout ? VirooColors.error : Colors.white,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w500,
            ),
          ),
          if (hasWarning) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: VirooColors.warning.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                '⚠️',
                style: TextStyle(
                  color: VirooColors.warning,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                color: hasWarning
                    ? VirooColors.warning
                    : VirooColors.textSecondary,
                fontFamily: 'Cairo',
                fontSize: 12,
              ),
            )
          : null,
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        color: isLogout ? VirooColors.error : VirooColors.textSecondary,
        size: 14,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.white.withOpacity(0.05),
      height: 1,
      indent: 70,
    );
  }
}
