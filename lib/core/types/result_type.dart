// lib/core/types/result_type.dart
import '../exceptions/app_exception.dart';

/// 🎯 Result Type (Either Pattern)
/// لتمثيل نتيجة العملية (نجاح أو فشل)
abstract class Result<T> {
  const Result();

  /// تطبيق دالة على النتيجة
  R map<R>({
    required R Function(T success) onSuccess,
    required R Function(AppException failure) onFailure,
  });

  /// الحصول على القيمة أو null
  T? getOrNull();

  /// الحصول على الخطأ أو null
  AppException? getErrorOrNull();
}

/// ✅ Success Result
class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  R map<R>({
    required R Function(T success) onSuccess,
    required R Function(AppException failure) onFailure,
  }) {
    return onSuccess(data);
  }

  @override
  T? getOrNull() => data;

  @override
  AppException? getErrorOrNull() => null;
}

/// ❌ Failure Result
class Failure<T> extends Result<T> {
  final AppException exception;

  const Failure(this.exception);

  @override
  R map<R>({
    required R Function(T success) onSuccess,
    required R Function(AppException failure) onFailure,
  }) {
    return onFailure(exception);
  }

  @override
  T? getOrNull() => null;

  @override
  AppException? getErrorOrNull() => exception;
}

/// Extension methods
extension<T> on Result<T> {
  /// التحقق من كون النتيجة نجاح
  bool get isSuccess => this is Success<T>;

  /// التحقق من كون النتيجة فشل
  bool get isFailure => this is Failure<T>;

  /// Cast to Success (استخدم بحذر!)
  Success<T> get asSuccess => this as Success<T>;

  /// Cast to Failure (استخدم بحذر!)
  Failure<T> get asFailure => this as Failure<T>;
}
