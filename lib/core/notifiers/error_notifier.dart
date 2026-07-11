// lib/core/notifiers/error_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../states/error_state.dart';
import '../exceptions/app_exception.dart';

/// 🔴 Error Notifier
/// مدير حالات الأخطاء
class ErrorNotifier extends StateNotifier<ErrorState?> {
  ErrorNotifier() : super(null);

  /// عرض خطأ
  void showError(
    AppException exception, {
    bool canRetry = true,
    VoidCallback? onRetry,
  }) {
    state = ErrorState(
      exception: exception,
      displayMessage: exception.message,
      canRetry: canRetry,
      onRetry: onRetry,
    );
  }

  /// إخفاء الخطأ
  void clearError() {
    state = null;
  }

  /// تحديث الخطأ الحالي
  void updateError(ErrorState newError) {
    state = newError;
  }

  /// محاولة إعادة العملية
  void retry() {
    state?.onRetry?.call();
    clearError();
  }
}
