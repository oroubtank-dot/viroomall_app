// Expiring Alert Banner
// lib/features/profile/presentation/widgets/expiring_alert_banner.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';

class ExpiringAlertBanner extends StatelessWidget {
  final int expiringCount;
  final int expiredCount;
  final VoidCallback onRenewAll;
  final Color themeColor;

  const ExpiringAlertBanner({
    super.key,
    required this.expiringCount,
    required this.expiredCount,
    required this.onRenewAll,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    if (expiringCount == 0 && expiredCount == 0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassContainer(
        padding: const EdgeInsets.all(12),
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            Icon(Icons.warning_amber_rounded,
                color: VirooColors.warning, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (expiringCount > 0)
                    Text(
                      '⏳ $expiringCount منتجات تنتهي قريباً',
                      style: TextStyle(
                          color: VirooColors.warning,
                          fontFamily: 'Cairo',
                          fontSize: 13),
                    ),
                  if (expiredCount > 0)
                    Text(
                      '🔴 $expiredCount منتجات منتهية',
                      style: TextStyle(
                          color: VirooColors.error,
                          fontFamily: 'Cairo',
                          fontSize: 13),
                    ),
                ],
              ),
            ),
            TextButton(
              onPressed: onRenewAll,
              child: Text(
                'تجديد الكل',
                style: TextStyle(
                    color: themeColor,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
