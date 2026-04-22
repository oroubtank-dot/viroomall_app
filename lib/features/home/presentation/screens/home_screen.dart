// lib/features/home/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../../../../core/widgets/viroo_background.dart';
import '../../../../core/widgets/viroo_search_bar.dart';
import '../../../../core/services/auth_service.dart';
import '../../../admin/presentation/screens/add_product_screen.dart';
import '../../../cart/presentation/screens/cart_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../../presentation/screens/auth/widgets/login_bottom_sheet.dart';
import '../providers/home_provider.dart';
import '../widgets/mode_selector.dart';
import '../widgets/hot_sales_banner.dart';
import '../widgets/featured_products_section.dart';
import '../widgets/floating_nav_bar.dart';

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
          // أيقونة إضافة منتج
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddProductScreen()),
              );
            },
            child: GlassContainer(
              padding: const EdgeInsets.all(10),
              borderRadius: BorderRadius.circular(12),
              child: Icon(Icons.add_rounded, color: themeColor, size: 22),
            ),
          ),
          const SizedBox(width: 8),
          // أيقونة الإشعارات
          GlassContainer(
            padding: const EdgeInsets.all(10),
            borderRadius: BorderRadius.circular(12),
            child:
                Icon(Icons.notifications_outlined, color: themeColor, size: 22),
          ),
          const SizedBox(width: 8),
          // أيقونة تسجيل الخروج مع Dialog تأكيد
          GestureDetector(
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
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

              if (confirm == true && context.mounted) {
                await AuthService.signOut();
                Navigator.pushReplacementNamed(context, '/');
              }
            },
            child: GlassContainer(
              padding: const EdgeInsets.all(10),
              borderRadius: BorderRadius.circular(12),
              child: const Icon(Icons.logout_rounded,
                  color: VirooColors.error, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  late final List<Widget> _screens;

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
    return WillPopScope(
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
            if (index == 0) {
              // الرئيسية - مسموح للكل
              setState(() => _currentIndex = index);
            } else if (index == 1) {
              // المفضلة - تحتاج تسجيل دخول
              _checkAuthAndNavigate(context, () {
                setState(() => _currentIndex = index);
              });
            } else if (index == 2) {
              // السلة - تحتاج تسجيل دخول
              _checkAuthAndNavigate(context, () {
                setState(() => _currentIndex = index);
              });
            } else if (index == 3) {
              // حسابي - تحتاج تسجيل دخول
              _checkAuthAndNavigate(context, () {
                setState(() => _currentIndex = index);
              });
            }
          },
        ),
      ),
    );
  }
}
