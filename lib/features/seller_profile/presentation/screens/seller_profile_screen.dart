// lib/features/seller_profile/presentation/screens/seller_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../../../../core/widgets/viroo_background.dart';
import '../../../../core/models/product_model.dart';
import '../../../home/presentation/widgets/product_card.dart';

class SellerProfileScreen extends ConsumerStatefulWidget {
  final String sellerId;

  const SellerProfileScreen({super.key, required this.sellerId});

  @override
  ConsumerState<SellerProfileScreen> createState() =>
      _SellerProfileScreenState();
}

class _SellerProfileScreenState extends ConsumerState<SellerProfileScreen> {
  bool _isLoading = true;
  bool _isFollowing = false;
  int _followersCount = 0;
  Map<String, dynamic>? _sellerData;
  List<ProductModel> _products = [];

  @override
  void initState() {
    super.initState();
    _loadSellerData();
  }

  Future<void> _loadSellerData() async {
    try {
      final sellerDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.sellerId)
          .get();

      if (sellerDoc.exists) {
        _sellerData = sellerDoc.data()!;
        _followersCount = (_sellerData!['followers'] as List?)?.length ?? 0;
      }

      final productsSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('sellerId', isEqualTo: widget.sellerId)
          .where('status', isEqualTo: 'approved')
          .orderBy('createdAt', descending: true)
          .limit(10)
          .get();

      _products = productsSnapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      debugPrint('خطأ: $e');
    }

    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _toggleFollow() async {
    HapticFeedback.mediumImpact();
    setState(() {
      _isFollowing = !_isFollowing;
      _followersCount += _isFollowing ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: VirooColors.background,
        body: Center(
            child: CircularProgressIndicator(color: VirooColors.amberPrimary)),
      );
    }

    final storeName = _sellerData?['storeName'] ?? 'متجر';
    final storeImage = _sellerData?['storeImage'] ?? '';
    final location = _sellerData?['location'] ?? 'مصر';
    final joinedDate = _sellerData?['createdAt'] != null
        ? (_sellerData!['createdAt'] as Timestamp).toDate()
        : DateTime.now();
    final about = _sellerData?['about'] ?? '';
    final phone = _sellerData?['phone'] ?? '';
    final whatsapp = _sellerData?['whatsapp'] ?? phone;
    final rating = (_sellerData?['rating'] ?? 4.5).toDouble();
    final ratingCount = _sellerData?['ratingCount'] ?? 0;
    final totalViews = _sellerData?['totalViews'] ?? 0;

    return Scaffold(
      backgroundColor: VirooColors.background,
      body: VirooBackground(
        showOrbs: true,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                _buildHeader(),
                _buildStoreInfo(
                  storeName: storeName,
                  storeImage: storeImage,
                  location: location,
                  rating: rating,
                  ratingCount: ratingCount,
                  joinedDate: joinedDate,
                ),
                const SizedBox(height: 16),
                _buildStatsSection(totalViews: totalViews),
                const SizedBox(height: 16),
                _buildContactButtons(phone: phone, whatsapp: whatsapp),
                if (about.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _buildAboutSection(about),
                ],
                const SizedBox(height: 20),
                _buildProductsSection(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: GlassContainer(
              padding: const EdgeInsets.all(10),
              borderRadius: BorderRadius.circular(12),
              child: const Icon(Icons.arrow_back_rounded,
                  color: Colors.white, size: 22),
            ),
          ),
          const Spacer(),
          // 👤 زر المتابعة
          GestureDetector(
            onTap: _toggleFollow,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: _isFollowing
                    ? VirooColors.success.withValues(alpha: 0.2)
                    : VirooColors.amberPrimary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isFollowing
                      ? VirooColors.success.withValues(alpha: 0.5)
                      : VirooColors.amberPrimary.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isFollowing
                        ? Icons.check_circle_rounded
                        : Icons.add_circle_outline,
                    color: _isFollowing
                        ? VirooColors.success
                        : VirooColors.amberPrimary,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _isFollowing ? 'متابَع' : 'متابعة',
                    style: TextStyle(
                      color: _isFollowing
                          ? VirooColors.success
                          : VirooColors.amberPrimary,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreInfo({
    required String storeName,
    required String storeImage,
    required String location,
    required double rating,
    required int ratingCount,
    required DateTime joinedDate,
  }) {
    return Column(
      children: [
        const SizedBox(height: 20),
        // صورة الغلاف
        Container(
          height: 120,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                VirooColors.amberPrimary.withValues(alpha: 0.3),
                VirooColors.purpleGlow.withValues(alpha: 0.3),
              ],
            ),
          ),
          child: storeImage.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(storeImage, fit: BoxFit.cover),
                )
              : const Center(
                  child: Icon(Icons.store_rounded,
                      color: VirooColors.amberPrimary, size: 50),
                ),
        ),
        const SizedBox(height: 16),
        // اسم المتجر
        Text(
          storeName,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 4),
        // التقييم
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(5, (index) {
              return Icon(
                index < rating.floor()
                    ? Icons.star_rounded
                    : Icons.star_outline_rounded,
                color: VirooColors.warning,
                size: 18,
              );
            }),
            const SizedBox(width: 8),
            Text(
              '$rating ($ratingCount تقييم)',
              style: const TextStyle(
                color: VirooColors.textSecondary,
                fontSize: 13,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        // الموقع
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on_outlined,
                color: VirooColors.textSecondary, size: 14),
            const SizedBox(width: 4),
            Text(
              location,
              style: const TextStyle(
                color: VirooColors.textSecondary,
                fontSize: 13,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        // تاريخ الانضمام
        Text(
          'منضم منذ ${joinedDate.year}/${joinedDate.month}',
          style: const TextStyle(
            color: VirooColors.textTertiary,
            fontSize: 12,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection({required int totalViews}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildStatCard(
            icon: Icons.inventory_2_outlined,
            value: '${_products.length}',
            label: 'منتجات',
            color: VirooColors.amberPrimary,
          ),
          const SizedBox(width: 10),
          _buildStatCard(
            icon: Icons.visibility_outlined,
            value: _formatCount(totalViews),
            label: 'مشاهدة',
            color: VirooColors.info,
          ),
          const SizedBox(width: 10),
          _buildStatCard(
            icon: Icons.favorite_border_rounded,
            value: _formatCount(_followersCount),
            label: 'متابعين',
            color: VirooColors.error,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(vertical: 12),
        borderRadius: BorderRadius.circular(14),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
                fontFamily: 'Orbitron',
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: VirooColors.textSecondary,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactButtons({
    required String phone,
    required String whatsapp,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildContactButton(
              icon: Icons.chat_rounded,
              label: 'واتساب',
              color: const Color(0xFF25D366),
              onTap: () => _launchUrl('https://wa.me/$whatsapp'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildContactButton(
              icon: Icons.phone_rounded,
              label: 'اتصال',
              color: VirooColors.success,
              onTap: () => _launchUrl('tel:$phone'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(String about) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline_rounded,
                  color: VirooColors.amberPrimary, size: 18),
              SizedBox(width: 8),
              Text(
                '✨ عن المتجر',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: VirooColors.textPrimary,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GlassContainer(
            padding: const EdgeInsets.all(16),
            borderRadius: BorderRadius.circular(14),
            child: Text(
              about,
              style: const TextStyle(
                color: VirooColors.textSecondary,
                fontSize: 14,
                height: 1.6,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsSection() {
    if (_products.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(30),
        child: Text(
          'لا توجد منتجات حالياً',
          style: TextStyle(
            color: VirooColors.textSecondary,
            fontSize: 14,
            fontFamily: 'Cairo',
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shopping_bag_outlined,
                  color: VirooColors.amberPrimary, size: 18),
              const SizedBox(width: 8),
              const Text(
                '📦 منتجات المتجر',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: VirooColors.textPrimary,
                  fontFamily: 'Cairo',
                ),
              ),
              const Spacer(),
              Text(
                '${_products.length} منتجات',
                style: const TextStyle(
                  color: VirooColors.textSecondary,
                  fontSize: 12,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.60,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _products.length,
            itemBuilder: (context, index) {
              final product = _products[index];
              return VirooProductCard(
                product: product,
                onTap: () {
                  Navigator.pushNamed(context, '/product',
                      arguments: product.id);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}
