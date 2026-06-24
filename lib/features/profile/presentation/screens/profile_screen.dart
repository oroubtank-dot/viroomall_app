// lib/features/profile/presentation/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/viroo_background.dart';
import '../../../../core/services/auth_service.dart';
import '../providers/profile_provider.dart';
import '../../domain/models/user_model.dart';
import '../../domain/models/seller_stats.dart';
import '../../domain/models/buyer_stats.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_share_button.dart';
import '../widgets/seller_stats_widget.dart';
import '../widgets/buyer_stats_widget.dart';
import '../widgets/profile_menu_section.dart';
import '../../../home/presentation/widgets/product_card.dart';
import '../../../../core/models/product_model.dart';
import 'seller_dashboard_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String? userId;

  const ProfileScreen({super.key, this.userId});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String? get _userId => widget.userId ?? _currentUserId;
  String? _currentUserId;
  bool _showProducts = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = AuthService.currentUser;

    if (user == null) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
      return;
    }

    _currentUserId = user.uid;
    if (_userId != null) {
      await ref.read(profileNotifierProvider.notifier).loadUser(_userId!);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(profileNotifierProvider);
    final sellerStats = ref.watch(sellerStatsProvider);
    final buyerStats = ref.watch(buyerStatsProvider);

    final sellerProducts = _userId != null && (user?.isSeller ?? false)
        ? ref.watch(sellerProductsProvider(_userId!))
        : null;

    const themeColor = VirooColors.primary;

    if (user == null) {
      return Scaffold(
        body: VirooBackground(
          showOrbs: true,
          themeColor: themeColor,
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Scaffold(
      backgroundColor: VirooColors.background,
      appBar: AppBar(
        title: Text(
          user.isSeller && user.storeName.isNotEmpty
              ? user.storeName
              : user.name,
          style:
              const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_userId == _currentUserId) ...[
            IconButton(
              icon: const Icon(Icons.settings_outlined, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ],
      ),
      body: VirooBackground(
        showOrbs: true,
        themeColor: themeColor,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // رأس البروفايل
              ProfileHeader(
                user: user,
                themeColor: themeColor,
              ),
              const SizedBox(height: 24),

              // زر مشاركة المتجر (للبائع فقط)
              if (user.isSeller) ...[
                ProfileShareButton(
                  themeColor: themeColor,
                  onTap: () {},
                ),
                const SizedBox(height: 24),
              ],

              // إحصائيات البائع أو المشتري
              if (user.isSeller && sellerStats != null)
                SellerStatsWidget(stats: sellerStats, themeColor: themeColor)
              else if (user.isBuyer && buyerStats != null)
                BuyerStatsWidget(stats: buyerStats, themeColor: themeColor),
              const SizedBox(height: 24),

              // ✅ لوحة تحكم البائع (كارت مميز)
              if (user.isSeller) ...[
                _buildDashboardCard(themeColor),
                const SizedBox(height: 16),
              ],

              // قائمة المنتجات (للبائع فقط)
              if (user.isSeller) ...[
                _buildProductsToggle(themeColor),
                const SizedBox(height: 16),
                if (_showProducts)
                  _buildProductsSection(sellerProducts, themeColor),
                const SizedBox(height: 16),
              ],

              // قائمة الإعدادات
              ProfileMenuSection(
                user: user,
                themeColor: themeColor,
                parentContext: context,
                sellerStats: sellerStats,
                buyerStats: buyerStats,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =============================================
  // 🆕 كارت لوحة تحكم البائع
  // =============================================
  Widget _buildDashboardCard(Color themeColor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SellerDashboardScreen(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              VirooColors.amberPrimary.withAlpha(200),
              VirooColors.amberDark.withAlpha(200),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: VirooColors.amberPrimary.withAlpha(76),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(51),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.dashboard_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📊 لوحة تحكم البائع',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'شوف إحصائيات منتجاتك ومبيعاتك',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withAlpha(204),
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsToggle(Color themeColor) {
    return GestureDetector(
      onTap: () => setState(() => _showProducts = !_showProducts),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: VirooColors.glassDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: VirooColors.glassBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.inventory_2_rounded, color: themeColor, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'منتجاتي',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
            Icon(
              _showProducts
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              color: themeColor,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsSection(
    AsyncValue<List<ProductModel>>? productsAsync,
    Color themeColor,
  ) {
    if (productsAsync == null) return const SizedBox();

    return productsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Text(
            'خطأ في تحميل المنتجات',
            style:
                const TextStyle(color: VirooColors.error, fontFamily: 'Cairo'),
          ),
        ),
      ),
      data: (products) {
        if (products.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(32),
            child: Center(
              child: Text(
                'لا توجد منتجات حتى الآن',
                style: TextStyle(
                    color: VirooColors.textSecondary, fontFamily: 'Cairo'),
              ),
            ),
          );
        }
        return GridView.builder(
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
            return VirooProductCard(
              product: product,
              onTap: () {
                Navigator.pushNamed(context, '/product', arguments: product.id);
              },
            );
          },
        );
      },
    );
  }
}
