
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
 
  }

  // String değerleri kaydetmek ve almak için
  static Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs.getString(key);
  }

  // int değerleri kaydetmek ve almak için
  static Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  static int? getInt(String key) {
    return _prefs.getInt(key);
  }

  // bool değerleri kaydetmek ve almak için
  static Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  // double değerleri kaydetmek ve almak için
  static Future<bool> setDouble(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }

  static double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  // String listesi değerleri kaydetmek ve almak için
  static Future<bool> setStringList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  static List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  // Bir anahtarı silmek için
  static Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  // Tüm anahtarları silmek için
  static Future<bool> clear() async {
    return await _prefs.clear();
  }

  // Bir anahtarın mevcut olup olmadığını kontrol etmek için
  static bool containsKey(String key) {
    return _prefs.containsKey(key);
  }
}
