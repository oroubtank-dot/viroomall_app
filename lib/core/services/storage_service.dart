import 'package:shared_preferences/shared_preferences.dart';

/// =============================================
/// خدمة التخزين المحلي (الذاكرة)
/// =============================================
class StorageService {
  // =============================================
  // Keys
  // =============================================
  static const String _onboardingSeenKey = 'onboarding_seen';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userIdKey = 'user_id';
  static const String _userPhoneKey = 'user_phone';
  static const String _userNameKey = 'user_name';
  static const String _selectedModeKey = 'selected_mode';
  static const String _isDarkModeKey = 'is_dark_mode';
  static const String _languageKey = 'language';

  // =============================================
  // Singleton Pattern
  // =============================================
  static StorageService? _instance;
  static SharedPreferences? _prefs;

  static Future<StorageService> getInstance() async {
    _instance ??= StorageService();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // =============================================
  // Onboarding Methods
  // =============================================

  /// حفظ إن المستخدم شاف الـ Onboarding
  static Future<void> setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingSeenKey, true);
  }

  /// التأكد هل شاف الـ Onboarding قبل كده ولا لأ
  static Future<bool> isOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingSeenKey) ?? false;
  }

  // =============================================
  // Authentication Methods
  // =============================================

  /// حفظ حالة تسجيل الدخول
  static Future<void> setLoggedIn({
    required String userId,
    required String phone,
    String? name,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_userPhoneKey, phone);
    if (name != null) {
      await prefs.setString(_userNameKey, name);
    }
  }

  /// التحقق من حالة تسجيل الدخول
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  /// الحصول على بيانات المستخدم
  static Future<Map<String, String?>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'userId': prefs.getString(_userIdKey),
      'phone': prefs.getString(_userPhoneKey),
      'name': prefs.getString(_userNameKey),
    };
  }

  /// تسجيل الخروج
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userPhoneKey);
    await prefs.remove(_userNameKey);
  }

  // =============================================
  // App Settings Methods
  // =============================================

  /// حفظ وضع التصفح المختار
  static Future<void> setSelectedMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedModeKey, mode);
  }

  /// الحصول على وضع التصفح المختار
  static Future<String> getSelectedMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedModeKey) ?? 'shopping';
  }

  /// حفظ حالة الوضع الليلي
  static Future<void> setDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isDarkModeKey, isDark);
  }

  /// الحصول على حالة الوضع الليلي
  static Future<bool> isDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isDarkModeKey) ?? true;
  }

  /// حفظ اللغة المختارة
  static Future<void> setLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language);
  }

  /// الحصول على اللغة المختارة
  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'ar';
  }

  // =============================================
  // Clear All Data
  // =============================================
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
