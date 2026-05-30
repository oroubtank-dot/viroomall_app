// lib/features/product/presentation/widgets/product_details/used_condition_section.dart
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_widgets.dart';

class UsedConditionSection extends StatelessWidget {
  final String condition;
  final String? defects;
  final bool negotiable;

  const UsedConditionSection({
    super.key,
    required this.condition,
    this.defects,
    this.negotiable = true,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline_rounded,
                  color: VirooColors.used, size: 22),
              SizedBox(width: 8),
              Text(
                '♻️ حالة المنتج',
                style: TextStyle(
                  color: VirooColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _infoRow('الحالة', _conditionLabel(condition), VirooColors.used),
          if (defects != null && defects!.isNotEmpty) ...[
            const SizedBox(height: 8),
            _infoRow('العيوب', defects!, VirooColors.error),
          ],
          if (negotiable) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: VirooColors.warning.withAlpha(38),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: VirooColors.warning.withAlpha(76)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.handshake_rounded,
                      color: VirooColors.warning, size: 18),
                  SizedBox(width: 8),
                  Text(
                    '💰 السعر قابل للتفاوض',
                    style: TextStyle(
                      color: VirooColors.warning,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            color: VirooColors.textSecondary,
            fontSize: 13,
            fontFamily: 'Cairo',
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 13,
              fontFamily: 'Cairo',
            ),
          ),
        ),
      ],
    );
  }

  String _conditionLabel(String condition) {
    switch (condition) {
      case 'new':
        return '⭐ جديد';
      case 'like_new':
        return '🟢 مثل الجديد';
      case 'good':
        return '🟡 جيد';
      case 'acceptable':
        return '🟠 مقبول';
      default:
        return 'جيد';
    }
  }
}
