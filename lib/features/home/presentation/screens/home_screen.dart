// lib/features/home/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../../../../core/widgets/viroo_background.dart';
import '../../../../core/widgets/viroo_search_bar.dart';
import '../../../../core/services/auth_service.dart';
import '../../../cart/presentation/screens/cart_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../../presentation/screens/auth/widgets/login_bottom_sheet.dart';
import '../providers/home_provider.dart';
import '../widgets/mode_selector.dart';
import '../widgets/hot_sales_banner.dart';
import '../widgets/featured_products_section.dart';
import '../widgets/floating_nav_bar.dart';
import '../../../../core/widgets/settings_portal/settings_portal_button.dart';
import '../../../admin/presentation/screens/add_product_screen.dart';
import '../../../../features/ads/presentation/widgets/ads_slider.dart';
import '../../../../features/ads/presentation/screens/ad_marketplace_screen.dart';

class HomeContent extends ConsumerWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMode = ref.watch(shopModeProvider);
    final modes = ref.watch(shopModesProvider);
    final themeColor = ref.watch(modeColorProvider);

    return VirooBackground(
      showOrbs: true,
      themeColor: themeColor,
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildHeader(context, themeColor),
              const Padding(
                padding: EdgeInsets.all(20),
                child: VirooSearchBar(),
              ),
              const VirooAdsSlider(),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      '📂 أقسام رئيسية',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: themeColor,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              ModeSelector(
                modes: modes,
                selectedMode: selectedMode,
              ),
              const HotSalesBanner(),
              const FeaturedProductsSection(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color themeColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Row(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [themeColor, themeColor.withOpacity(0.7)],
            ).createShader(bounds),
            child: const Text(
              'VirooMall',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Cairo',
                letterSpacing: 1.5,
              ),
            ),
          ),
          const Spacer(),
          // ⚙️ بوابة الإعدادات السحرية
          SettingsPortalButton(
            onSettingsTap: () {
              final homeState =
                  context.findAncestorStateOfType<HomeScreenState>();
              homeState?.openSettings();
            },
            hasNotification: true,
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  late final List<Widget> _screens;
  bool isSettingsOpen = false;

  void openSettings() {
    setState(() => isSettingsOpen = true);
  }

  void closeSettings() {
    setState(() => isSettingsOpen = false);
  }

  void _navigateToAddProduct() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddProductScreen(),
      ),
    );
  }

  void _checkAuthAndNavigate(BuildContext context, VoidCallback action) {
    if (AuthService.currentUser != null) {
      action();
    } else {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) => LoginBottomSheet(
          onLoginSuccess: action,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeContent(), // 0: الرئيسية
      const Center(
          child: Text("المفضلة",
              style: TextStyle(
                  color: Colors.white, fontFamily: 'Cairo'))), // 1: المفضلة
      const CartScreen(), // 2: السلة
      const ProfileScreen(), // 3: البروفايل
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SettingsRevealOverlay(
      isOpen: isSettingsOpen,
      onClose: closeSettings,
      background: WillPopScope(
        onWillPop: () async {
          if (_currentIndex != 0) {
            setState(() => _currentIndex = 0);
            return false;
          }
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: VirooColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                'خروج',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: const Text(
                'هل تريد الخروج من التطبيق؟',
                style: TextStyle(
                  color: Colors.white70,
                  fontFamily: 'Cairo',
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
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
          return confirm ?? false;
        },
        child: Scaffold(
          body: _screens[_currentIndex],
          bottomNavigationBar: FloatingNavBar(
            selectedIndex: _currentIndex,
            onTap: (index) {
              if (index == -1) {
                // ⭐ الزرار الأوسط (إضافة منتج)
                _checkAuthAndNavigate(context, _navigateToAddProduct);
                return;
              }
              if (index == 0) {
                setState(() => _currentIndex = index);
              } else if (index == 1) {
                _checkAuthAndNavigate(context, () {
                  setState(() => _currentIndex = index);
                });
              } else if (index == 2) {
                _checkAuthAndNavigate(context, () {
                  setState(() => _currentIndex = index);
                });
              } else if (index == 3) {
                _checkAuthAndNavigate(context, () {
                  setState(() => _currentIndex = index);
                });
              }
            },
          ),
        ),
      ),
      settingsPanel: Container(
        decoration: BoxDecoration(
          color: VirooColors.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            bottomLeft: Radius.circular(30),
          ),
          border: Border.all(
            color: VirooColors.glassBorder,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: VirooColors.amberPrimary.withOpacity(0.3),
              blurRadius: 30,
              offset: const Offset(-10, 0),
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 60),
            Row(
              children: [
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: closeSettings,
                  child: const Icon(
                    Icons.close_rounded,
                    color: VirooColors.textSecondary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  '⚙️ الإعدادات',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: VirooColors.textPrimary,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            _buildSettingsItem(Icons.person_outline, 'الملف الشخصي', () {}),
            _buildSettingsItem(
                Icons.notifications_outlined, 'الإشعارات', () {}),
            _buildSettingsItem(Icons.lock_outline, 'الخصوصية والأمان', () {}),
            _buildSettingsItem(Icons.palette_outlined, 'تخصيص المظهر', () {}),
            _buildSettingsItem(Icons.language, 'اللغة', () {}),
            _buildSettingsItem(
              Icons.campaign_rounded,
              '🏦 سوق الإعلانات',
              () {
                closeSettings();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdMarketplaceScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            const Spacer(),
            _buildSettingsItem(
              Icons.logout_rounded,
              'تسجيل الخروج',
              () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: VirooColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: VirooColors.glassBorder,
                        width: 1,
                      ),
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
                        onPressed: () => Navigator.pop(ctx, false),
                        child: Text(
                          'إلغاء',
                          style: TextStyle(
                            color: VirooColors.textSecondary,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(ctx, true),
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

                if (confirm == true) {
                  await AuthService.signOut();
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/');
                  }
                }
              },
              isLogout: true,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, VoidCallback onTap,
      {bool isLogout = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GestureDetector(
        onTap: onTap,
        child: GlassContainer(
          padding: const EdgeInsets.all(16),
          borderRadius: BorderRadius.circular(12),
          child: Row(
            children: [
              Icon(
                icon,
                color: isLogout ? VirooColors.error : VirooColors.amberPrimary,
                size: 22,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isLogout ? VirooColors.error : VirooColors.textPrimary,
                  fontFamily: 'Cairo',
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: isLogout
                    ? VirooColors.error.withOpacity(0.5)
                    : VirooColors.textSecondary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
