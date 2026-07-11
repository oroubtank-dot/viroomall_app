// lib/core/widgets/error_boundary.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/error_provider.dart';
import 'error_dialog.dart';
import 'error_snackbar.dart';

/// 🔴 Error Boundary
/// عرض الأخطاء تلقائياً عند حدوثها
class ErrorBoundary extends ConsumerWidget {
  final Widget child;
  final bool showAsDialog;

  const ErrorBoundary({
    Key? key,
    required this.child,
    this.showAsDialog = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final errorState = ref.watch(errorProvider);

    // عرض الخطأ عند ظهوره
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (errorState != null) {
        if (showAsDialog) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(
              message: errorState.displayMessage,
              onRetry: errorState.canRetry ? errorState.onRetry : null,
              onDismiss: () {
                ref.read(errorProvider.notifier).clearError();
              },
            ),
          );
        } else {
          ErrorSnackbar.show(
            context,
            message: errorState.displayMessage,
            onRetry: errorState.canRetry ? errorState.onRetry : null,
          );
          // إخفاء الخطأ بعد العرض
          Future.delayed(const Duration(milliseconds: 500), () {
            ref.read(errorProvider.notifier).clearError();
          });
        }
      }
    });

    return child;
  }
}
