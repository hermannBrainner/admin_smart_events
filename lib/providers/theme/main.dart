import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constantes.dart';

enum ColorMode { endroit, envers }

Color themeColor(BuildContext context, ColorMode mode) {
  switch (mode) {
    case ColorMode.endroit:
      return MediaQuery.of(context).platformBrightness == Brightness.light
          ? kColorWhitePrimary
          : kColorBlackPrimary;
    case ColorMode.envers:
      return MediaQuery.of(context).platformBrightness == Brightness.light
          ? kColorBlackPrimary
          : kColorWhitePrimary;
  }
}

Color themeColorSecondary(BuildContext context,
    {ColorMode mode = ColorMode.endroit}) {
  if (mode == ColorMode.endroit) {
    return MediaQuery.of(context).platformBrightness == Brightness.light
        ? kColorWhiteSecondary
        : kColorBlackSecondary;
  } else {
    return MediaQuery.of(context).platformBrightness == Brightness.dark
        ? kColorWhiteSecondary
        : kColorBlackSecondary;
  }
}

ThemeData lightThemeData(BuildContext context) {
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
    iconTheme: IconThemeData(color: kColorBlackPrimary),
    textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
        .apply(bodyColor: kColorBlackPrimary),
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

ThemeData darkThemeData(BuildContext context) {
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
    textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
        .apply(bodyColor: kColorWhitePrimary),
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

final appBarTheme = AppBarTheme(centerTitle: false, elevation: 0);
