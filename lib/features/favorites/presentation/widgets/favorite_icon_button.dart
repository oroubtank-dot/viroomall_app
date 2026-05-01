// lib/features/favorites/presentation/widgets/favorite_icon_button.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/product_model.dart';
import '../providers/favorites_provider.dart';
import '../../../../core/widgets/cart_notification.dart';

/// =============================================
/// ❤️ FavoriteIconButton - زرار المفضلة الموحد
/// =============================================
///
/// يستخدم في: كارت المنتج، صفحة التفاصيل، المفضلة
/// - قلب فاضي لو مش في المفضلة
/// - قلب أحمر لو في المفضلة
/// - Haptic Feedback عند الضغط
/// - إشعار زجاجي بدل SnackBar
/// =============================================
class FavoriteIconButton extends ConsumerWidget {
  final ProductModel product;
  final double size;

  const FavoriteIconButton({
    super.key,
    required this.product,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(isFavoriteProvider(product.id));
    final notifier = ref.read(favoritesProvider.notifier);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        notifier.toggleFavorite(product);
        FavoriteNotification.show(context, product, !isFav);
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isFav
              ? VirooColors.error.withAlpha(50)
              : Colors.black.withAlpha(80),
          shape: BoxShape.circle,
          border: Border.all(
            color: isFav
                ? VirooColors.error.withAlpha(120)
                : Colors.white.withAlpha(80),
            width: 1.2,
          ),
        ),
        child: Icon(
          isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: isFav ? VirooColors.error : Colors.white,
          size: size * 0.5,
        ),
      ),
    );
  }
}
