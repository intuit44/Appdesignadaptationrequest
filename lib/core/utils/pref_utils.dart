import 'package:shared_preferences/shared_preferences.dart';

// ignore_for_file: must_be_immutable
class PrefUtils {
  PrefUtils();

  static SharedPreferences? _sharedPreferences;

  Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  /// Will clear all the data stored in preference
  Future<void> clearPreferencesData() async {
    if (_sharedPreferences != null) {
      await _sharedPreferences!.clear();
    }
  }

  Future<void> setThemeData(String value) async {
    if (_sharedPreferences == null) {
      await init();
    }
    await _sharedPreferences!.setString('themeData', value);
  }

  String getThemeData() {
    try {
      return _sharedPreferences?.getString('themeData') ?? 'primary';
    } catch (e) {
      return 'primary';
    }
  }
}
