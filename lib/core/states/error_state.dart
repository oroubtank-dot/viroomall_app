// lib/core/states/error_state.dart
import '../exceptions/app_exception.dart';

/// 🔴 Error State
/// تمثيل حالة الخطأ مع البيانات والرسالة
class ErrorState {
  final AppException exception;
  final String displayMessage;
  final DateTime timestamp;
  final bool canRetry;
  final VoidCallback? onRetry;

  ErrorState({
    required this.exception,
    required this.displayMessage,
    this.canRetry = true,
    this.onRetry,
  }) : timestamp = DateTime.now();

  /// نسخة من الخطأ مع تعديل
  ErrorState copyWith({
    AppException? exception,
    String? displayMessage,
    bool? canRetry,
    VoidCallback? onRetry,
  }) {
    return ErrorState(
      exception: exception ?? this.exception,
      displayMessage: displayMessage ?? this.displayMessage,
      canRetry: canRetry ?? this.canRetry,
      onRetry: onRetry ?? this.onRetry,
    );
  }
}

/// نوع الدالة للإعادة
typedef VoidCallback = void Function();
