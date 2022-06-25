import 'dart:math';

import 'package:flutter/material.dart';

import '/outils/constantes/colors.dart';
import '/outils/extensions/string.dart';
import '/outils/fonctions/fonctions.dart';
import '/outils/size_configs.dart';
import '/providers/theme/elements/main.dart';

errorTag(BuildContext context, String texte) {
  return Row(
    children: [
      Icon(
        Icons.subdirectory_arrow_right,
        size: 20,
      ),
      Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.red, width: 2.0)),
        child: Row(
          children: [
            Icon(
              Icons.error,
              color: Colors.red,
            ),
            Text(
              texte,
              style: ThemeElements(context: context).styleText(
                  fontStyle: FontStyle.italic,
                  color: ThemeElements(context: context, mode: ColorMode.envers)
                      .themeColor),
            ),
          ],
        ),
      ),
    ],
  );
}

enfantsTag(BuildContext context, String texte) {
  return Row(
    children: [
      Icon(
        Icons.linear_scale,
        size: 20,
      ),
      Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: couleurTheme, width: 2.0)),
        child: Text(texte,
            style: ThemeElements(context: context).styleText(
              fontStyle: FontStyle.italic,
              color: ThemeElements(context: context, mode: ColorMode.envers)
                  .themeColor,
            )),
      ),
    ],
  );
}

primaryTag(BuildContext context, dynamic parent) {
  double minL = SizeConfig.safeBlockHorizontal * 15;
  double maxL = SizeConfig.safeBlockHorizontal * 50;

  double largeur = min(minL + 20 * (parent.nom.length / 4), maxL);

  return Row(
    children: [
      Icon(
        Icons.subdirectory_arrow_right,
        size: 20,
      ),
      Container(
        width: largeur,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: (parent.couleur as String).couleurFromHex(),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: couleurTheme, width: 2.0)),
        child: Text((parent.nom as String).upperDebut(),
            overflow: TextOverflow.ellipsis,
            style: ThemeElements(context: context).styleText(
                fontStyle: FontStyle.italic,
                color: blackOrWhite_formLuminance(
                    (parent.couleur as String).couleurFromHex()))),
      ),
    ],
  );
}
