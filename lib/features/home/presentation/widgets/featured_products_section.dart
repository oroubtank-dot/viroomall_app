// lib/features/home/presentation/widgets/featured_products_section.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'product_card.dart';
import 'loading_grid.dart';
import 'empty_products.dart';

class FeaturedProductsSection extends StatelessWidget {
  const FeaturedProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '✨ منتجات مميزة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 12),
          Flexible(
            fit: FlexFit.loose,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .where('status', isEqualTo: 'approved')
                  .limit(6)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print('❌ Firestore Error: ${snapshot.error}');
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
                    final data = products[index].data() as Map<String, dynamic>;
                    return ProductCard(data: data);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
