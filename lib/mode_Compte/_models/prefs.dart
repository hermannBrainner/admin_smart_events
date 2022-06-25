import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static Future<SharedPreferences> get instance async {
    return await SharedPreferences.getInstance();
  }

  static Future<Map<String, int?>> getInts(List<String> keys) async {
    SharedPreferences preferences = await instance;
    var data = Map<String, int?>();
    keys.forEach((key) {
      data[key] = preferences.getInt(key);
    });

    return data;
  }

  static setInts(Map<String, int?> data) async {
    SharedPreferences preferences = await instance;
    data.forEach((key, value) async {
      await preferences.setInt(key, value ?? 0);
    });
    return data;
  }

  static Future<String> getString(
      {required String key, required String defaut}) async {
    return (await instance).getString(key) ?? defaut;
  }

  static setString({required String key, required String value}) async {
    return (await instance).setString(key, value);
  }
}
