// lib/features/profile/presentation/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/viroo_background.dart';
import '../../../../core/repositories/product_repository.dart';
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

class ProfileScreen extends ConsumerStatefulWidget {
  final String? userId; // لو null يبقى البروفايل بتاع المستخدم الحالي

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
    // هتجيبي الـ user id من AuthService بعدين
    // مؤقتاً: استخدم mock
    _currentUserId = 'seller_001';
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

    // منتجات البائع
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
          user.isSeller ? 'متجر ${user.name}' : user.name,
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
                  onTap: () {
                    // مشاركة المتجر
                  },
                ),
                const SizedBox(height: 24),
              ],

              // إحصائيات البائع أو المشتري
              if (user.isSeller && sellerStats != null)
                SellerStatsWidget(stats: sellerStats, themeColor: themeColor)
              else if (user.isBuyer && buyerStats != null)
                BuyerStatsWidget(stats: buyerStats, themeColor: themeColor),
              const SizedBox(height: 24),

              // قائمة المنتجات (للبائع فقط)
              if (user.isSeller) ...[
                _buildProductsToggle(themeColor),
                const SizedBox(height: 16),
                if (_showProducts)
                  _buildProductsSection(sellerProducts, themeColor),
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
                Text(
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
