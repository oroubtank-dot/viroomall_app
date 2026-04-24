// lib/features/product/presentation/screens/product_details_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../../../../core/widgets/viroo_background.dart';
import '../../../../core/models/product_model.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../home/presentation/providers/home_provider.dart';
import '../widgets/product_details/product_image_gallery.dart';
import '../widgets/product_details/product_video_section.dart';
import '../widgets/product_details/product_info_section.dart';
import '../widgets/product_details/seller_contact_section.dart';
import '../widgets/product_details/wholesale_section.dart';
import '../widgets/product_details/used_condition_section.dart';
import '../widgets/product_details/outlet_section.dart';
import '../../../../core/widgets/cart_notification.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  ProductModel? _product;
  bool _isLoading = true;
  int _wholesaleQuantity = 10;
  double _negotiatedPrice = 0;
  bool _isNegotiating = false;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .get();

      if (doc.exists && mounted) {
        setState(() {
          _product = ProductModel.fromFirestore(doc);
          _negotiatedPrice = _product!.price;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = ref.watch(modeColorProvider);

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: VirooColors.background,
        body: Center(
            child: CircularProgressIndicator(color: VirooColors.amberPrimary)),
      );
    }

    if (_product == null) {
      return Scaffold(
        backgroundColor: VirooColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  color: VirooColors.error, size: 60),
              const SizedBox(height: 16),
              const Text('❌ المنتج غير موجود',
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'Cairo', fontSize: 18)),
              const SizedBox(height: 16),
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('رجوع',
                      style: TextStyle(fontFamily: 'Cairo'))),
            ],
          ),
        ),
      );
    }

    final product = _product!;
    final isInCart = ref.watch(isInCartProvider(product.id));
    final cartNotifier = ref.read(cartProvider.notifier);

    return Scaffold(
      backgroundColor: VirooColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          product.title,
          style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Cairo',
              fontSize: 16,
              fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: Icon(
              isInCart
                  ? Icons.shopping_cart_rounded
                  : Icons.shopping_cart_outlined,
              color: isInCart ? VirooColors.amberPrimary : Colors.white,
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              if (isInCart) {
                cartNotifier.removeFromCart(product.id);
              } else {
                cartNotifier.addToCart(product);
                CartNotification.show(context, product);
                return;
              }
            },
          ),
        ],
      ),
      body: VirooBackground(
        showOrbs: true,
        themeColor: themeColor,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 📱 معرض الصور
              ProductImageGallery(images: product.images),
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 📝 معلومات المنتج
                    ProductInfoSection(product: product),
                    const SizedBox(height: 16),

                    // 🎬 فيديو المنتج
                    ProductVideoSection(videoBase64: product.videoUrl),
                    const SizedBox(height: 16),

                    // 🏪 قسم الجملة
                    if (product.productType == 'wholesale') ...[
                      WholesaleSection(
                        price: product.price,
                        minQuantity: 10,
                      ),
                      const SizedBox(height: 10),
                      // عداد كمية الجملة
                      GlassContainer(
                        padding: const EdgeInsets.all(16),
                        borderRadius: BorderRadius.circular(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('📦 اختر الكمية:',
                                style: TextStyle(
                                    color: VirooColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    fontFamily: 'Cairo')),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _qtyButton(Icons.remove, () {
                                  if (_wholesaleQuantity > 10)
                                    setState(() => _wholesaleQuantity -= 5);
                                }),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: VirooColors.wholesale.withAlpha(38),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: VirooColors.wholesale
                                            .withAlpha(76)),
                                  ),
                                  child: Text(
                                    '$_wholesaleQuantity قطعة',
                                    style: const TextStyle(
                                        color: VirooColors.wholesale,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        fontFamily: 'Orbitron'),
                                  ),
                                ),
                                _qtyButton(Icons.add, () {
                                  setState(() => _wholesaleQuantity += 5);
                                }),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: Text(
                                'الإجمالي: ${(_wholesaleQuantity * product.price * (0.9 - (_wholesaleQuantity > 50 ? 0.1 : 0) - (_wholesaleQuantity > 100 ? 0.1 : 0))).toStringAsFixed(0)} ج.م',
                                style: const TextStyle(
                                    color: VirooColors.wholesale,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    fontFamily: 'Orbitron'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // ♻️ قسم المستعمل
                    if (product.productType == 'used') ...[
                      UsedConditionSection(
                        condition: product.condition,
                        defects: product.defects,
                        negotiable: true,
                      ),
                      const SizedBox(height: 10),
                      // قسم التفاوض
                      if (_isNegotiating)
                        GlassContainer(
                          padding: const EdgeInsets.all(16),
                          borderRadius: BorderRadius.circular(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('💰 تفاوض على السعر:',
                                  style: TextStyle(
                                      color: VirooColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      fontFamily: 'Cairo')),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _qtyButton(Icons.remove, () {
                                    if (_negotiatedPrice > product.price * 0.5)
                                      setState(() => _negotiatedPrice -= 50);
                                  }),
                                  const SizedBox(width: 16),
                                  Text(
                                    '${_negotiatedPrice.toStringAsFixed(0)} ج',
                                    style: const TextStyle(
                                        color: VirooColors.warning,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                        fontFamily: 'Orbitron'),
                                  ),
                                  const SizedBox(width: 16),
                                  _qtyButton(Icons.add, () {
                                    if (_negotiatedPrice < product.price)
                                      setState(() => _negotiatedPrice += 50);
                                  }),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'السعر الأصلي: ${product.price.toStringAsFixed(0)} ج',
                                style: const TextStyle(
                                    color: VirooColors.textSecondary,
                                    fontSize: 12,
                                    fontFamily: 'Cairo'),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      else
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () =>
                                setState(() => _isNegotiating = true),
                            icon: const Icon(Icons.handshake_rounded,
                                color: VirooColors.warning),
                            label: const Text('💰 تفاوض على السعر',
                                style: TextStyle(
                                    color: VirooColors.warning,
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.bold)),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(
                                  color: VirooColors.warning, width: 1.5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                    ],

                    // 🔥 قسم الفرز
                    if (product.productType == 'outlet') ...[
                      OutletSection(
                        originalPrice:
                            product.originalPrice ?? product.price * 1.5,
                        outletPrice: product.price,
                        reason: 'تصفية مخزون',
                        remainingQuantity: 15,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // 👤 معلومات البائع والتواصل
                    SellerContactSection(
                      sellerName: 'بائع VirooMall',
                      sellerPhone: '+201001234567',
                      productTitle: product.title,
                      location: product.location,
                    ),
                    const SizedBox(height: 20),

                    // 🛒 زرار إضافة للسلة
                    GlowingButton(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        if (isInCart) {
                          cartNotifier.removeFromCart(product.id);
                        } else {
                          cartNotifier.addToCart(product);
                        }
                      },
                      text: isInCart ? '🗑️ حذف من السلة' : '🛒 أضف للسلة',
                      backgroundColor: isInCart
                          ? VirooColors.error
                          : VirooColors.amberPrimary,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: VirooColors.glassDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: VirooColors.glassBorder),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
