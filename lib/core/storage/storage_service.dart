import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _prefs;
  
  StorageService._();
  
  static Future<StorageService> get instance async {
    if (_instance == null) {
      _prefs = await SharedPreferences.getInstance();
      _instance = StorageService._();
    }
    return _instance!;
  }
  
  // String operations
  Future<bool> setString(String key, String value) async {
    return await _prefs!.setString(key, value);
  }
  
  String? getString(String key) {
    return _prefs!.getString(key);
  }
  
  // Bool operations
  Future<bool> setBool(String key, bool value) async {
    return await _prefs!.setBool(key, value);
  }
  
  bool? getBool(String key) {
    return _prefs!.getBool(key);
  }
  
  // Int operations
  Future<bool> setInt(String key, int value) async {
    return await _prefs!.setInt(key, value);
  }
  
  int? getInt(String key) {
    return _prefs!.getInt(key);
  }
  
  // Clear specific key
  Future<bool> remove(String key) async {
    return await _prefs!.remove(key);
  }
  
  // Clear all data
  Future<bool> clear() async {
    return await _prefs!.clear();
  }
  
  // Check if key exists
  bool containsKey(String key) {
    return _prefs!.containsKey(key);
  }
}
