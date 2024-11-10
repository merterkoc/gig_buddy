import 'package:shared_preferences/shared_preferences.dart';

class Shared {
  late SharedPreferences _preferences;

  static final Shared _instance = Shared._();

  factory Shared() => _instance;

  Shared._();

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<void> setInt(String key, int value) async {
    await _preferences.setInt(key, value);
  }

  Future<int?> getInt(String key) async {
    return _preferences.getInt(key);
  }

  void remove(String key) {
    _preferences.remove(key);
  }
}
