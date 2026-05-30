import 'extensions.dart';

class Validators {
  static String? phone(String? value) {
    if (value == null || value.isEmpty) return 'رقم الهاتف مطلوب';
    if (!value.isValidPhone) return 'رقم هاتف غير صحيح';
    return null;
  }

  static String? required(String? value, [String fieldName = 'الحقل']) {
    if (value == null || value.trim().isEmpty) return '$fieldName مطلوب';
    return null;
  }

  static String? price(String? value) {
    if (value == null || value.isEmpty) return 'السعر مطلوب';
    final price = double.tryParse(value);
    if (price == null || price <= 0) return 'سعر غير صحيح';
    return null;
  }

  static String? minLength(String? value, int min,
      [String fieldName = 'الحقل']) {
    if (value == null || value.length < min)
      return '$fieldName يجب أن يكون $min أحرف على الأقل';
    return null;
  }

  static String? maxLength(String? value, int max,
      [String fieldName = 'الحقل']) {
    if (value != null && value.length > max)
      return '$fieldName يجب أن يكون أقل من $max حرف';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'البريد الإلكتروني مطلوب';
    if (!value.isValidEmail) return 'بريد إلكتروني غير صحيح';
    return null;
  }
}
