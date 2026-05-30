// lib/features/product/presentation/widgets/product_share_button.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_colors.dart';

class ProductShareButton extends StatelessWidget {
  final String productTitle;
  final String productId;
  final String productPrice;

  const ProductShareButton({
    super.key,
    required this.productTitle,
    required this.productId,
    required this.productPrice,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        final message = '''
🛍️ *$productTitle*
💰 السعر: $productPrice ج.م

📱 شوف المنتج ده على VirooMall!
🔗 حمل التطبيق: https://viroomall.eg/app
''';
        Share.share(message, subject: productTitle);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: VirooColors.amberPrimary.withAlpha(38),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: VirooColors.amberPrimary.withAlpha(76)),
        ),
        child: const Icon(Icons.share_rounded,
            color: VirooColors.amberPrimary, size: 20),
      ),
    );
  }
}
