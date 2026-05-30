// Profile Share Button
// lib/features/profile/presentation/widgets/profile_share_button.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_widgets.dart';

class ProfileShareButton extends StatelessWidget {
  final Color themeColor;
  final VoidCallback? onTap;

  const ProfileShareButton({
    super.key,
    required this.themeColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        borderRadius: BorderRadius.circular(20),
        child: Row(
          children: [
            Icon(Icons.share_rounded, color: themeColor),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'شارك متجرك وزود مبيعاتك!',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: themeColor, size: 16),
          ],
        ),
      ),
    );
  }
}
