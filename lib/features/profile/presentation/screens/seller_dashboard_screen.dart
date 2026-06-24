// lib/features/profile/presentation/screens/seller_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/viroo_background.dart';
import '../providers/dashboard/seller_dashboard_provider.dart';
import '../widgets/dashboard/dashboard_stat_card.dart';
import '../widgets/dashboard/dashboard_chart.dart';
import '../widgets/dashboard/dashboard_top_products.dart';
import '../widgets/dashboard/dashboard_recent_orders.dart';

class SellerDashboardScreen extends ConsumerStatefulWidget {
  const SellerDashboardScreen({super.key});

  @override
  ConsumerState<SellerDashboardScreen> createState() =>
      _SellerDashboardScreenState();
}

class _SellerDashboardScreenState extends ConsumerState<SellerDashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(sellerDashboardProvider.notifier).loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardAsync = ref.watch(sellerDashboardProvider);

    return Scaffold(
      backgroundColor: VirooColors.background,
      appBar: AppBar(
        title: const Text(
          '📊 لوحة تحكم البائع',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: () {
              ref.read(sellerDashboardProvider.notifier).refresh();
            },
          ),
        ],
      ),
      body: VirooBackground(
        showOrbs: true,
        themeColor: VirooColors.amberPrimary,
        child: dashboardAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: VirooColors.amberPrimary),
          ),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline,
                    color: VirooColors.error, size: 60),
                const SizedBox(height: 16),
                Text(
                  'حدث خطأ في تحميل البيانات',
                  style: const TextStyle(
                    color: VirooColors.error,
                    fontFamily: 'Cairo',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.read(sellerDashboardProvider.notifier).refresh();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: VirooColors.amberPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'إعادة المحاولة',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          data: (stats) {
            // ✅ لو مفيش بيانات (منتجات أو طلبات)
            if (stats.totalProducts == 0 && stats.recentOrders.isEmpty) {
              return _buildEmptyState();
            }

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ✅ الكروت الأربعة
                  Row(
                    children: [
                      Expanded(
                        child: DashboardStatCard(
                          title: 'المنتجات',
                          value: stats.totalProducts.toString(),
                          icon: Icons.inventory_2_rounded,
                          color: VirooColors.info,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DashboardStatCard(
                          title: 'المشاهدات',
                          value: stats.totalViews.toString(),
                          icon: Icons.visibility_rounded,
                          color: VirooColors.warning,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: DashboardStatCard(
                          title: 'المبيعات',
                          value: stats.totalSales.toString(),
                          icon: Icons.shopping_bag_rounded,
                          color: VirooColors.success,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DashboardStatCard(
                          title: 'الأرباح',
                          value: '${stats.totalRevenue.toStringAsFixed(0)} ج.م',
                          icon: Icons.payments_rounded,
                          color: VirooColors.amberPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ✅ الطلبات المعلقة
                  if (stats.pendingOrders > 0) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: VirooColors.warning.withAlpha(25),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: VirooColors.warning.withAlpha(76)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.hourglass_empty_rounded,
                              color: VirooColors.warning),
                          const SizedBox(width: 8),
                          Text(
                            'لديك ${stats.pendingOrders} طلبات معلقة!',
                            style: const TextStyle(
                              color: VirooColors.warning,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/seller-orders');
                            },
                            child: const Text('مراجعة'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // ✅ الرسم البياني
                  DashboardChart(salesByDay: stats.salesByDay),
                  const SizedBox(height: 16),

                  // ✅ آخر الطلبات
                  DashboardRecentOrders(orders: stats.recentOrders),
                  const SizedBox(height: 16),

                  // ✅ المنتجات الأكثر مشاهدة
                  DashboardTopProducts(products: stats.topProducts),
                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // =============================================
  // ✅ حالة عدم وجود بيانات
  // =============================================
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.inbox_rounded,
            color: VirooColors.textSecondary,
            size: 80,
          ),
          const SizedBox(height: 16),
          const Text(
            'لا توجد بيانات حتى الآن',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'ابدأ بإضافة منتجك الأول',
            style: TextStyle(
              color: VirooColors.textSecondary,
              fontSize: 14,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/add-product');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: VirooColors.amberPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              '➕ إضافة منتج',
              style: TextStyle(color: Colors.white, fontFamily: 'Cairo'),
            ),
          ),
        ],
      ),
    );
  }
}
