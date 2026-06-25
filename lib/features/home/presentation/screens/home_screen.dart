// lib/features/home/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../../../../core/widgets/viroo_background.dart';
import '../../../../core/widgets/viroo_search_bar.dart';
import '../../../../core/providers/product_mode_provider.dart';
import '../../../../core/models/product_model.dart';
import '../../../../core/services/auth_service.dart';
import '../../../cart/presentation/screens/cart_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../auth/widgets/login_bottom_sheet.dart';
import '../../../settings/presentation/screens/appearance_settings_screen.dart';
import '../../../settings/presentation/screens/language_settings_screen.dart';
import '../../../settings/presentation/screens/privacy_settings_screen.dart';
import '../../../seller_convert/presentation/screens/convert_to_seller_screen.dart';
import '../../../notifications/presentation/screens/notifications_screen.dart';
import '../providers/home_provider.dart';
import '../widgets/mode_selector.dart';
import '../widgets/featured_products_section.dart';
import '../widgets/floating_nav_bar.dart';
import '../widgets/loading_grid.dart';
import '../widgets/empty_products.dart';
import '../widgets/product_card.dart';
import '../../../../core/widgets/settings_portal/settings_portal_button.dart';
import '../../../admin/presentation/screens/add_product_screen.dart';
import '../../../ads/presentation/widgets/ads_slider.dart';
import '../../../ads/presentation/screens/ad_marketplace_screen.dart';
import '../../../favorites/presentation/screens/favorites_screen.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../favorites/presentation/providers/favorites_provider.dart';

class HomeContent extends ConsumerWidget {
  const HomeContent({super.key});

  // دالة مساعدة للتحويل المؤقت من ShopMode لـ String للـ productModeProvider
  String _modeToString(ShopMode mode) {
    switch (mode) {
      case ShopMode.shopping:
        return 'farz';
      case ShopMode.wholesale:
        return 'gomla';
      case ShopMode.used:
        return 'mosta3mal';
      case ShopMode.outlet:
        return 'tasawok';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMode = ref.watch(shopModeProvider);
    final themeColor = ref.watch(modeColorProvider);
    final productsAsync =
        ref.watch(productModeProvider(_modeToString(selectedMode)));
    final isLoggedIn = AuthService.currentUser != null;

    ref.listen(shopModeProvider, (previous, next) {
      ref.read(productModeProvider(_modeToString(next)).notifier).refresh();
    });

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
              _buildCategoriesSection(themeColor),
              const SizedBox(height: 4),
              ModeSelector(
                modes: ref.watch(shopModesProvider),
                selectedMode: selectedMode,
              ),
              const FeaturedProductsSection(),
              _buildProductsSection(productsAsync, themeColor, ref, isLoggedIn),
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
              colors: [themeColor, themeColor.withAlpha(178)],
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
          IconButton(
            icon: const Icon(Icons.notifications_rounded, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
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

  Widget _buildCategoriesSection(Color themeColor) {
    return Padding(
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
    );
  }

  Widget _buildProductsSection(
    AsyncValue<List<ProductModel>> productsAsync,
    Color themeColor,
    WidgetRef ref,
    bool isLoggedIn,
  ) {
    final cartNotifier = ref.read(cartProvider.notifier);
    final favoritesNotifier = ref.read(favoritesProvider.notifier);
    final favoritesList = ref.watch(favoritesProvider);

    return productsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: LoadingGrid(),
      ),
      error: (error, stack) => Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              const Icon(Icons.error_outline,
                  color: VirooColors.error, size: 48),
              const SizedBox(height: 12),
              Text(
                'حدث خطأ في تحميل المنتجات',
                style:
                    const TextStyle(color: Colors.white70, fontFamily: 'Cairo'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  ref.refresh(productModeProvider(
                      _modeToString(ref.read(shopModeProvider))));
                },
                child: const Text('إعادة المحاولة',
                    style: TextStyle(color: VirooColors.amberPrimary)),
              ),
            ],
          ),
        ),
      ),
      data: (products) {
        if (products.isEmpty) {
          return const EmptyProducts();
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.72,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final isFavorite = favoritesList.any((p) => p.id == product.id);

              return VirooProductCard(
                product: product,
                onTap: () {
                  _incrementViewCount(ref, product);
                  Navigator.pushNamed(context, '/product',
                      arguments: product.id);
                },
                onFavoriteTap: () {
                  if (!isLoggedIn) {
                    _showLoginDialog(context);
                    return;
                  }
                  if (isFavorite) {
                    favoritesNotifier.removeFromFavorites(product.id);
                    _showSnackBar(context, 'تم إزالة المنتج من المفضلة');
                  } else {
                    favoritesNotifier.addToFavorites(product);
                    _showSnackBar(context, 'تم إضافة المنتج إلى المفضلة');
                  }
                },
                onCartTap: () {
                  if (!isLoggedIn) {
                    _showLoginDialog(context);
                    return;
                  }
                  cartNotifier.addToCart(product);
                  _showSnackBar(context, 'تم إضافة المنتج إلى السلة');
                },
                isFavorite: isFavorite,
              );
            },
          ),
        );
      },
    );
  }

  void _incrementViewCount(WidgetRef ref, ProductModel product) {
    ref
        .read(productModeProvider(_modeToString(ref.read(shopModeProvider)))
            .notifier)
        .incrementViewCount(product.id);
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Cairo')),
        backgroundColor: VirooColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: VirooColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('تسجيل الدخول',
            style: TextStyle(color: Colors.white, fontFamily: 'Cairo')),
        content: const Text('يرجى تسجيل الدخول أولاً',
            style: TextStyle(color: Colors.white70, fontFamily: 'Cairo')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء',
                style: TextStyle(
                    color: VirooColors.textSecondary, fontFamily: 'Cairo')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (context) => LoginBottomSheet(
                  onLoginSuccess: () {},
                ),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: VirooColors.amberPrimary),
            child: const Text('تسجيل الدخول',
                style: TextStyle(color: Colors.white, fontFamily: 'Cairo')),
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

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeContent(),
      const FavoritesScreen(),
      const CartScreen(),
      const ProfileScreen(),
    ];
  }

  void openSettings() {
    setState(() => isSettingsOpen = true);
  }

  void closeSettings() {
    setState(() => isSettingsOpen = false);
  }

  void _navigateToAddProduct() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddProductScreen()),
    );
  }

  void _checkAuthAndNavigate(BuildContext context, VoidCallback action,
      {bool requireSeller = false}) {
    final user = AuthService.currentUser;

    if (user == null) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) => LoginBottomSheet(onLoginSuccess: action),
      );
      return;
    }

    if (requireSeller) {
      _checkIsSeller(context, action);
      return;
    }

    action();
  }

  void _checkIsSeller(BuildContext context, VoidCallback action) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(AuthService.currentUser?.uid)
          .get();

      final isSeller = doc.data()?['isSeller'] ?? false;

      if (!isSeller) {
        _showConvertToSellerDialog(context);
        return;
      }

      action();
    } catch (e) {
      _showConvertToSellerDialog(context);
    }
  }

  void _showConvertToSellerDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        backgroundColor: VirooColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          '🔒 تحتاج تكون بائع',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'إضافة المنتجات متاحة فقط للبائعين. حول حسابك لبائع الآن!',
          style: TextStyle(color: Colors.white70, fontFamily: 'Cairo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'إلغاء',
              style: TextStyle(
                  color: VirooColors.textSecondary, fontFamily: 'Cairo'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ConvertToSellerScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: VirooColors.amberPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              '🔄 تحويل لبائع',
              style: TextStyle(color: Colors.white, fontFamily: 'Cairo'),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToSettings(Widget screen) {
    closeSettings();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = ref.watch(modeColorProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (_currentIndex != 0) {
          setState(() => _currentIndex = 0);
          return;
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
              style: TextStyle(color: Colors.white70, fontFamily: 'Cairo'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text(
                  'إلغاء',
                  style: TextStyle(
                      color: VirooColors.textSecondary, fontFamily: 'Cairo'),
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
                  style: TextStyle(color: Colors.white, fontFamily: 'Cairo'),
                ),
              ),
            ],
          ),
        );
        if (confirm == true) {
          if (mounted) Navigator.pop(context);
        }
      },
      child: Scaffold(
        body: SettingsRevealOverlay(
          isOpen: isSettingsOpen,
          onClose: closeSettings,
          background: _screens[_currentIndex],
          settingsPanel: _buildSettingsPanel(themeColor),
        ),
        bottomNavigationBar: FloatingNavBar(
          selectedIndex: _currentIndex,
          onTap: (index) {
            if (index == -1) {
              _checkAuthAndNavigate(context, _navigateToAddProduct,
                  requireSeller: true);
              return;
            }
            if (index == 0) {
              setState(() => _currentIndex = index);
            } else {
              _checkAuthAndNavigate(context, () {
                setState(() => _currentIndex = index);
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildSettingsPanel(Color themeColor) {
    return Container(
      decoration: BoxDecoration(
        color: VirooColors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
        border: Border.all(color: VirooColors.glassBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: VirooColors.amberPrimary.withAlpha(76),
            blurRadius: 30,
            offset: const Offset(-10, 0),
          ),
        ],
      ),
      child: SingleChildScrollView(
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
            _buildSettingsItem(
              Icons.person_outline,
              'الملف الشخصي',
              () {
                _navigateToSettings(const ProfileScreen());
              },
            ),
            _buildSettingsItem(
              Icons.notifications_outlined,
              'الإشعارات',
              () {
                _navigateToSettings(const NotificationsScreen());
              },
            ),
            _buildSettingsItem(
              Icons.lock_outline,
              'الخصوصية والأمان',
              () {
                _navigateToSettings(const PrivacySettingsScreen());
              },
            ),
            _buildSettingsItem(
              Icons.palette_rounded,
              'تخصيص المظهر',
              () {
                _navigateToSettings(const AppearanceSettingsScreen());
              },
            ),
            _buildSettingsItem(
              Icons.language,
              'اللغة',
              () {
                _navigateToSettings(const LanguageSettingsScreen());
              },
            ),
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
                      side: const BorderSide(
                          color: VirooColors.glassBorder, width: 1),
                    ),
                    title: const Text(
                      'تسجيل الخروج',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold),
                    ),
                    content: const Text(
                      'هل أنت متأكد أنك تريد تسجيل الخروج؟',
                      style:
                          TextStyle(color: Colors.white70, fontFamily: 'Cairo'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text(
                          'إلغاء',
                          style: TextStyle(
                              color: VirooColors.textSecondary,
                              fontFamily: 'Cairo'),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: VirooColors.error),
                        child: const Text(
                          'خروج',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Cairo'),
                        ),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await AuthService.signOut();
                  if (mounted) {
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

  Widget _buildSettingsItem(
    IconData icon,
    String title,
    VoidCallback? onTap, {
    bool isLogout = false,
    bool disabled = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Opacity(
        opacity: disabled ? 0.5 : 1.0,
        child: GestureDetector(
          onTap: disabled ? null : onTap,
          child: GlassContainer(
            padding: const EdgeInsets.all(16),
            borderRadius: BorderRadius.circular(12),
            child: Row(
              children: [
                Icon(
                  icon,
                  color:
                      isLogout ? VirooColors.error : VirooColors.amberPrimary,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color:
                        isLogout ? VirooColors.error : VirooColors.textPrimary,
                    fontFamily: 'Cairo',
                  ),
                ),
                const Spacer(),
                if (!disabled)
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: isLogout
                        ? VirooColors.error.withAlpha(127)
                        : VirooColors.textSecondary,
                    size: 16,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
