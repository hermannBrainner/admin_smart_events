import 'package:flutter/material.dart';

import '/outils/size_configs.dart';
import '/outils/widgets/main.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/strings.dart';

enum ElementDetails { Lieu, Nbre, Titre, Jour, Heure }

getInfoBulle(String paramsType, BuildContext context) {
  late String texte;
  switch (paramsType) {
    case Strings.paramsDetails:
      texte = Strings.infoBulleDetails;
      break;
    case Strings.paramsConnexion:
      texte = Strings.infoBulleConnexion;
      break;
    case Strings.paramsDispositions:
      texte = Strings.infoBulleDispositions;
      break;
    case Strings.paramsQrCodes:
      texte = Strings.infoBulleQrCodes;
      break;
  }

  return infoBulle(texte, context);
}

Widget wTritre(String titre, BuildContext context) {
  return Column(
    children: [
      SizedBox(height: SizeConfig.safeBlockVertical * 5),
      Center(
          child: Text(titre,
              style: TextStyle(
                  color: ThemeElements(context: context, mode: ColorMode.envers)
                      .themeColor,
                  fontSize: SizeConfig.safeBlockVertical * 2,
                  fontWeight: FontWeight.bold))),
      SizedBox(height: SizeConfig.safeBlockVertical * 5),
    ],
  );
}
