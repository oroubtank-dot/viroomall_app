// lib/core/utils/helpers.dart
import 'package:intl/intl.dart';

/// =============================================
/// دوال مساعدة عامة
/// =============================================

class AppHelpers {
  /// تنسيق السعر بالجنيه المصري
  static String formatPrice(double price) {
    final formatter = NumberFormat.currency(
      symbol: 'ج.م',
      decimalDigits: 2,
      locale: 'ar_EG',
    );
    return formatter.format(price);
  }

  /// اختصار النص إذا كان طويلاً
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// التحقق من صحة رقم الهاتف المصري
  static bool isValidEgyptianPhone(String phone) {
    final regex = RegExp(r'^(01)[0-9]{9}$');
    return regex.hasMatch(phone);
  }

  /// حساب نسبة الخصم
  static int? calculateDiscount(double originalPrice, double currentPrice) {
    if (originalPrice > currentPrice) {
      return ((originalPrice - currentPrice) / originalPrice * 100).round();
    }
    return null;
  }

  /// الحصول على اسم الوضع بالعربي
  static String getModeArabicName(String mode) {
    switch (mode) {
      case 'new':
        return 'تسوق';
      case 'wholesale':
        return 'جملة';
      case 'used':
        return 'مستعمل';
      case 'outlet':
        return 'تخفيضات';
      default:
        return 'تسوق';
    }
  }

  /// الحصول على أيقونة الوضع
  static String getModeIcon(String mode) {
    switch (mode) {
      case 'new':
        return '🛍️';
      case 'wholesale':
        return '🏪';
      case 'used':
        return '♻️';
      case 'outlet':
        return '🔥';
      default:
        return '🛍️';
    }
  }
}
