// lib/core/widgets/error_snackbar.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// 🔴 Error Snackbar
/// عرض خطأ في Snackbar
class ErrorSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    VoidCallback? onRetry,
    Duration duration = const Duration(seconds: 4),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        duration: duration,
        action: onRetry != null
            ? SnackBarAction(
                label: 'إعادة',
                textColor: Colors.white,
                onPressed: onRetry,
              )
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(12),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
