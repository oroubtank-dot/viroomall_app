// lib/core/widgets/error_widget_display.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// 🔴 Error Widget Display
/// عرض الخطأ كـ widget في الصفحة
class ErrorWidgetDisplay extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onRetry;
  final bool showRetryButton;

  const ErrorWidgetDisplay({
    Key? key,
    this.title = 'حدث خطأ',
    required this.message,
    this.icon = Icons.error_outline,
    this.onRetry,
    this.showRetryButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: VirooColors.primary,
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                color: Colors.white70,
                height: 1.6,
              ),
            ),
          ),
          if (showRetryButton && onRetry != null) ...
            [
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text(
                  'إعادة محاولة',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: VirooColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
        ],
      ),
    );
  }
}

/// 🟡 Network Error Widget
class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const NetworkErrorWidget({Key? key, this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ErrorWidgetDisplay(
      title: 'خطأ في الاتصال',
      message: 'لا توجد اتصال بالإنترنت. تحقق من الاتصال وحاول مرة أخرى',
      icon: Icons.wifi_off_outlined,
      onRetry: onRetry,
    );
  }
}

/// 🔒 Unauthorized Error Widget
class UnauthorizedWidget extends StatelessWidget {
  final VoidCallback? onLogin;

  const UnauthorizedWidget({Key? key, this.onLogin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ErrorWidgetDisplay(
      title: 'جلسة منتهية',
      message: 'تم انتهاء صلاحية جلستك. يرجى تسجيل الدخول مرة أخرى',
      icon: Icons.lock_outline,
      onRetry: onLogin,
      showRetryButton: onLogin != null,
    );
  }
}

/// 🔍 Not Found Error Widget
class NotFoundWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const NotFoundWidget({
    Key? key,
    this.message = 'البيانات المطلوبة غير موجودة',
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ErrorWidgetDisplay(
      title: 'غير موجود',
      message: message,
      icon: Icons.not_interested_outlined,
      onRetry: onRetry,
    );
  }
}
