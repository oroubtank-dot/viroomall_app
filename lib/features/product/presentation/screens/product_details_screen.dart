// lib/features/product/presentation/screens/product_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../../../../core/widgets/viroo_background.dart';
import '../../../../core/models/product_model.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../widgets/product_image_section.dart';
import '../widgets/product_info_section.dart';
import '../widgets/seller_info_card.dart';
import '../widgets/product_description_section.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _launchWhatsApp() async {
    final phoneNumber = "+201001234567";
    final productName = widget.product.title;
    final message =
        "أهلاً، أنا مهتم بشراء *$productName* من تطبيق VirooMall. هل لا يزال متوفراً؟";
    final url =
        "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}";

    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("عفواً، لا يمكن فتح واتساب حالياً",
                style: TextStyle(fontFamily: 'Cairo')),
            backgroundColor: VirooColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final modeColor = product.modeColor;

    return Scaffold(
      body: VirooBackground(
        showOrbs: true,
        themeColor: modeColor,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductImageSection(
                    product: product,
                    onBackPressed: () => Navigator.pop(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProductInfoSection(product: product),
                        const SizedBox(height: 24),
                        SellerInfoCard(
                          product: product,
                          onContactPressed: _launchWhatsApp,
                        ),
                        const SizedBox(height: 24),
                        ProductDescriptionSection(
                          description: product.description,
                          condition: product.condition,
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              VirooColors.background.withOpacity(0.9),
            ],
          ),
        ),
        child: GlowingButton(
          onPressed: () {
            ref.read(cartProvider.notifier).addToCart(product);

            final scaffoldMessenger = ScaffoldMessenger.of(context);
            final snackBar = SnackBar(
              content: Text(
                '✅ تمت إضافة "${product.title}" إلى السلة 🛒',
                style: const TextStyle(fontFamily: 'Cairo'),
              ),
              backgroundColor: VirooColors.success,
              duration: const Duration(seconds: 2),
              action: SnackBarAction(
                label: 'عرض السلة',
                textColor: Colors.white,
                onPressed: () {
                  scaffoldMessenger.hideCurrentSnackBar();
                  Navigator.pushNamed(context, '/cart');
                },
              ),
            );

            scaffoldMessenger.showSnackBar(snackBar);

            Future.delayed(const Duration(seconds: 2), () {
              scaffoldMessenger.hideCurrentSnackBar();
            });
          },
          text: 'أضف إلى السلة',
          icon: Icons.shopping_cart_rounded,
          backgroundColor: modeColor,
        ),
      ),
    );
  }
}
