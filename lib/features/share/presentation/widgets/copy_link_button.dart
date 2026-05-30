// lib/features/share/presentation/widgets/copy_link_button.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';

class CopyLinkButton extends StatelessWidget {
  final String link;

  const CopyLinkButton({super.key, required this.link});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        Clipboard.setData(ClipboardData(text: link));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('✅ تم نسخ الرابط!', style: TextStyle(fontFamily: 'Cairo')),
            backgroundColor: VirooColors.success,
            duration: Duration(seconds: 1),
          ),
        );
      },
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        borderRadius: BorderRadius.circular(12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.link_rounded,
                color: VirooColors.amberPrimary, size: 20),
            const SizedBox(width: 8),
            const Text('نسخ الرابط',
                style: TextStyle(
                    color: VirooColors.textPrimary,
                    fontSize: 14,
                    fontFamily: 'Cairo')),
            const SizedBox(width: 12),
            Container(
              width: 1,
              height: 20,
              color: VirooColors.glassBorder,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                link,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: VirooColors.textSecondary,
                    fontSize: 11,
                    fontFamily: 'Cairo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
