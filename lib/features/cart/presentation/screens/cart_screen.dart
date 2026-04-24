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
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: VirooColors.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                              color: VirooColors.glassBorder, width: 1),
                        ),
                        title: const Text('🗑️ تفريغ السلة',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.bold)),
                        content: const Text(
                            'هل أنت متأكد من حذف جميع المنتجات؟',
                            style: TextStyle(
                                color: Colors.white70, fontFamily: 'Cairo')),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: Text('إلغاء',
                                style: TextStyle(
                                    color: VirooColors.textSecondary,
                                    fontFamily: 'Cairo')),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: VirooColors.error),
                            child: const Text('حذف الكل',
                                style: TextStyle(
                                    fontFamily: 'Cairo', color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      ref.read(cartProvider.notifier).clearCart();
                    }
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
                      child: Icon(Icons.shopping_cart_outlined,
                          size: 80, color: VirooColors.textSecondary),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "السلة فاضية يا برنس، روح اتسوق!",
                      style: TextStyle(
                          color: Colors.white70,
                          fontFamily: 'Cairo',
                          fontSize: 18),
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

                        return Padding(
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
                                        borderRadius: BorderRadius.circular(12),
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
                                                            12)),
                                                child: Icon(
                                                    Icons.shopping_bag_rounded,
                                                    color: modeColor),
                                              ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(product.title,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Cairo',
                                                    fontSize: 15),
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                            const SizedBox(height: 4),
                                            Text(
                                                "${product.price.toStringAsFixed(0)} ج.م",
                                                style: TextStyle(
                                                    color: modeColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Orbitron',
                                                    fontSize: 16)),
                                          ],
                                        ),
                                      ),
                                      // 🗑️ زرار الحذف
                                      GestureDetector(
                                        onTap: () async {
                                          final confirm =
                                              await showDialog<bool>(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              backgroundColor:
                                                  VirooColors.surface,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                side: BorderSide(
                                                    color:
                                                        VirooColors.glassBorder,
                                                    width: 1),
                                              ),
                                              title: const Text('🗑️ حذف منتج',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'Cairo',
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              content: Text(
                                                  'هل تريد حذف "${product.title}" من السلة؟',
                                                  style: const TextStyle(
                                                      color: Colors.white70,
                                                      fontFamily: 'Cairo')),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(ctx, false),
                                                  child: Text('إلغاء',
                                                      style: TextStyle(
                                                          color: VirooColors
                                                              .textSecondary,
                                                          fontFamily: 'Cairo')),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () =>
                                                      Navigator.pop(ctx, true),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              VirooColors
                                                                  .error),
                                                  child: const Text('حذف',
                                                      style: TextStyle(
                                                          fontFamily: 'Cairo',
                                                          color: Colors.white)),
                                                ),
                                              ],
                                            ),
                                          );
                                          if (confirm == true) {
                                            ref
                                                .read(cartProvider.notifier)
                                                .removeFromCart(product.id);
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: VirooColors.error
                                                .withOpacity(0.2),
                                            border: Border.all(
                                                color: VirooColors.error
                                                    .withOpacity(0.4)),
                                          ),
                                          child: const Icon(
                                              Icons.delete_rounded,
                                              color: VirooColors.error,
                                              size: 18),
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
                                                BorderRadius.circular(8)),
                                        child: Text(
                                            'الإجمالي: ${(cartItem.totalPrice).toStringAsFixed(0)} ج.م',
                                            style: TextStyle(
                                                color: modeColor,
                                                fontFamily: 'Orbitron',
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              if (cartItem.quantity <= 1) {
                                                final confirm =
                                                    await showDialog<bool>(
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                    backgroundColor:
                                                        VirooColors.surface,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      side: BorderSide(
                                                          color: VirooColors
                                                              .glassBorder,
                                                          width: 1),
                                                    ),
                                                    title: const Text(
                                                        '🗑️ حذف منتج',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily: 'Cairo',
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    content: Text(
                                                        'الكمية ستصل للصفر. هل تريد حذف "${product.title}" من السلة؟',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white70,
                                                            fontFamily:
                                                                'Cairo')),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                ctx, false),
                                                        child: Text('إلغاء',
                                                            style: TextStyle(
                                                                color: VirooColors
                                                                    .textSecondary,
                                                                fontFamily:
                                                                    'Cairo')),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                ctx, true),
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    VirooColors
                                                                        .error),
                                                        child: const Text('حذف',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Cairo',
                                                                color: Colors
                                                                    .white)),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                                if (confirm == true) {
                                                  ref
                                                      .read(
                                                          cartProvider.notifier)
                                                      .removeFromCart(
                                                          product.id);
                                                }
                                              } else {
                                                ref
                                                    .read(cartProvider.notifier)
                                                    .decreaseQuantity(
                                                        product.id);
                                              }
                                            },
                                            child: Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                  color: modeColor
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: Icon(Icons.remove_rounded,
                                                  color: modeColor, size: 18),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 4),
                                            decoration: BoxDecoration(
                                                color:
                                                    modeColor.withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Text('${cartItem.quantity}',
                                                style: TextStyle(
                                                    color: modeColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Orbitron',
                                                    fontSize: 16)),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              ref
                                                  .read(cartProvider.notifier)
                                                  .increaseQuantity(product.id);
                                            },
                                            child: Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                  color: modeColor
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
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
                            const Text("الإجمالي:",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: 'Cairo')),
                            Text("${totalPrice.toStringAsFixed(0)} ج.م",
                                style: TextStyle(
                                    color: themeColor,
                                    fontSize: 22,
                                    fontFamily: 'Orbitron',
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        GlowingButton(
                          onPressed: () {
                            if (cartItems.isNotEmpty) {
                              final firstProduct = cartItems.first.product;
                              VirooNotificationService.notifySellerNewOrder(
                                firstProduct.title,
                                'أحمد محمد',
                              );
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'تم تأكيد الطلب! 🚀 سيتم توجيهك لصفحة الدفع قريباً',
                                    style: TextStyle(fontFamily: 'Cairo')),
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
