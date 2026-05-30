// lib/core/data/services/storage_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _prefs;

  StorageService._();

  static Future<StorageService> getInstance() async {
    _instance ??= StorageService._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  Future<bool> isLoggedIn() async {
    return _prefs?.getBool('isLoggedIn') ?? false;
  }

  Future<void> setLoggedIn(bool value) async {
    await _prefs?.setBool('isLoggedIn', value);
  }

  Future<bool> isOnboardingSeen() async {
    return _prefs?.getBool('onboardingSeen') ?? false;
  }

  Future<void> setOnboardingSeen() async {
    await _prefs?.setBool('onboardingSeen', true);
  }

  Future<void> saveUserData(
      {required String userId, required String phone, String? name}) async {
    await _prefs?.setString('userId', userId);
    await _prefs?.setString('phone', phone);
    if (name != null) await _prefs?.setString('name', name);
  }

  Future<Map<String, String?>> getUserData() async {
    return {
      'userId': _prefs?.getString('userId'),
      'phone': _prefs?.getString('phone'),
      'name': _prefs?.getString('name'),
    };
  }

  Future<void> logout() async {
    await _prefs?.setBool('isLoggedIn', false);
    await _prefs?.remove('userId');
    await _prefs?.remove('phone');
    await _prefs?.remove('name');
  }
}
