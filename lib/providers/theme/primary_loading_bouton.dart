import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/outils/size_configs.dart';
import 'constantes.dart';
import 'elements/main.dart';

class PrimaryLoadingButton extends StatelessWidget {
  const PrimaryLoadingButton({
    required this.text,
    required this.press,
    this.rayonBord = 40,
    this.padding = const EdgeInsets.all(kDefaultPadding * 0.75),
    required this.btnCtrl,
    this.color,
  });

  final Color? color;
  final double rayonBord;
  final String text;
  final VoidCallback press;
  final EdgeInsets padding;
  final RoundedLoadingButtonController btnCtrl;

  @override
  Widget build(BuildContext context) {
    final provider = ThemeElements(context: context).provider;
    return Padding(
      padding: padding,
      child: RoundedLoadingButton(
        borderRadius: rayonBord,
        color: color ?? Theme.of(context).colorScheme.primary,
        onPressed: press,
        controller: btnCtrl,
        child: Text(
          text,
          style: ThemeElements(context: context).styleText(
            fontSize: SizeConfig.safeBlockHorizontal * 4,
            fontWeight: FontWeight.bold,
            color: provider.themeData.brightness == Brightness.light
                ? kColorWhitePrimary
                : kColorBlackPrimary,
          ),
        ),
      ),
    );
  }
}
