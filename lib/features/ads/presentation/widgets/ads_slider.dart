// lib/features/ads/presentation/widgets/ads_slider.dart
import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/cart_notification.dart';
import '../../../../core/models/product_model.dart';
import '../../../home/presentation/providers/home_provider.dart';

class VirooAdsSlider extends ConsumerStatefulWidget {
  const VirooAdsSlider({super.key});

  @override
  ConsumerState<VirooAdsSlider> createState() => _VirooAdsSliderState();
}

class _VirooAdsSliderState extends ConsumerState<VirooAdsSlider> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;
  List<Map<String, dynamic>> _adsData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _loadAds();
  }

  Future<void> _loadAds() async {
    try {
      final mode = ref.read(shopModeProvider);
      final modeStr = mode.toString().split('.').last;

      final snapshot = await FirebaseFirestore.instance
          .collection('ad_subscriptions')
          .where('mode', isEqualTo: modeStr)
          .where('status', isEqualTo: 'active')
          .orderBy('pageNumber', descending: false)
          .limit(5)
          .get();

      if (snapshot.docs.isNotEmpty) {
        _adsData = snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'title': data['advertiserName'] ?? 'إعلان ممول',
            'subtitle': 'الصفحة ${data['pageNumber'] ?? 1}',
            'advertiser': data['advertiserName'] ?? 'معلن',
            'productId': data['productId'] ?? '',
            'price': '${data['pricePaid'] ?? 0} ج',
            'image': data['image'] ?? '',
          };
        }).toList();
      }
    } catch (e) {
      // مفيش بيانات في Firestore
    }

    if (mounted) {
      setState(() => _isLoading = false);
      if (_adsData.isNotEmpty) {
        _startAutoScroll();
      }
    }
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted || _adsData.isEmpty) return;
      if (_currentPage < _adsData.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutSine,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = ref.watch(modeColorProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: [
              Icon(Icons.campaign_rounded, color: themeColor, size: 20),
              const SizedBox(width: 8),
              Text(
                'إعلانات ممولة',
                style: TextStyle(
                  color: themeColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
              const Spacer(),
              if (_adsData.isNotEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(_adsData.length, (index) {
                    return Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? themeColor
                            : themeColor.withAlpha(76),
                      ),
                    );
                  }),
                ),
            ],
          ),
        ),
        SizedBox(
          height: 220,
          child: _adsData.isEmpty
              ? _buildEmptyState(themeColor)
              : PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemCount: _adsData.length,
                  itemBuilder: (context, index) {
                    return _buildAdCard(_adsData[index], themeColor);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(Color themeColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Stack(
        children: [
          Positioned(
            bottom: 15,
            left: 25,
            right: 25,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: themeColor.withAlpha(76),
                    blurRadius: 25,
                    spreadRadius: 3,
                  ),
                ],
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: VirooColors.glassDark,
                  borderRadius: BorderRadius.circular(20),
                  border:
                      Border.all(color: themeColor.withAlpha(76), width: 1.5),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      themeColor.withAlpha(20),
                      Colors.white.withAlpha(5),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.campaign_rounded,
                          color: themeColor.withAlpha(102), size: 48),
                      const SizedBox(height: 12),
                      Text('ضيف إعلانك هنا',
                          style: TextStyle(
                              color: themeColor.withAlpha(178),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo')),
                      const SizedBox(height: 4),
                      Text('بيع اكتر 💰',
                          style: TextStyle(
                              color: themeColor.withAlpha(127),
                              fontSize: 14,
                              fontFamily: 'Cairo')),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          Navigator.pushNamed(context, '/ad-marketplace');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: themeColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                  color: themeColor.withAlpha(127),
                                  blurRadius: 12,
                                  spreadRadius: 1)
                            ],
                          ),
                          child: const Text('📢 أعلن الآن',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Cairo',
                                  fontSize: 14)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdCard(Map<String, dynamic> ad, Color themeColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Stack(
        children: [
          Positioned(
            bottom: 15,
            left: 25,
            right: 25,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: themeColor.withAlpha(102),
                      blurRadius: 25,
                      spreadRadius: 3)
                ],
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: VirooColors.glassDark,
                  borderRadius: BorderRadius.circular(20),
                  border:
                      Border.all(color: VirooColors.glassBorder, width: 1.5),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      themeColor.withAlpha(38),
                      Colors.white.withAlpha(5),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: themeColor.withAlpha(25),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              color: themeColor.withAlpha(76), width: 1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: ad['image'] != null && ad['image']!.isNotEmpty
                              ? Image.memory(base64Decode(ad['image']!),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.shopping_bag_rounded,
                                          color: themeColor, size: 40))
                              : Icon(Icons.shopping_bag_rounded,
                                  color: themeColor, size: 40),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                  color: themeColor.withAlpha(204),
                                  borderRadius: BorderRadius.circular(6)),
                              child: Text(ad['advertiser'] ?? 'معلن',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Cairo')),
                            ),
                            const SizedBox(height: 10),
                            Text(ad['title'] ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo')),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(ad['price'] ?? '',
                                    style: TextStyle(
                                        color: themeColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Orbitron')),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    // إنشاء ProductModel مؤقت للإشعار
                                    final tempProduct = ProductModel(
                                      id: ad['productId'] ??
                                          'ad_${DateTime.now().millisecondsSinceEpoch}',
                                      sellerId: 'advertiser',
                                      title: ad['title'] ?? 'منتج',
                                      description: '',
                                      price: double.tryParse(ad['price']
                                                  ?.replaceAll(' ج', '') ??
                                              '0') ??
                                          0,
                                      productType: 'new',
                                      categoryId: 'general',
                                      images: ad['image']?.isNotEmpty == true
                                          ? [ad['image']!]
                                          : [],
                                      condition: 'new',
                                      location: '',
                                      createdAt: DateTime.now(),
                                    );
                                    CartNotification.show(context, tempProduct);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: themeColor.withAlpha(51),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: themeColor.withAlpha(102),
                                          width: 1),
                                    ),
                                    child: Icon(Icons.add_shopping_cart_rounded,
                                        color: themeColor, size: 18),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          if (ad['productId'] != null &&
                              ad['productId']!.isNotEmpty) {
                            Navigator.pushNamed(context, '/product',
                                arguments: ad['productId']);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: themeColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                  color: themeColor.withAlpha(127),
                                  blurRadius: 12,
                                  spreadRadius: 1)
                            ],
                          ),
                          child: const Icon(Icons.arrow_forward_rounded,
                              color: Colors.white, size: 24),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
