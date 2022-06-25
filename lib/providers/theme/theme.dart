import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constantes.dart';

class Themes {
  final bool isLigth;

  Themes({required this.isLigth});

  ThemeData get themeData {
    if (isLigth) {
      return light();
    } else {
      return dark();
    }
  }

  static ThemeData light() {
    return ThemeData.light().copyWith(
      primaryColor: kColorBlackPrimary,
      cardColor: kColorWhiteSecondary,
      scaffoldBackgroundColor: kColorWhitePrimary,
      tabBarTheme: TabBarTheme(
        labelColor: kColorWhitePrimary,
        unselectedLabelColor: kColorBlackPrimary,
        indicator: BoxDecoration(color: kPrimaryColorLightTheme),
      ),
      appBarTheme: AppBarTheme(
          titleTextStyle: GoogleFonts.inter(
              color: kColorBlackPrimary,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold,
              fontSize: 20),
          backgroundColor: kColorWhitePrimary,
          centerTitle: false,
          elevation: 0),
      inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(fontStyle: FontStyle.italic),
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          border: OutlineInputBorder()),
      iconTheme: IconThemeData(color: kColorBlackPrimary),
      //  textTheme: TextTheme(),

      //     textTheme : GoogleFonts.interTextTheme(Theme.of(NavigationService.navigatorKey.currentContext!).textTheme).apply(bodyColor: kColorBlackPrimary),

      textTheme: TextTheme(
        headline1: TextStyle(
            color: kColorBlackPrimary,
            fontSize: 72.0,
            fontWeight: FontWeight.bold),
        headline6: TextStyle(
            color: kColorBlackPrimary,
            fontSize: 36.0,
            fontStyle: FontStyle.italic),
        bodyText2: TextStyle(
            color: kColorBlackPrimary, fontSize: 14.0, fontFamily: 'Hind'),
      ),
      colorScheme: ColorScheme.light(
        primary: kPrimaryColorLightTheme,
        secondary: kPrimaryColorLightTheme,
        error: kErrorColor,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: kColorWhitePrimary,
        selectedItemColor: kColorBlackPrimary.withOpacity(0.7),
        unselectedItemColor: kColorBlackPrimary.withOpacity(0.32),
        selectedIconTheme: IconThemeData(color: kPrimaryColorLightTheme),
        showUnselectedLabels: true,
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData.dark().copyWith(
      primaryColor: kColorBlackPrimary,
      cardColor: kColorBlackSecondary,
      scaffoldBackgroundColor: kColorBlackPrimary,
      tabBarTheme: TabBarTheme(
        labelColor: kColorBlackPrimary,
        unselectedLabelColor: kColorWhitePrimary,
        indicator: BoxDecoration(color: kPrimaryColorDarkTheme),
      ),
      appBarTheme: AppBarTheme(
          titleTextStyle: GoogleFonts.inter(
              color: kColorWhitePrimary,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold,
              fontSize: 20),
          backgroundColor: kColorBlackPrimary,
          centerTitle: false,
          elevation: 0),
      iconTheme: IconThemeData(color: kColorWhitePrimary),
      textTheme: TextTheme(
        headline1: TextStyle(
            color: kColorWhitePrimary,
            fontSize: 72.0,
            fontWeight: FontWeight.bold),
        headline6: TextStyle(
            color: kColorWhitePrimary,
            fontSize: 36.0,
            fontStyle: FontStyle.italic),
        bodyText2: TextStyle(
            color: kColorWhitePrimary, fontSize: 14.0, fontFamily: 'Hind'),
      ),
      colorScheme: ColorScheme.dark().copyWith(
        primary: kPrimaryColorDarkTheme,
        secondary: kPrimaryColorDarkTheme,
        error: kErrorColor,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: kColorBlackPrimary,
        selectedItemColor: kColorBlackPrimary,
        unselectedItemColor: kColorWhitePrimary.withOpacity(0.32),
        selectedIconTheme: IconThemeData(color: kPrimaryColorDarkTheme),
        showUnselectedLabels: true,
      ),
    );
  }
}
