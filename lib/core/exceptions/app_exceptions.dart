// lib/core/exceptions/app_exceptions.dart

/// =============================================
/// استثناءات التطبيق المخصصة
/// =============================================

/// الاستثناء الأساسي
class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, {this.code});

  @override
  String toString() => message;
}

/// خطأ في الاتصال بالإنترنت
class NetworkException extends AppException {
  NetworkException() : super('لا يوجد اتصال بالإنترنت', code: 'NETWORK_ERROR');
}

/// خطأ في المصادقة (تسجيل الدخول)
class AuthException extends AppException {
  AuthException(String message) : super(message, code: 'AUTH_ERROR');
}

/// خطأ في Firebase
class FirebaseException extends AppException {
  FirebaseException(String message) : super(message, code: 'FIREBASE_ERROR');
}

/// المنتج غير موجود
class ProductNotFoundException extends AppException {
  ProductNotFoundException()
      : super('المنتج غير موجود', code: 'PRODUCT_NOT_FOUND');
}

/// خطأ في الدفع
class PaymentException extends AppException {
  PaymentException(String message) : super(message, code: 'PAYMENT_ERROR');
}

/// غير مصرح به
class UnauthorizedException extends AppException {
  UnauthorizedException()
      : super('غير مصرح به، الرجاء تسجيل الدخول', code: 'UNAUTHORIZED');
}
