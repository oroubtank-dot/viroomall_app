// lib/core/services/storage_service.dart
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
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _sellerActivatedKey = 'seller_activated';
  static const String _walletBalanceKey = 'wallet_balance';
  static const String _firstHomeVisitKey = 'first_home_visit';
  static const String _sellerVerifiedKey = 'seller_verified';
  static const String _sellerVerifiedBadgeKey = 'seller_badge';

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

  static Future<void> setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingSeenKey, true);
  }

  static Future<bool> isOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingSeenKey) ?? false;
  }

  // =============================================
  // Biometric Methods
  // =============================================

  static Future<void> setBiometricEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricEnabledKey, enabled);
  }

  static Future<bool> isBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_biometricEnabledKey) ?? false;
  }

  // =============================================
  // Authentication Methods
  // =============================================

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

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<Map<String, String?>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'userId': prefs.getString(_userIdKey),
      'phone': prefs.getString(_userPhoneKey),
      'name': prefs.getString(_userNameKey),
    };
  }

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

  static Future<void> setSelectedMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedModeKey, mode);
  }

  static Future<String> getSelectedMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedModeKey) ?? 'shopping';
  }

  static Future<void> setDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isDarkModeKey, isDark);
  }

  static Future<bool> isDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isDarkModeKey) ?? true;
  }

  static Future<void> setLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language);
  }

  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'ar';
  }

  // =============================================
  // Seller Activation Methods
  // =============================================

  static Future<void> setSellerActivated(bool activated) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_sellerActivatedKey, activated);
  }

  static Future<bool> isSellerActivated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_sellerActivatedKey) ?? false;
  }

  // =============================================
  // First Home Visit (بانر تفعيل البائع)
  // =============================================

  static Future<void> setFirstHomeVisitDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstHomeVisitKey, true);
  }

  static Future<bool> isFirstHomeVisit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_firstHomeVisitKey) ?? true;
  }

  // =============================================
  // Wallet Methods
  // =============================================

  static Future<void> setWalletBalance(double balance) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_walletBalanceKey, balance);
  }

  static Future<double> getWalletBalance() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_walletBalanceKey) ?? 0.0;
  }

  // =============================================
  // Seller Verification Methods
  // =============================================

  static Future<void> setSellerVerified(bool verified) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_sellerVerifiedKey, verified);
  }

  static Future<bool> isSellerVerified() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_sellerVerifiedKey) ?? false;
  }

  // =============================================
  // Clear All Data
  // =============================================
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
