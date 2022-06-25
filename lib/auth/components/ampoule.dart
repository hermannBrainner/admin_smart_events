import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/providers/theme.dart';

ampoule() {
  return Consumer<ThemeProvider>(builder: (context, theme, _) {
    return Transform.scale(
      scale: 2.0,
      child: Switch(
        // splashRadius: 50,
        value: theme.themeData.brightness == Brightness.light,
        onChanged: (value) {
          theme.upDateTheme(!(theme.themeData.brightness == Brightness.light));
        },
        activeTrackColor: Colors.lightGreenAccent,
        activeColor: Colors.green,
      ),
    );
  });
}
