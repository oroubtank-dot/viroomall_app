// lib/features/profile/presentation/screens/my_products_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../../../../core/widgets/viroo_background.dart';
import '../../../../core/models/product_model.dart';
import '../../../../core/services/auth_service.dart';
import '../../../home/presentation/widgets/product_card.dart';

class MyProductsScreen extends ConsumerWidget {
  const MyProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = AuthService.currentUser;
    final themeColor = VirooColors.amberPrimary;

    return Scaffold(
      backgroundColor: VirooColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('📦 منتجاتي',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: VirooBackground(
        showOrbs: true,
        themeColor: themeColor,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('products')
              .where('sellerId', isEqualTo: user?.uid ?? 'admin')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                      color: VirooColors.amberPrimary));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const EmptyState(
                icon: Icons.inventory_2_rounded,
                title: 'لا توجد منتجات',
                subtitle: 'لم تقم بإضافة أي منتجات بعد',
              );
            }

            final products = snapshot.data!.docs;
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = ProductModel.fromFirestore(products[index]);
                return VirooProductCard(
                  product: product,
                  onTap: () {
                    Navigator.pushNamed(context, '/product',
                        arguments: product.id);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
