// lib/core/services/error_handler.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../exceptions/app_exception.dart';
import 'error_logger.dart';

/// 🎯 Error Handler Service
/// خدمة مركزية للتعامل مع جميع الأخطاء
class ErrorHandler {
  static final ErrorHandler _instance = ErrorHandler._internal();

  ErrorHandler._internal();

  factory ErrorHandler() {
    return _instance;
  }

  /// تحويل أي exception لـ AppException
  AppException handleException(
    dynamic exception, {
    StackTrace? stackTrace,
    String? customMessage,
  }) {
    // إذا كانت بالفعل AppException، ارجعها مباشرة
    if (exception is AppException) {
      return exception;
    }

    AppException appException;

    // Firebase Auth Exceptions
    if (exception is FirebaseAuthException) {
      appException = _handleFirebaseAuthException(exception);
    }
    // Firebase Firestore Exceptions
    else if (exception is FirebaseException) {
      appException = _handleFirebaseException(exception);
    }
    // Socket Exceptions (Network)
    else if (exception.toString().contains('SocketException')) {
      appException = NetworkException(
        originalException: exception as Exception,
        stackTrace: stackTrace,
      );
    }
    // Timeout Exception
    else if (exception.toString().contains('TimeoutException')) {
      appException = TimeoutException(
        originalException: exception as Exception,
        stackTrace: stackTrace,
      );
    }
    // String exceptions
    else if (exception is String) {
      appException = UnknownException(
        message: exception,
        stackTrace: stackTrace,
      );
    }
    // Default unknown exception
    else {
      appException = UnknownException(
        message: customMessage ?? exception.toString(),
        originalException: exception as Exception?,
        stackTrace: stackTrace,
      );
    }

    // تسجيل الخطأ
    ErrorLogger.logError(
      appException,
      stackTrace: stackTrace ?? StackTrace.current,
    );

    return appException;
  }

  /// معالجة Firebase Auth Exceptions
  AppException _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-phone-number':
        return ValidationException(
          message: 'رقم الهاتف غير صحيح',
          code: 'INVALID_PHONE',
          originalException: e,
        );
      case 'too-many-requests':
        return BusinessException(
          message: 'محاولات كثيرة. حاول لاحقاً',
          code: 'TOO_MANY_REQUESTS',
          originalException: e,
        );
      case 'invalid-verification-code':
        return OTPException(
          message: 'رمز التحقق غير صحيح',
          code: 'INVALID_OTP',
          originalException: e,
        );
      case 'session-expired':
        return OTPException(
          message: 'انتهت صلاحية الجلسة. حاول من جديد',
          code: 'SESSION_EXPIRED',
          originalException: e,
        );
      case 'user-disabled':
        return ForbiddenException(
          message: 'تم تعطيل حسابك',
          code: 'USER_DISABLED',
          originalException: e,
        );
      case 'operation-not-allowed':
        return ForbiddenException(
          message: 'هذه العملية غير مسموحة حالياً',
          code: 'OPERATION_NOT_ALLOWED',
          originalException: e,
        );
      default:
        return UnknownException(
          message: e.message ?? 'خطأ في المصادقة',
          code: e.code,
          originalException: e,
        );
    }
  }

  /// معالجة Firebase Exceptions
  AppException _handleFirebaseException(FirebaseException e) {
    switch (e.code) {
      case 'network-error':
        return NetworkException(
          originalException: e as Exception,
        );
      case 'permission-denied':
        return ForbiddenException(
          message: 'ليس لديك صلاحية للقيام بهذا العمل',
          code: 'PERMISSION_DENIED',
          originalException: e as Exception,
        );
      case 'not-found':
        return NotFoundException(
          message: 'البيانات المطلوبة غير موجودة',
          code: 'RESOURCE_NOT_FOUND',
          originalException: e as Exception,
        );
      case 'unavailable':
        return ServerException(
          message: 'الخدمة غير متاحة حالياً',
          code: 'SERVICE_UNAVAILABLE',
          originalException: e as Exception,
        );
      case 'deadline-exceeded':
        return TimeoutException(
          originalException: e as Exception,
        );
      default:
        return UnknownException(
          message: e.message ?? 'خطأ في قاعدة البيانات',
          code: e.code,
          originalException: e as Exception,
        );
    }
  }

  /// الحصول على رسالة خطأ آمنة للعرض
  String getDisplayMessage(AppException exception) {
    return exception.message;
  }

  /// التحقق من نوع الخطأ
  bool isNetworkError(AppException exception) {
    return exception is NetworkException ||
        exception is TimeoutException ||
        exception is ServerException;
  }

  /// إعادة محاولة العملية
  Future<T> retryOperation<T>(
    Future<T> Function() operation, {
    int maxAttempts = 3,
    Duration delay = const Duration(milliseconds: 1000),
  }) async {
    int attempts = 0;
    late AppException lastError;

    while (attempts < maxAttempts) {
      try {
        attempts++;
        return await operation();
      } on AppException catch (e) {
        lastError = e;
        if (attempts < maxAttempts) {
          await Future.delayed(delay * attempts);
        }
      } catch (e, stackTrace) {
        lastError = handleException(e, stackTrace: stackTrace);
        if (attempts < maxAttempts) {
          await Future.delayed(delay * attempts);
        }
      }
    }

    throw lastError;
  }
}
