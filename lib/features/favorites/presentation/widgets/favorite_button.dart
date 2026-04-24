// lib/features/favorites/presentation/widgets/favorite_button.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/favorites_provider.dart';
import '../../../../core/models/product_model.dart';

class FavoriteButton extends ConsumerWidget {
  final ProductModel product;
  final double size;

  const FavoriteButton({
    super.key,
    required this.product,
    this.size = 22,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(isFavoriteProvider(product.id));
    final notifier = ref.read(favoritesProvider.notifier);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        notifier.toggleFavorite(product);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isFav
                  ? '🗑️ تم حذف "${product.title}" من المفضلة'
                  : '❤️ تم إضافة "${product.title}" للمفضلة',
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
            backgroundColor:
                isFav ? VirooColors.error : VirooColors.amberPrimary,
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            action: isFav
                ? null
                : SnackBarAction(
                    label: '❤️ عرض المفضلة',
                    textColor: Colors.white,
                    onPressed: () => Navigator.pushNamed(context, '/favorites'),
                  ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color:
              isFav ? VirooColors.error.withAlpha(38) : VirooColors.glassDark,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isFav
                ? VirooColors.error.withAlpha(76)
                : VirooColors.glassBorder,
          ),
        ),
        child: Icon(
          isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: isFav ? VirooColors.error : Colors.white,
          size: size,
        ),
      ),
    );
  }
}
