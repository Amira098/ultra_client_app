import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {
  static SharedPreferences? _sharedPreferences;
  static bool _isInitialized = false;

  static SharedPreferences get sharedPreferences {
    if (!_isInitialized) {
      throw Exception('SharedPreferencesUtils has not been initialized. Call init() first.');
    }
    return _sharedPreferences!;
  }

  static Future<void> init() async {
    if (!_isInitialized) {
      _sharedPreferences = await SharedPreferences.getInstance();
      _isInitialized = true;
    }
  }

  static Future<bool> saveData({required String key, required dynamic value}) async {
    if (!_isInitialized) await init();

    if (value is int) return _sharedPreferences!.setInt(key, value);
    if (value is double) return _sharedPreferences!.setDouble(key, value);
    if (value is bool) return _sharedPreferences!.setBool(key, value);
    return _sharedPreferences!.setString(key, value.toString());
  }

  static Future<bool> removeData({required String key}) async {
    if (!_isInitialized) await init();
    return _sharedPreferences!.remove(key);
  }

  static Object? getData({required String key}) {
    if (!_isInitialized) {
      throw Exception('SharedPreferencesUtils has not been initialized. Call init() first.');
    }
    return _sharedPreferences!.get(key);
  }

  static Future<String?> getString(String key) async {
    if (!_isInitialized) await init();
    return _sharedPreferences!.getString(key);
  }

  static Future<bool> saveJson(String key, Map<String, dynamic> json) async {
    if (!_isInitialized) await init();
    return _sharedPreferences!.setString(key, jsonEncode(json));
  }

  static Map<String, dynamic>? getJson(String key) {
    if (!_isInitialized) {
      throw Exception('SharedPreferencesUtils has not been initialized. Call init() first.');
    }
    final raw = _sharedPreferences!.getString(key);
    if (raw == null || raw.isEmpty) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static String? getStringSync(String key) {
    if (!_isInitialized) {
      throw Exception('SharedPreferencesUtils has not been initialized. Call init() first.');
    }
    return _sharedPreferences!.getString(key);
  }

  static bool? getBoolSync(String key) {
    if (!_isInitialized) {
      throw Exception('SharedPreferencesUtils has not been initialized. Call init() first.');
    }
    return _sharedPreferences!.getBool(key);
  }

  static int? getIntSync(String key) {
    if (!_isInitialized) {
      throw Exception('SharedPreferencesUtils has not been initialized. Call init() first.');
    }
    return _sharedPreferences!.getInt(key);
  }
}