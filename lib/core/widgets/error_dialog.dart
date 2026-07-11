// lib/core/widgets/error_dialog.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// 🔴 Error Dialog
/// عرض خطأ في Dialog
class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;

  const ErrorDialog({
    Key? key,
    this.title = 'حدث خطأ',
    required this.message,
    this.onRetry,
    this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: VirooColors.primary,
          width: 1,
        ),
      ),
      title: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: VirooColors.primary,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          color: Colors.white70,
          height: 1.5,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onDismiss?.call();
          },
          child: const Text(
            'إغلاق',
            style: TextStyle(
              fontFamily: 'Cairo',
              color: Colors.white70,
            ),
          ),
        ),
        if (onRetry != null)
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onRetry?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: VirooColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'إعادة محاولة',
              style: TextStyle(
                fontFamily: 'Cairo',
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}
