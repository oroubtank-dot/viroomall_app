// lib/core/services/error_logger.dart
import 'package:flutter/foundation.dart';
import '../exceptions/app_exception.dart';

/// 📊 Error Logger Service
/// تسجيل الأخطاء للتصحيح والتحليل
class ErrorLogger {
  static const String _logPrefix = '🔴 [ERROR]';

  /// تسجيل الخطأ
  static void logError(
    AppException exception, {
    StackTrace? stackTrace,
    Map<String, dynamic>? additionalData,
  }) {
    if (kDebugMode) {
      _printErrorDetails(exception, stackTrace);
    }

    // TODO: إرسال الخطأ لـ Analytics Service (Sentry, Firebase Crashlytics, إلخ)
    _sendToAnalytics(exception, stackTrace, additionalData);
  }

  /// طباعة تفاصيل الخطأ
  static void _printErrorDetails(AppException exception, StackTrace? stackTrace) {
    print('');
    print('═' * 80);
    print('$_logPrefix ERROR LOG');
    print('═' * 80);
    print('📌 Type: ${exception.runtimeType}');
    print('⏰ Time: ${exception.timestamp}');
    print('📝 Message: ${exception.message}');
    print('🏷️ Code: ${exception.code}');

    if (exception is ValidationException && exception.fieldErrors != null) {
      print('\n📋 Field Errors:');
      exception.fieldErrors!.forEach((field, error) {
        print('   • $field: $error');
      });
    }

    if (exception.originalException != null) {
      print('\n🔗 Original Exception: ${exception.originalException}');
    }

    if (stackTrace != null) {
      print('\n📍 Stack Trace:\n$stackTrace');
    }

    print('═' * 80);
    print('');
  }

  /// إرسال الخطأ للتحليل (في المستقبل)
  static void _sendToAnalytics(
    AppException exception,
    StackTrace? stackTrace,
    Map<String, dynamic>? additionalData,
  ) {
    // TODO: تكامل مع Sentry أو Firebase Crashlytics
    // Example:
    // Sentry.captureException(
    //   exception,
    //   stackTrace: stackTrace,
    //   hint: Hint.withMap({
    //     'additional_data': additionalData,
    //   }),
    // );
  }

  /// تسجيل معلومات عامة
  static void logInfo(String message) {
    if (kDebugMode) {
      print('ℹ️ [INFO] $message');
    }
  }

  /// تسجيل تحذير
  static void logWarning(String message) {
    if (kDebugMode) {
      print('⚠️ [WARNING] $message');
    }
  }

  /// تسجيل نجاح
  static void logSuccess(String message) {
    if (kDebugMode) {
      print('✅ [SUCCESS] $message');
    }
  }
}

// Import ValidationException from app_exception.dart if needed
import '../exceptions/app_exception.dart';
