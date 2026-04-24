// lib/core/widgets/cart_notification.dart
import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../models/product_model.dart';

/// =============================================
/// 🛒 CartNotification - إشعار زجاجي أنيق
/// =============================================
///
/// يظهر من الأعلى مع Slide Animation
/// يحتوي على صورة المنتج + اسمه + زرار عرض السلة
/// يختفي تلقائياً بعد 3 ثواني
/// =============================================
class CartNotification {
  static void show(BuildContext context, ProductModel product) {
    OverlayEntry? entry;

    entry = OverlayEntry(
      builder: (context) => _CartNotificationWidget(
        product: product,
        onClose: () => entry?.remove(),
      ),
    );

    Overlay.of(context).insert(entry);

    Timer(const Duration(seconds: 3), () {
      entry?.remove();
    });
  }
}

class _CartNotificationWidget extends StatefulWidget {
  final ProductModel product;
  final VoidCallback onClose;

  const _CartNotificationWidget({
    required this.product,
    required this.onClose,
  });

  @override
  State<_CartNotificationWidget> createState() =>
      _CartNotificationWidgetState();
}

class _CartNotificationWidgetState extends State<_CartNotificationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = widget.product.modeColor;

    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 16,
      right: 16,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _slideAnimation.value * 100),
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: child,
            ),
          );
        },
        child: GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            widget.onClose();
            Navigator.pushNamed(context, '/cart');
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: VirooColors.surface.withAlpha(240),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: themeColor.withAlpha(100),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: themeColor.withAlpha(50),
                      blurRadius: 20,
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: Colors.black.withAlpha(80),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // 📱 صورة المنتج مصغرة
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: themeColor.withAlpha(80),
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: widget.product.images.isNotEmpty
                            ? Image.memory(
                                base64Decode(widget.product.images.first),
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => Icon(
                                  Icons.shopping_bag_rounded,
                                  color: themeColor,
                                  size: 22,
                                ),
                              )
                            : Icon(
                                Icons.shopping_bag_rounded,
                                color: themeColor,
                                size: 22,
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // 📝 تفاصيل المنتج
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                color: VirooColors.success,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                '✅ تمت الإضافة!',
                                style: TextStyle(
                                  color: VirooColors.success,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  widget.onClose();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(25),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close_rounded,
                                    color: VirooColors.textSecondary,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.product.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: VirooColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${widget.product.price.toStringAsFixed(0)} ج.م',
                            style: TextStyle(
                              color: themeColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              fontFamily: 'Orbitron',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),

                    // 🛒 زرار عرض السلة
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        widget.onClose();
                        Navigator.pushNamed(context, '/cart');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              themeColor,
                              themeColor.withAlpha(200),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: themeColor.withAlpha(60),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.shopping_cart_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'عرض السلة',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
