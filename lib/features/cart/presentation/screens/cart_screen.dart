// lib/features/cart/presentation/screens/cart_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../../../../core/widgets/viroo_background.dart';
import '../../../../core/services/notification_service.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_preview_sheet.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final totalPrice = ref.watch(cartTotalPriceProvider);
    final themeColor = VirooColors.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "سلة المشتريات",
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: cartItems.isNotEmpty
            ? [
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded,
                      color: VirooColors.error),
                  onPressed: () {
                    ref.read(cartProvider.notifier).clearCart();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم تفريغ السلة',
                            style: TextStyle(fontFamily: 'Cairo')),
                        backgroundColor: VirooColors.error,
                      ),
                    );
                  },
                ),
              ]
            : null,
      ),
      body: VirooBackground(
        showOrbs: true,
        themeColor: themeColor,
        child: cartItems.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GlassContainer(
                      padding: const EdgeInsets.all(30),
                      borderRadius: BorderRadius.circular(30),
                      child: Icon(
                        Icons.shopping_cart_outlined,
                        size: 80,
                        color: VirooColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "السلة فاضية يا برنس، روح اتسوق!",
                      style: TextStyle(
                        color: Colors.white70,
                        fontFamily: 'Cairo',
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      padding: const EdgeInsets.all(15),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final cartItem = cartItems[index];
                        final product = cartItem.product;
                        final imageUrl =
                            product.images.isNotEmpty ? product.images[0] : '';
                        final modeColor = product.modeColor;

                        return Dismissible(
                          key: Key(product.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              color: VirooColors.error,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(Icons.delete_rounded,
                                color: Colors.white),
                          ),
                          onDismissed: (direction) {
                            ref
                                .read(cartProvider.notifier)
                                .removeFromCart(product.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'تم حذف "${product.title}" من السلة',
                                  style: const TextStyle(fontFamily: 'Cairo'),
                                ),
                                backgroundColor: VirooColors.error,
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  builder: (context) =>
                                      ProductPreviewSheet(product: product),
                                );
                              },
                              child: GlassContainer(
                                padding: const EdgeInsets.all(12),
                                borderRadius: BorderRadius.circular(20),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: imageUrl.isNotEmpty
                                              ? (imageUrl.startsWith('http')
                                                  ? Image.network(imageUrl,
                                                      width: 70,
                                                      height: 70,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (c, e, s) =>
                                                          Container(
                                                              color: modeColor
                                                                  .withOpacity(
                                                                      0.1),
                                                              child: Icon(
                                                                  Icons
                                                                      .image_not_supported,
                                                                  color:
                                                                      modeColor)))
                                                  : Image.memory(
                                                      base64Decode(imageUrl),
                                                      width: 70,
                                                      height: 70,
                                                      fit: BoxFit.cover))
                                              : Container(
                                                  width: 70,
                                                  height: 70,
                                                  decoration: BoxDecoration(
                                                    color: modeColor
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Icon(
                                                      Icons
                                                          .shopping_bag_rounded,
                                                      color: modeColor),
                                                ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                product.title,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'Cairo',
                                                  fontSize: 15,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Icon(Icons.store_rounded,
                                                      color: VirooColors
                                                          .textSecondary,
                                                      size: 12),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    'VirooMall',
                                                    style: TextStyle(
                                                      color: VirooColors
                                                          .textSecondary,
                                                      fontFamily: 'Cairo',
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Icon(Icons.star_rounded,
                                                      color: Colors.amber,
                                                      size: 12),
                                                  const SizedBox(width: 2),
                                                  const Text(
                                                    '4.5',
                                                    style: TextStyle(
                                                      color: Colors.amber,
                                                      fontFamily: 'Cairo',
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                "${product.price.toStringAsFixed(0)} ج.م",
                                                style: TextStyle(
                                                  color: modeColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Orbitron',
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: modeColor.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            'الإجمالي: ${(cartItem.totalPrice).toStringAsFixed(0)} ج.م',
                                            style: TextStyle(
                                              color: modeColor,
                                              fontFamily: 'Orbitron',
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                ref
                                                    .read(cartProvider.notifier)
                                                    .decreaseQuantity(
                                                        product.id);
                                              },
                                              child: Container(
                                                width: 32,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  color: modeColor
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Icon(
                                                    Icons.remove_rounded,
                                                    color: modeColor,
                                                    size: 18),
                                              ),
                                            ),
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                color:
                                                    modeColor.withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                '${cartItem.quantity}',
                                                style: TextStyle(
                                                  color: modeColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Orbitron',
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                ref
                                                    .read(cartProvider.notifier)
                                                    .increaseQuantity(
                                                        product.id);
                                              },
                                              child: Container(
                                                width: 32,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  color: modeColor
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Icon(Icons.add_rounded,
                                                    color: modeColor, size: 18),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "الإجمالي:",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            Text(
                              "${totalPrice.toStringAsFixed(0)} ج.م",
                              style: TextStyle(
                                color: themeColor,
                                fontSize: 22,
                                fontFamily: 'Orbitron',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        GlowingButton(
                          onPressed: () {
                            // 👇 إشعار للبائع بطلب جديد
                            if (cartItems.isNotEmpty) {
                              final firstProduct = cartItems.first.product;
                              VirooNotificationService.notifySellerNewOrder(
                                firstProduct.title,
                                'أحمد محمد', // ممكن تجيب اسم المستخدم من AuthService
                              );
                            }

                            // 👇 إشعار تذكيري (للتجربة - هيشتغل بعد 5 ثواني)
                            Future.delayed(const Duration(seconds: 5), () {
                              VirooNotificationService.showReminderNotification(
                                '⏰ تذكير',
                                'لديك منتجات في السلة لم تكمل شرائها',
                              );
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'تم تأكيد الطلب! 🚀 سيتم توجيهك لصفحة الدفع قريباً',
                                  style: TextStyle(fontFamily: 'Cairo'),
                                ),
                                backgroundColor: VirooColors.success,
                              ),
                            );
                          },
                          text: "تأكيد الطلب",
                          icon: Icons.check_circle_rounded,
                          backgroundColor: themeColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
