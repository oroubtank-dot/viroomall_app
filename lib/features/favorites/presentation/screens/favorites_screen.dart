// lib/features/favorites/presentation/screens/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../../../../core/widgets/viroo_background.dart';
import '../../../../core/models/product_model.dart';
import '../../../home/presentation/widgets/product_card.dart';
import '../providers/favorites_provider.dart';
import '../widgets/favorite_icon_button.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final themeColor = VirooColors.shopping;

    return Scaffold(
      backgroundColor: VirooColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '❤️ المفضلة',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: favorites.isNotEmpty
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
                          side: const BorderSide(
                              color: VirooColors.glassBorder, width: 1),
                        ),
                        title: const Text('🗑️ تفريغ المفضلة',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.bold)),
                        content: const Text(
                            'هل تريد حذف جميع المنتجات من المفضلة؟',
                            style: TextStyle(
                                color: Colors.white70, fontFamily: 'Cairo')),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('إلغاء',
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
                                    color: Colors.white, fontFamily: 'Cairo')),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      ref.read(favoritesProvider.notifier).clearFavorites();
                    }
                  },
                ),
              ]
            : null,
      ),
      body: VirooBackground(
        showOrbs: true,
        themeColor: themeColor,
        child: favorites.isEmpty
            ? const EmptyState(
                icon: Icons.favorite_border_rounded,
                title: 'المفضلة فاضية',
                subtitle: 'لم تقم بإضافة أي منتج للمفضلة بعد',
              )
            : GridView.builder(
                padding: const EdgeInsets.all(16),
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final product = favorites[index];
                  return Stack(
                    children: [
                      VirooProductCard(
                        product: product,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/product',
                            arguments: product.id,
                          );
                        },
                      ),
                      // ❤️ زرار الحذف من المفضلة
                      Positioned(
                        top: 8,
                        right: 8,
                        child: FavoriteIconButton(
                          product: product,
                          size: 34,
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
