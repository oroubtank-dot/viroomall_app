// lib/features/home/presentation/widgets/featured_products_section.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/product_model.dart';
import '../providers/home_provider.dart';
import 'product_card.dart';
import 'loading_grid.dart';
import 'empty_products.dart';

class FeaturedProductsSection extends ConsumerWidget {
  const FeaturedProductsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMode = ref.watch(shopModeProvider);
    final modeFilter = selectedMode.toString().split('.').last;
    final themeColor = ref.watch(modeColorProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                '✨ منتجات مميزة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: themeColor,
                  fontFamily: 'Cairo',
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: themeColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _modeLabel(modeFilter),
                  style: TextStyle(
                    color: themeColor,
                    fontSize: 11,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Flexible(
            fit: FlexFit.loose,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .where('status', isEqualTo: 'approved')
                  .where('productType', isEqualTo: modeFilter)
                  .limit(6)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Container(
                    height: 150,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline,
                            color: VirooColors.error, size: 48),
                        const SizedBox(height: 12),
                        Text(
                          'خطأ: ${snapshot.error}',
                          style: TextStyle(
                              color: VirooColors.error, fontFamily: 'Cairo'),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingGrid();
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const EmptyProducts();
                }

                final products = snapshot.data!.docs;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: products.length > 4 ? 4 : products.length,
                  itemBuilder: (context, index) {
                    final product = ProductModel.fromFirestore(products[index]);
                    return VirooProductCard(
                      product: product,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/product',
                          arguments: product.id,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _modeLabel(String mode) {
    switch (mode) {
      case 'new':
        return '🛍️ تسوق';
      case 'wholesale':
        return '🏪 جملة';
      case 'used':
        return '♻️ مستعمل';
      case 'outlet':
        return '🔥 فرز إنتاج وتصفية';
      default:
        return '🛍️ تسوق';
    }
  }
}
