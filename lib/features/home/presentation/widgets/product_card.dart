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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildImageSection(),
            _buildDetailsSection(context),
          ],
        ),
      ),
    );
  }

  // =============================================
  // 📸 قسم الصورة
  // =============================================
  Widget _buildImageSection() {
    final hasImage =
        product.images.isNotEmpty && product.images.first.isNotEmpty;
    final imageUrl = hasImage ? product.images.first : '';

    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: hasImage
              ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  height: 105,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  memCacheWidth: 400,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: VirooColors.glassDark,
                    highlightColor: VirooColors.glassMedium,
                    child: Container(height: 105, color: VirooColors.surface),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 105,
                    width: double.infinity,
                    color: VirooColors.glassDark,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported,
                          color: VirooColors.textSecondary,
                          size: 40,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'الصورة غير متوفرة',
                          style: TextStyle(
                            color: VirooColors.textSecondary,
                            fontSize: 10,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(
                  height: 105,
                  width: double.infinity,
                  color: VirooColors.glassDark,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_outlined,
                        color: VirooColors.textSecondary,
                        size: 40,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'لا توجد صورة',
                        style: TextStyle(
                          color: VirooColors.textSecondary,
                          fontSize: 10,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
        ),

        // شارة الخصم
        if (product.discountPercentage != null)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: VirooColors.error,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: VirooColors.error.withValues(alpha: 0.4),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Text(
                '-${product.discountPercentage}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

        // شارة الوضع
        Positioned(
          bottom: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: product.modeColor.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(product.modeIcon, style: const TextStyle(fontSize: 9)),
                const SizedBox(width: 3),
                Text(
                  product.modeLabel.split(' ').first,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),

        // ❤️ زر المفضلة
        if (onFavoriteTap != null)
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: onFavoriteTap,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.4), width: 1.5),
                ),
                child: Icon(
                  isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  size: 16,
                  color: isFavorite ? VirooColors.error : Colors.white,
                ),
              ),
            ),
          ),

        // 🛒 زر السلة
        if (onCartTap != null)
          Positioned(
            bottom: 8,
            right: 8,
            child: GestureDetector(
              onTap: onCartTap,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: VirooColors.amberPrimary,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: VirooColors.amberPrimary.withValues(alpha: 0.4),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.add_shopping_cart_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // =============================================
  // 📝 قسم التفاصيل
  // =============================================
  Widget _buildDetailsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            product.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontFamily: 'Cairo',
              height: 1.2,
            ),
          ),
          const SizedBox(height: 3),

          // اسم البائع + صورته (قابل للضغط) + زر المتابعة
          Row(
            children: [
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
                            color:
                                VirooColors.amberPrimary.withValues(alpha: 0.5),
                            width: 1.5),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: sellerImage != null && sellerImage!.isNotEmpty
                            ? Image.network(sellerImage!, fit: BoxFit.cover)
                            : const Icon(Icons.store_rounded,
                                size: 10, color: VirooColors.textSecondary),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      sellerName ?? 'متجر موثوق',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 9,
                        color: VirooColors.info,
                        decoration: TextDecoration.underline,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // 👤 زر المتابعة
              if (onFollowTap != null)
                GestureDetector(
                  onTap: onFollowTap,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isFollowing
                          ? VirooColors.success.withValues(alpha: 0.2)
                          : VirooColors.amberPrimary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isFollowing
                            ? VirooColors.success.withValues(alpha: 0.5)
                            : VirooColors.amberPrimary.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Text(
                      isFollowing ? '✓ متابع' : '+ متابعة',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: isFollowing
                            ? VirooColors.success
                            : VirooColors.amberPrimary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 2),

          // السعر + المشاهدات
          Row(
            children: [
              Text(
                '${product.price.toStringAsFixed(0)} ج.م',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: VirooColors.amberPrimary,
                  fontFamily: 'Orbitron',
                ),
              ),
              if (product.originalPrice != null &&
                  product.originalPrice! > product.price)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    '${product.originalPrice!.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 9,
                      decoration: TextDecoration.lineThrough,
                      color: VirooColors.textSecondary,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.visibility_rounded,
                      size: 10, color: VirooColors.textSecondary),
                  const SizedBox(width: 2),
                  Text(
                    _formatViews(product.views),
                    style: const TextStyle(
                      fontSize: 8,
                      color: VirooColors.textSecondary,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 3),

          // ⭐ التقييم + 📤 مشاركة
          Row(
            children: [
              const Icon(Icons.star_rounded,
                  size: 11, color: VirooColors.warning),
              const SizedBox(width: 2),
              Text(
                product.averageRating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () => _shareProduct(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: VirooColors.info.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: VirooColors.info.withValues(alpha: 0.4)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.share_rounded,
                          size: 12, color: VirooColors.info),
                      SizedBox(width: 3),
                      Text('مشاركة',
                          style: TextStyle(
                              fontSize: 9,
                              color: VirooColors.info,
                              fontFamily: 'Cairo')),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),

          // 📞 تواصل + ❤️ المفضلة
          Row(
            children: [
              GestureDetector(
                onTap: () => _showContactOptions(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: VirooColors.success.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: VirooColors.success.withValues(alpha: 0.4)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.chat_bubble_outline_rounded,
                          size: 12, color: VirooColors.success),
                      SizedBox(width: 3),
                      Text('تواصل',
                          style: TextStyle(
                              fontSize: 9,
                              color: VirooColors.success,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Cairo')),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.favorite_rounded,
                      size: 10, color: VirooColors.error),
                  const SizedBox(width: 2),
                  Text('${product.favorites}',
                      style: const TextStyle(
                          fontSize: 9,
                          color: VirooColors.textSecondary,
                          fontFamily: 'Cairo')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =============================================
  // 📤 مشاركة المنتج
  // =============================================
  void _shareProduct(BuildContext context) async {
    final link = 'https://viroomall.com/product/${product.id}';
    final message = '🛍️ ${product.title}\n'
        '💰 ${product.price.toStringAsFixed(0)} ج.م\n'
        '📦 ${product.modeLabel}\n'
        '⭐ ${product.averageRating} (${product.ratingCount} تقييم)\n'
        '📍 ${product.location}\n\n'
        '🔗 $link\n\n'
        '📱 حمّل تطبيق VirooMall الآن!';

    try {
      await Share.share(message, subject: 'VirooMall - ${product.title}');
    } catch (e) {
      await Clipboard.setData(ClipboardData(text: link));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('📋 تم نسخ رابط المنتج!'),
            backgroundColor: VirooColors.success,
          ),
        );
      }
    }
  }

  // =============================================
  // 📞 حوار التواصل
  // =============================================
  void _showContactOptions(BuildContext context) {
    final phone =
        product.sellerPhone.isNotEmpty ? product.sellerPhone : '01000000000';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: VirooColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'تواصل مع البائع',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('📋 تم نسخ رابط المنتج!'),
                        backgroundColor: VirooColors.success),
                  );
                }),
                const SizedBox(height: 20),
              ],
            ),
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
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Text(label,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Cairo')),
            const Spacer(),
            Icon(Icons.arrow_forward_ios_rounded, color: color, size: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _launchWhatsApp(String phone) async {
    final url = Uri.parse('https://wa.me/$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchPhone(String phone) async {
    final url = Uri.parse('tel:$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  String _formatViews(int views) {
    if (views >= 1000000) return '${(views / 1000000).toStringAsFixed(1)}M';
    if (views >= 1000) return '${(views / 1000).toStringAsFixed(1)}K';
    return views.toString();
  }
}
