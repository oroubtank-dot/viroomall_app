// lib/features/home/presentation/widgets/product_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/product_model.dart';

class VirooProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onFollowTap;
  final VoidCallback? onSellerTap;
  final bool isFavorite;
  final bool isFollowing;
  final String? sellerName;
  final String? sellerImage;

  const VirooProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onFavoriteTap,
    this.onCartTap,
    this.onFollowTap,
    this.onSellerTap,
    this.isFavorite = false,
    this.isFollowing = false,
    this.sellerName,
    this.sellerImage,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage =
        product.images.isNotEmpty && product.images.first.isNotEmpty;
    final imageUrl = hasImage ? product.images.first : '';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: VirooColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: VirooColors.glassBorder, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // 📸 الصورة (من غير أزرار)
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  child: SizedBox(
                    width: 140,
                    height: 160,
                    child: hasImage
                        ? CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            memCacheWidth: 400,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: VirooColors.glassDark,
                              highlightColor: VirooColors.glassMedium,
                              child: Container(color: VirooColors.surface),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: VirooColors.glassDark,
                              child: const Center(
                                child: Icon(Icons.image_not_supported,
                                    color: VirooColors.textSecondary, size: 30),
                              ),
                            ),
                          )
                        : Container(
                            color: VirooColors.glassDark,
                            child: const Center(
                              child: Icon(Icons.image_outlined,
                                  color: VirooColors.textSecondary, size: 30),
                            ),
                          ),
                  ),
                ),
                // شارة الخصم - فوق على الشمال
                if (product.discountPercentage != null)
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                          color: VirooColors.error,
                          borderRadius: BorderRadius.circular(6)),
                      child: Text('-${product.discountPercentage}%',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                // اسم الوضع - فوق على اليمين
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                        color: product.modeColor.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(6)),
                    child: Text(product.modeLabel,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
                // ❤️ المفضلة - تحت على الشمال
                if (onFavoriteTap != null)
                  Positioned(
                    bottom: 6,
                    left: 6,
                    child: GestureDetector(
                      onTap: onFavoriteTap,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1),
                        ),
                        child: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: 14,
                          color: isFavorite ? VirooColors.error : Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // 📝 التفاصيل
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // اسم المنتج
                    Text(product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Cairo')),
                    const SizedBox(height: 4),

                    // ⭐ التقييم + 👁️ المشاهدات
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            size: 12, color: VirooColors.warning),
                        const SizedBox(width: 2),
                        Text(product.averageRating.toStringAsFixed(1),
                            style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontFamily: 'Cairo')),
                        Text(' (${product.ratingCount})',
                            style: const TextStyle(
                                fontSize: 9,
                                color: VirooColors.textSecondary,
                                fontFamily: 'Cairo')),
                        const Spacer(),
                        const Icon(Icons.visibility_rounded,
                            size: 12, color: VirooColors.textSecondary),
                        const SizedBox(width: 2),
                        Text(_formatViews(product.views),
                            style: const TextStyle(
                                fontSize: 9,
                                color: VirooColors.textSecondary,
                                fontFamily: 'Cairo')),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // 💰 السعر
                    Text('${product.price.toStringAsFixed(0)} ج.م',
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: VirooColors.amberPrimary,
                            fontFamily: 'Orbitron')),
                    if (product.originalPrice != null &&
                        product.originalPrice! > product.price)
                      Text('${product.originalPrice!.toStringAsFixed(0)}',
                          style: const TextStyle(
                              fontSize: 11,
                              decoration: TextDecoration.lineThrough,
                              color: VirooColors.textSecondary,
                              fontFamily: 'Cairo')),
                    const SizedBox(height: 4),

                    // 🏪 اسم البائع
                    GestureDetector(
                      onTap: onSellerTap,
                      child: Row(
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: VirooColors.glassDark,
                              border: Border.all(
                                  color: VirooColors.amberPrimary
                                      .withValues(alpha: 0.5),
                                  width: 1),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(9),
                              child:
                                  sellerImage != null && sellerImage!.isNotEmpty
                                      ? Image.network(sellerImage!,
                                          fit: BoxFit.cover)
                                      : const Icon(Icons.store_rounded,
                                          size: 9,
                                          color: VirooColors.textSecondary),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(sellerName ?? 'متجر موثوق',
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: VirooColors.info,
                                  decoration: TextDecoration.underline,
                                  fontFamily: 'Cairo')),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),

                    // 🎯 3 أزرار كبيرة - تملأ العرض
                    Row(
                      children: [
                        if (onFollowTap != null) ...[
                          Expanded(
                            child: GestureDetector(
                              onTap: onFollowTap,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: isFollowing
                                      ? VirooColors.success
                                          .withValues(alpha: 0.2)
                                      : VirooColors.amberPrimary
                                          .withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                      color: isFollowing
                                          ? VirooColors.success
                                              .withValues(alpha: 0.5)
                                          : VirooColors.amberPrimary
                                              .withValues(alpha: 0.5)),
                                ),
                                child: Center(
                                  child: Text(
                                      isFollowing ? '✓ متابع' : '+ متابعة',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: isFollowing
                                              ? VirooColors.success
                                              : VirooColors.amberPrimary,
                                          fontFamily: 'Cairo')),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _showContactOptions(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color:
                                    VirooColors.success.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: VirooColors.success
                                        .withValues(alpha: 0.4)),
                              ),
                              child: const Center(
                                child: Text('💬 تواصل',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: VirooColors.success,
                                        fontFamily: 'Cairo')),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _shareProduct(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: VirooColors.info.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: VirooColors.info
                                        .withValues(alpha: 0.4)),
                              ),
                              child: const Center(
                                child: Text('📤 مشاركة',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: VirooColors.info,
                                        fontFamily: 'Cairo')),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // 🛒 السلة - اخر حاجة
                    if (onCartTap != null)
                      Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: onCartTap,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: VirooColors.amberPrimary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add_shopping_cart_rounded,
                                    size: 14, color: Colors.white),
                                SizedBox(width: 4),
                                Text('أضف للسلة',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Cairo')),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareProduct(BuildContext context) async {
    final link = 'https://viroomall.com/product/${product.id}';
    final message =
        '🛍️ ${product.title}\n💰 ${product.price.toStringAsFixed(0)} ج.م\n📦 ${product.modeLabel}\n⭐ ${product.averageRating} (${product.ratingCount} تقييم)\n📍 ${product.location}\n\n🔗 $link\n\n📱 حمّل تطبيق VirooMall الآن!';
    try {
      await Share.share(message, subject: 'VirooMall - ${product.title}');
    } catch (e) {
      await Clipboard.setData(ClipboardData(text: link));
      if (context.mounted)
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('📋 تم نسخ رابط المنتج!'),
            backgroundColor: VirooColors.success));
    }
  }

  void _showContactOptions(BuildContext context) {
    final phone =
        product.sellerPhone.isNotEmpty ? product.sellerPhone : '01000000000';
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
            color: VirooColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  width: 50,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              const Text('تواصل مع البائع',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo')),
              const SizedBox(height: 20),
              _contactOption(context,
                  icon: Icons.chat_rounded,
                  label: 'واتساب',
                  color: const Color(0xFF25D366),
                  onTap: () => _launchWhatsApp(phone)),
              const SizedBox(height: 12),
              _contactOption(context,
                  icon: Icons.phone_rounded,
                  label: 'اتصال',
                  color: VirooColors.success,
                  onTap: () => _launchPhone(phone)),
              const SizedBox(height: 12),
              _contactOption(context,
                  icon: Icons.copy_rounded,
                  label: 'نسخ رابط المنتج',
                  color: VirooColors.info, onTap: () {
                Clipboard.setData(ClipboardData(
                    text: 'https://viroomall.com/product/${product.id}'));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('📋 تم نسخ رابط المنتج!'),
                    backgroundColor: VirooColors.success));
              }),
              const SizedBox(height: 20),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _contactOption(BuildContext context,
      {required IconData icon,
      required String label,
      required Color color,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3))),
        child: Row(children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Text(label,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Cairo')),
          const Spacer(),
          Icon(Icons.arrow_forward_ios_rounded, color: color, size: 16)
        ]),
      ),
    );
  }

  Future<void> _launchWhatsApp(String phone) async {
    final url = Uri.parse('https://wa.me/$phone');
    if (await canLaunchUrl(url))
      await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Future<void> _launchPhone(String phone) async {
    final url = Uri.parse('tel:$phone');
    if (await canLaunchUrl(url)) await launchUrl(url);
  }

  String _formatViews(int views) {
    if (views >= 1000000) return '${(views / 1000000).toStringAsFixed(1)}M';
    if (views >= 1000) return '${(views / 1000).toStringAsFixed(1)}K';
    return views.toString();
  }
}
