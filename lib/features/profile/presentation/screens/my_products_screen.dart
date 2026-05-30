// lib/features/profile/presentation/screens/my_products_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/viroo_background.dart';
import '../models/seller_product.dart';
import '../widgets/filter_sort_bar.dart';
import '../widgets/expiring_alert_banner.dart';
import '../widgets/product_stats_card.dart';
import '../widgets/product_details_sheet.dart';
import '../widgets/product_search_delegate.dart';

class MyProductsScreen extends ConsumerStatefulWidget {
  const MyProductsScreen({super.key});

  @override
  ConsumerState<MyProductsScreen> createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends ConsumerState<MyProductsScreen> {
  String _sortBy = 'default';
  String _filterStatus = 'all';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<SellerProduct> _getFilteredAndSortedProducts() {
    var products = SellerProduct.mockProducts();

    if (_searchController.text.isNotEmpty) {
      products = products
          .where((p) => p.title
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    }

    if (_filterStatus != 'all') {
      products = products.where((p) => p.status == _filterStatus).toList();
    }

    switch (_sortBy) {
      case 'views':
        products.sort((a, b) => b.views.compareTo(a.views));
        break;
      case 'clicks':
        products.sort((a, b) => b.clicks.compareTo(a.clicks));
        break;
      case 'sales':
        products.sort((a, b) => b.sales.compareTo(a.sales));
        break;
      default:
        break;
    }

    return products;
  }

  @override
  Widget build(BuildContext context) {
    const themeColor = VirooColors.primary;
    final products = _getFilteredAndSortedProducts();
    final expiringCount = SellerProduct.mockProducts()
        .where((p) => p.status == 'expiring')
        .length;
    final expiredCount =
        SellerProduct.mockProducts().where((p) => p.status == 'expired').length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('منتجاتي',
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.share_rounded), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () => showSearch(
                context: context, delegate: ProductSearchDelegate(products)),
          ),
        ],
      ),
      body: VirooBackground(
        showOrbs: true,
        themeColor: themeColor,
        child: Column(
          children: [
            FilterSortBar(
              filterStatus: _filterStatus,
              sortBy: _sortBy,
              onFilterChanged: (val) => setState(() => _filterStatus = val),
              onSortChanged: (val) => setState(() => _sortBy = val),
              themeColor: themeColor,
            ),
            ExpiringAlertBanner(
              expiringCount: expiringCount,
              expiredCount: expiredCount,
              onRenewAll: () {},
              themeColor: themeColor,
            ),
            Expanded(
              child: products.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inventory_2_rounded,
                              size: 80, color: VirooColors.textSecondary),
                          SizedBox(height: 16),
                          Text('لا توجد منتجات',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'Cairo')),
                          SizedBox(height: 8),
                          Text('اضغط على + لإضافة منتج جديد',
                              style: TextStyle(
                                  color: VirooColors.textSecondary,
                                  fontFamily: 'Cairo')),
                        ],
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductStatsCard(
                          product: product,
                          themeColor: themeColor,
                          onTap: () => showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (context) =>
                                ProductDetailsSheet(product: product),
                          ),
                          onShare: () {},
                          onEdit: () {},
                          onDelete: () {},
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add-product'),
        backgroundColor: themeColor,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }
}
