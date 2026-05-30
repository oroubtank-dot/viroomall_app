// lib/features/share/presentation/widgets/share_sheet.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import 'social_buttons.dart';
import 'copy_link_button.dart';
import 'social_preview_card.dart';

class ShareSheet extends StatelessWidget {
  final String imageBase64;
  final String title;
  final String price;
  final String sellerName;
  final String deepLink;

  const ShareSheet({
    super.key,
    required this.imageBase64,
    required this.title,
    required this.price,
    required this.sellerName,
    required this.deepLink,
  });

  static void show(
    BuildContext context, {
    required String imageBase64,
    required String title,
    required String price,
    required String sellerName,
    required String deepLink,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => ShareSheet(
        imageBase64: imageBase64,
        title: title,
        price: price,
        sellerName: sellerName,
        deepLink: deepLink,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: VirooColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        border: Border.all(color: VirooColors.glassBorder, width: 1),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
                color: Colors.white.withAlpha(76),
                borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 20),
          SocialPreviewCard(
            imageBase64: imageBase64,
            title: title,
            price: price,
            sellerName: sellerName,
          ),
          const SizedBox(height: 20),
          SocialButtons(shareText: title, shareLink: deepLink),
          const SizedBox(height: 16),
          CopyLinkButton(link: deepLink),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
