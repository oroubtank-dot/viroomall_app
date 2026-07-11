// lib/core/exceptions/app_exception.dart

/// 🔴 App Exception Base Class
/// جميع الأخطاء في التطبيق تورث من هذا الكلاس
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final Exception? originalException;
  final StackTrace? stackTrace;
  final DateTime timestamp;

  AppException({
    required this.message,
    this.code,
    this.originalException,
    this.stackTrace,
  }) : timestamp = DateTime.now();

  @override
  String toString() => message;
}

// ─────────────────────────────────────────────────────────────
// 🔵 Network Exceptions
// ─────────────────────────────────────────────────────────────

/// خطأ في الاتصال بالإنترنت
class NetworkException extends AppException {
  NetworkException({
    String message = 'فشل الاتصال بالإنترنت. تحقق من الاتصال وحاول مرة أخرى',
    String? code,
    Exception? originalException,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: code ?? 'NETWORK_ERROR',
    originalException: originalException,
    stackTrace: stackTrace,
  );
}

/// انقطاع الاتصال بالخادم
class ServerException extends AppException {
  ServerException({
    String message = 'حدث خطأ في الخادم. حاول لاحقاً',
    String? code,
    int? statusCode,
    Exception? originalException,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: code ?? 'SERVER_ERROR',
    originalException: originalException,
    stackTrace: stackTrace,
  );
}

/// انقطاع الاتصال (Timeout)
class TimeoutException extends AppException {
  TimeoutException({
    String message = 'انتهت مهلة الطلب. الخادم بطيء. حاول مرة أخرى',
    String? code,
    Exception? originalException,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: code ?? 'TIMEOUT_ERROR',
    originalException: originalException,
    stackTrace: stackTrace,
  );
}

// ─────────────────────────────────────────────────────────────
// 🟡 Authentication Exceptions
// ─────────────────────────────────────────────────────────────

/// المستخدم غير مصرح
class UnauthorizedException extends AppException {
  UnauthorizedException({
    String message = 'أنت غير مصرح. يرجى تسجيل الدخول من جديد',
    String? code,
    Exception? originalException,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: code ?? 'UNAUTHORIZED',
    originalException: originalException,
    stackTrace: stackTrace,
  );
}

/// المستخدم ممنوع من الدخول
class ForbiddenException extends AppException {
  ForbiddenException({
    String message = 'ليس لديك صلاحية للقيام بهذا العمل',
    String? code,
    Exception? originalException,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: code ?? 'FORBIDDEN',
    originalException: originalException,
    stackTrace: stackTrace,
  );
}

/// خطأ في OTP
class OTPException extends AppException {
  OTPException({
    String message = 'رمز التحقق غير صحيح أو انتهت صلاحيته',
    String? code,
    Exception? originalException,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: code ?? 'OTP_ERROR',
    originalException: originalException,
    stackTrace: stackTrace,
  );
}

// ─────────────────────────────────────────────────────────────
// 🟠 Validation Exceptions
// ─────────────────────────────────────────────────────────────

/// خطأ في التحقق من البيانات
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  ValidationException({
    String message = 'تحقق من البيانات المدخلة',
    this.fieldErrors,
    String? code,
    Exception? originalException,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: code ?? 'VALIDATION_ERROR',
    originalException: originalException,
    stackTrace: stackTrace,
  );
}

/// البيانات غير موجودة
class NotFoundException extends AppException {
  NotFoundException({
    String message = 'البيانات المطلوبة غير موجودة',
    String? code,
    Exception? originalException,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: code ?? 'NOT_FOUND',
    originalException: originalException,
    stackTrace: stackTrace,
  );
}

// ─────────────────────────────────────────────────────────────
// 🟣 Business Logic Exceptions
// ─────────────────────────────────────────────────────────────

/// خطأ في المنطق التجاري
class BusinessException extends AppException {
  BusinessException({
    required String message,
    String? code,
    Exception? originalException,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: code ?? 'BUSINESS_ERROR',
    originalException: originalException,
    stackTrace: stackTrace,
  );
}

/// رصيد غير كافي
class InsufficientBalanceException extends AppException {
  InsufficientBalanceException({
    String message = 'الرصيد غير كافي لإتمام العملية',
    String? code,
    Exception? originalException,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: code ?? 'INSUFFICIENT_BALANCE',
    originalException: originalException,
    stackTrace: stackTrace,
  );
}

/// المنتج غير متاح
class OutOfStockException extends AppException {
  OutOfStockException({
    String message = 'المنتج غير متاح حالياً',
    String? code,
    Exception? originalException,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: code ?? 'OUT_OF_STOCK',
    originalException: originalException,
    stackTrace: stackTrace,
  );
}

// ─────────────────────────────────────────────────────────────
// ⚫ Generic Exceptions
// ─────────────────────────────────────────────────────────────

/// خطأ عام غير متوقع
class UnknownException extends AppException {
  UnknownException({
    String message = 'حدث خطأ غير متوقع. حاول لاحقاً',
    String? code,
    Exception? originalException,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: code ?? 'UNKNOWN_ERROR',
    originalException: originalException,
    stackTrace: stackTrace,
  );
}

/// خطأ في القاعدة البيانات
class DatabaseException extends AppException {
  DatabaseException({
    String message = 'حدث خطأ في قاعدة البيانات',
    String? code,
    Exception? originalException,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: code ?? 'DATABASE_ERROR',
    originalException: originalException,
    stackTrace: stackTrace,
  );
}

/// خطأ في التخزين المحلي
class StorageException extends AppException {
  StorageException({
    String message = 'خطأ في الوصول للذاكرة المحلية',
    String? code,
    Exception? originalException,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: code ?? 'STORAGE_ERROR',
    originalException: originalException,
    stackTrace: stackTrace,
  );
}
