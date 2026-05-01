// lib/features/profile/presentation/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../../../../core/widgets/viroo_background.dart';
import '../../../../core/services/auth_service.dart';
import '../../../wallet/presentation/screens/wallet_screen.dart';
import '../../../wallet/presentation/providers/wallet_provider.dart';
import 'my_products_screen.dart';
import 'my_ads_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColor = VirooColors.amberPrimary;
    final user = AuthService.currentUser;

    return Scaffold(
      backgroundColor: VirooColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '👤 حسابي',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: VirooBackground(
        showOrbs: true,
        themeColor: themeColor,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildProfileHeader(
                user?.displayName ?? 'مستخدم VirooMall',
                user?.phoneNumber ?? 'غير مسجل',
              ),
              const SizedBox(height: 24),
              _buildBalanceCard(context, ref),
              const SizedBox(height: 24),
              GlassContainer(
                padding: EdgeInsets.zero,
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  children: [
                    _menuItem(
                      context,
                      icon: Icons.account_balance_wallet_rounded,
                      title: '💰 محفظتي',
                      subtitle: 'شحن واستخدام الرصيد',
                      color: VirooColors.amberPrimary,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WalletScreen()),
                      ),
                    ),
                    _divider(),
                    _menuItem(
                      context,
                      icon: Icons.shopping_bag_rounded,
                      title: '📦 منتجاتي',
                      subtitle: 'المنتجات اللي أضفتها',
                      color: VirooColors.shopping,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyProductsScreen()),
                      ),
                    ),
                    _divider(),
                    _menuItem(
                      context,
                      icon: Icons.campaign_rounded,
                      title: '📢 إعلاناتي',
                      subtitle: 'إدارة الإعلانات الممولة',
                      color: VirooColors.info,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyAdsScreen()),
                      ),
                    ),
                    _divider(),
                    _menuItem(
                      context,
                      icon: Icons.favorite_rounded,
                      title: '❤️ المفضلة',
                      subtitle: 'المنتجات اللي حفظتها',
                      color: VirooColors.error,
                      onTap: () => Navigator.pushNamed(context, '/favorites'),
                    ),
                    _divider(),
                    _menuItem(
                      context,
                      icon: Icons.star_rounded,
                      title: '⭐ تقييماتي',
                      subtitle: 'التقييمات والمراجعات',
                      color: const Color(0xFFFFB800),
                      onTap: () {},
                    ),
                    _divider(),
                    _menuItem(
                      context,
                      icon: Icons.settings_rounded,
                      title: '⚙️ إعدادات الحساب',
                      subtitle: 'تعديل الملف الشخصي',
                      color: VirooColors.textSecondary,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: VirooColors.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(
                              color: VirooColors.glassBorder, width: 1),
                        ),
                        title: const Text('تسجيل الخروج',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.bold)),
                        content: const Text(
                            'هل أنت متأكد أنك تريد تسجيل الخروج؟',
                            style: TextStyle(
                                color: Colors.white70, fontFamily: 'Cairo')),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('إلغاء',
                                style: TextStyle(
                                    color: VirooColors.textSecondary,
                                    fontFamily: 'Cairo')),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: VirooColors.error),
                            child: const Text('خروج',
                                style: TextStyle(
                                    color: Colors.white, fontFamily: 'Cairo')),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await AuthService.signOut();
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(context, '/');
                      }
                    }
                  },
                  icon: const Icon(Icons.logout_rounded,
                      color: VirooColors.error),
                  label: const Text('تسجيل الخروج',
                      style: TextStyle(
                          color: VirooColors.error,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side:
                        const BorderSide(color: VirooColors.error, width: 1.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(String name, String phone) {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [
                VirooColors.amberPrimary,
                VirooColors.amberLight,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: VirooColors.amberPrimary.withAlpha(76),
                blurRadius: 25,
                spreadRadius: 3,
              ),
            ],
          ),
          child: const Center(
            child: Icon(Icons.person_rounded, color: Colors.white, size: 45),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          phone,
          style: const TextStyle(
            color: VirooColors.textSecondary,
            fontSize: 14,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard(BuildContext context, WidgetRef ref) {
    final balanceAsync = ref.watch(walletBalanceProvider);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WalletScreen()),
        );
      },
      child: GlassContainer(
        padding: const EdgeInsets.all(18),
        borderRadius: BorderRadius.circular(20),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: VirooColors.amberPrimary.withAlpha(38),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.account_balance_wallet_rounded,
                  color: VirooColors.amberPrimary, size: 26),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('💰 محفظتي',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          fontFamily: 'Cairo')),
                  SizedBox(height: 2),
                  Text('اضغط للشحن والاستخدام',
                      style: TextStyle(
                          color: VirooColors.textSecondary,
                          fontSize: 11,
                          fontFamily: 'Cairo')),
                ],
              ),
            ),
            balanceAsync.when(
              data: (balance) => Text(
                '${balance.toStringAsFixed(0)} ج',
                style: const TextStyle(
                    color: VirooColors.amberPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'Orbitron'),
              ),
              loading: () => const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: VirooColors.amberPrimary),
              ),
              error: (_, __) => const Text('0 ج',
                  style: TextStyle(
                      color: VirooColors.amberPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: 'Orbitron')),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios_rounded,
                color: VirooColors.textSecondary, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color.withAlpha(38),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(title,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
              fontFamily: 'Cairo')),
      subtitle: Text(subtitle,
          style: const TextStyle(
              color: VirooColors.textSecondary,
              fontSize: 11,
              fontFamily: 'Cairo')),
      trailing: const Icon(Icons.arrow_forward_ios_rounded,
          color: VirooColors.textSecondary, size: 14),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
    );
  }

  Widget _divider() {
    return const Divider(
      color: VirooColors.glassBorder,
      height: 1,
      indent: 20,
      endIndent: 20,
    );
  }
}
