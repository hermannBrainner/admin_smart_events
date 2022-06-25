import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '..../../../providers/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData themeData = Themes(
          isLigth: MediaQueryData.fromWindow(WidgetsBinding.instance!.window)
                  .platformBrightness ==
              Brightness.light)
      .themeData;

  Future<ThemeData> currentTheme(BuildContext context) async {
    return Themes(isLigth: await ThemePreference.getTheme()).themeData;
  }

  upDateTheme(bool value) {
    themeData = Themes(isLigth: value).themeData;
    ThemePreference.setTheme(value);
    notifyListeners();
  }
}

class ThemePreference {
  static const THEME_STATUS = "THEMESTATUS";

  static setTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_STATUS, value);
  }

  static Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getBool(THEME_STATUS) == null) {
      return MediaQueryData.fromWindow(WidgetsBinding.instance!.window)
              .platformBrightness ==
          Brightness.light;
    }

    return prefs.getBool(THEME_STATUS) ?? false;
  }
}
