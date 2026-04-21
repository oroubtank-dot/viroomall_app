// lib/features/home/presentation/widgets/product_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../../../../core/models/product_model.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../product/presentation/screens/product_details_screen.dart';

class ProductCard extends ConsumerWidget {
  final Map<String, dynamic> data;

  const ProductCard({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = data['title'] ?? 'منتج';
    final price = (data['price'] ?? 0).toDouble();
    final originalPrice = data['originalPrice']?.toDouble();
    final productType = data['productType'] ?? 'new';
    final productId =
        data['id'] ?? DateTime.now().millisecondsSinceEpoch.toString();
    final description = data['description'] ?? 'لا يوجد وصف';
    final location = data['location'] ?? 'القاهرة';
    final condition = data['condition'] ?? 'new';
    final sellerId = data['sellerId'] ?? 'unknown';

    final imagesData = data['images'];
    List<String> images = [];
    if (imagesData is List) {
      images = List<String>.from(imagesData);
    } else if (imagesData is String) {
      String cleanedUrl = imagesData;
      cleanedUrl = cleanedUrl.replaceAll('[', '').replaceAll(']', '');
      cleanedUrl = cleanedUrl.replaceAll('"', '').replaceAll("'", '');
      cleanedUrl = cleanedUrl.trim();
      images = [cleanedUrl];
    }
    final imageUrl = images.isNotEmpty ? images[0].toString() : '';

    Color modeColor;
    String modeIcon;
    switch (productType) {
      case 'wholesale':
        modeColor = VirooColors.wholesale;
        modeIcon = '🏪';
        break;
      case 'used':
        modeColor = VirooColors.used;
        modeIcon = '♻️';
        break;
      case 'outlet':
        modeColor = VirooColors.outlet;
        modeIcon = '🔥';
        break;
      default:
        modeColor = VirooColors.shopping;
        modeIcon = '🛍️';
    }

    int? discountPercentage;
    if (originalPrice != null && originalPrice > price) {
      discountPercentage =
          ((originalPrice - price) / originalPrice * 100).round();
    }

    final product = ProductModel(
      id: productId,
      sellerId: sellerId,
      title: title,
      description: description,
      price: price,
      originalPrice: originalPrice,
      productType: productType,
      categoryId: data['categoryId'] ?? 'electronics',
      images: images,
      condition: condition,
      location: location,
      createdAt: DateTime.now(),
    );

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(product: product),
          ),
        );
      },
      child: Hero(
        tag: 'product_$productId',
        child: GlassContainer(
          padding: const EdgeInsets.all(12),
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: modeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: imageUrl.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  errorBuilder: (c, e, s) => Icon(
                                    Icons.image_not_supported_rounded,
                                    size: 40,
                                    color: modeColor,
                                  ),
                                ),
                              )
                            : Icon(
                                Icons.shopping_bag_rounded,
                                size: 40,
                                color: modeColor,
                              ),
                      ),
                    ),
                    if (discountPercentage != null)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: VirooColors.error,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '-$discountPercentage%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      top: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(modeIcon,
                            style: const TextStyle(fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Cairo',
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${price.toStringAsFixed(0)} ج.م',
                        style: TextStyle(
                          color: modeColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Orbitron',
                          fontSize: 14,
                        ),
                      ),
                      if (originalPrice != null)
                        Text(
                          '${originalPrice.toStringAsFixed(0)} ج.م',
                          style: const TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                            fontFamily: 'Orbitron',
                            fontSize: 10,
                          ),
                        ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      ref.read(cartProvider.notifier).addToCart(product);

                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                      final snackBar = SnackBar(
                        content: Text(
                          '✅ تمت إضافة "$title" إلى السلة 🛒',
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
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: modeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.add_shopping_cart_rounded,
                        size: 16,
                        color: modeColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
