import 'package:flutter/material.dart';

import 'constantes.dart';
import 'elements/main.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    this.fontSize,
    required this.text,
    required this.press,
    this.isBold = false,
    this.rayonBord = 40,
    this.color,
    this.padding = const EdgeInsets.all(kDefaultPadding * 0.75),
  });

  final Color? color;
  final double? fontSize;
  final double rayonBord;
  final String text;
  final VoidCallback press;
  final EdgeInsets padding;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    final provider = ThemeElements(context: context).provider;
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(rayonBord)),
      ),
      padding: padding,
      color: color ?? Theme.of(context).colorScheme.primary,
      minWidth: double.infinity,
      onPressed: press,
      child: Text(
        text,
        style: ThemeElements(context: context).styleText(
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: provider.themeData.brightness == Brightness.light
              ? kColorWhitePrimary
              : kColorBlackPrimary,
        ),
      ),
    );
  }
}
