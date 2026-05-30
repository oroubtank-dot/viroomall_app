// lib/features/product/presentation/widgets/product_details/product_video_section.dart
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_widgets.dart';

class ProductVideoSection extends StatelessWidget {
  final String? videoBase64;

  const ProductVideoSection({super.key, this.videoBase64});

  @override
  Widget build(BuildContext context) {
    if (videoBase64 == null || videoBase64!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('🎬 الفيديو هيتشغل قريباً!',
                    style: TextStyle(fontFamily: 'Cairo')),
                backgroundColor: VirooColors.info,
              ),
            );
          },
          child: GlassContainer(
            padding: const EdgeInsets.all(12),
            borderRadius: BorderRadius.circular(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: VirooColors.amberPrimary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.play_circle_fill_rounded,
                      color: VirooColors.amberPrimary, size: 30),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    '🎬 فيديو المنتج',
                    style: TextStyle(
                      color: VirooColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      fontSize: 14,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded,
                    color: VirooColors.textSecondary, size: 14),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
