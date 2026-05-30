// lib/features/profile/presentation/screens/public_profile_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../../../../core/widgets/viroo_background.dart';
import '../../../product/presentation/widgets/product_card.dart';
import '../../../product/data/models/product_model.dart';
import '../widgets/public_profile_view.dart';

class PublicProfileScreen extends ConsumerStatefulWidget {
  final String userId;

  const PublicProfileScreen({super.key, required this.userId});

  @override
  ConsumerState<PublicProfileScreen> createState() => _PublicProfileScreenState();
}

class _PublicProfileScreenState extends ConsumerState<PublicProfileScreen> {
  Map<String, dynamic>? _userData;
  List<ProductModel> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();
      if (userDoc.exists) {
        _userData = userDoc.data();
      }

      final productsSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('sellerId', isEqualTo: widget.userId)
          .where('status', isEqualTo: 'approved')
          .orderBy('createdAt', descending: true)
          .limit(20)
          .get();

      _products = productsSnapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList();
    } catch (e) {
      // Error loading profile
    }

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = VirooColors.amberPrimary;

    return Scaffold(
      backgroundColor: VirooColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          _userData?['name'] ?? 'الملف الشخصي',
          style: const TextStyle(color: Colors.white, fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: VirooBackground(
        showOrbs: true,
        themeColor: themeColor,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: VirooColors.amberPrimary))
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    PublicProfileView(
                      name: _userData?['name'] ?? 'مستخدم VirooMall',
                      phone: _userData?['phone'] ?? '',
                      isVerified: _userData?['isVerified'] ?? false,
                      productsCount: _products.length,
                      userId: widget.userId,
                    ),
                    const SizedBox(height: 24),
                    const Text('📦 المنتجات',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                    const SizedBox(height: 12),
                    if (_products.isEmpty)
                      const EmptyState(icon: Icons.inventory_2_rounded, title: 'لا توجد منتجات', subtitle: 'هذا البائع لم يضف أي منتجات بعد')
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.72,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: _products.length,
                        itemBuilder: (context, index) {
                          final product = _products[index];
                          return ProductCard(
                            product: product,
                            onTap: () {
                              Navigator.pushNamed(context, '/product', arguments: product.id);
                            },
                          );
                        },
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}