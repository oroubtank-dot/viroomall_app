// lib/features/share/presentation/widgets/social_preview_card.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';

class SocialPreviewCard extends StatelessWidget {
  final String imageBase64;
  final String title;
  final String price;
  final String sellerName;

  const SocialPreviewCard({
    super.key,
    required this.imageBase64,
    required this.title,
    required this.price,
    required this.sellerName,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.memory(
              base64Decode(imageBase64),
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(
                width: 70,
                height: 70,
                color: VirooColors.amberPrimary.withAlpha(25),
                child: const Icon(Icons.image_rounded,
                    color: VirooColors.amberPrimary),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: VirooColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'Cairo')),
                const SizedBox(height: 4),
                Text(sellerName,
                    style: const TextStyle(
                        color: VirooColors.textSecondary,
                        fontSize: 11,
                        fontFamily: 'Cairo')),
                const SizedBox(height: 4),
                Text('$price ج.م',
                    style: const TextStyle(
                        color: VirooColors.amberPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'Orbitron')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
