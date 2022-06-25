import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '/providers/theme.dart';
import '../constantes.dart';

enum ColorMode { endroit, envers }

class ThemeElements {
  late ColorMode? mode;

  final BuildContext context;

  ThemeElements({
    required this.context,
    this.mode,
  });

  Color get iconColorDrawer {
    return whichBlue;
  }

  Color get whichBlue {
    mode = mode ?? ColorMode.endroit;

    if (mode == ColorMode.endroit) {
      return provider.themeData.brightness == Brightness.light
          ? kPrimaryColorLightTheme
          : kPrimaryColorDarkTheme;
    } else {
      return provider.themeData.brightness == Brightness.dark
          ? kPrimaryColorLightTheme
          : kPrimaryColorDarkTheme;
    }
  }

  ThemeProvider get provider {
    return Provider.of<ThemeProvider>(context, listen: false);
  }

  TextStyle styleText(
      {TextDecoration? decoration,
      double? fontSize,
      Color? color,
      FontStyle fontStyle = FontStyle.normal,
      FontWeight fontWeight = FontWeight.normal}) {
    mode = ColorMode.envers;
    Color _color = color ?? themeColor;
    double _fontSize = fontSize ?? 12;
    var style = TextStyle(
        decoration: decoration,
        color: _color,
        fontSize: _fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle);

    return GoogleFonts.inter(textStyle: style);
  }

  TextStyle get styleTextFieldTheme {
    mode = ColorMode.envers;
    return GoogleFonts.inter().apply(color: themeColor);
  }

  Color get themeColorSecondary {
    mode = mode ?? ColorMode.endroit;

    if (mode == ColorMode.endroit) {
      return provider.themeData.brightness == Brightness.light
          ? kColorWhiteSecondary
          : kColorBlackSecondary;
    } else {
      return provider.themeData.brightness == Brightness.dark
          ? kColorWhiteSecondary
          : kColorBlackSecondary;
    }
  }

  Color get themeColor {
    switch (mode) {
      case ColorMode.endroit:
        return provider.themeData.brightness == Brightness.light
            ? kColorWhitePrimary
            : kColorBlackPrimary;

      case ColorMode.envers:
        return provider.themeData.brightness == Brightness.light
            ? kColorBlackPrimary
            : kColorWhitePrimary;

      default:
        return kColorBlackPrimary;
    }
  }
}
