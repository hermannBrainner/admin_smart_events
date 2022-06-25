import 'package:flutter/material.dart';

import '/providers/theme/elements/main.dart';

Widget FlottantBtnNewFilleul(
    BuildContext context, bool isExtended, Function switchPage) {
  VoidCallback onPress = () {
    switchPage();
  };

  Icon icon = Icon(
    Icons.add,
    color: ThemeElements(context: context, mode: ColorMode.endroit).themeColor,
  );
  Widget label = Center(
    child: Text(
      "Nouveau parrainage",
      style: ThemeElements(context: context).styleText(
          fontSize: 15,
          color: ThemeElements(context: context, mode: ColorMode.endroit)
              .themeColor),
    ),
  );
  Color bgdColor = ThemeElements(context: context, mode: ColorMode.envers)
      .themeColorSecondary;

  return AnimatedContainer(
    duration: Duration(milliseconds: 400),
    curve: Curves.linear,
    width: isExtended ? 200 : 50,
    height: 50,
    child: isExtended
        ? FloatingActionButton.extended(
            extendedPadding: EdgeInsets.symmetric(horizontal: 30),
            onPressed: onPress,
            icon: icon,
            label: label,
            backgroundColor: bgdColor,
          )
        : FloatingActionButton(
            onPressed: onPress,
            child: icon,
            backgroundColor: bgdColor,
          ),
  );
}
