import 'package:flutter/material.dart';

import '/mode_Compte/home/components/menu_items.dart';
import '/outils/size_configs.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/strings.dart';

Widget ChapeauHome(BuildContext context, {required String itemPage}) {
  String? texte;
  late double hauteur;

  switch (itemPage) {
    case ItemMenuHome.ceremonie:
      texte = Strings.infoBulleDetails;
      hauteur = SizeConfig.blockSizeVertical * 15; // hauteur = 80;
      break;
    case ItemMenuHome.salle:
      texte = Strings.infoBulleDispositions;
      hauteur = SizeConfig.blockSizeVertical * 22; //  hauteur = 120;
      break;

    case ItemMenuHome.use:
      texte = Strings.infoBulleConnexion;
      hauteur = SizeConfig.blockSizeVertical * 15; // hauteur = 120;
      break;
    case ItemMenuHome.billets:
      texte = "";
      hauteur = SizeConfig.blockSizeVertical * 5; //   hauteur = 40;
      break;
    case ItemMenuHome.autres:
      texte = "";
      hauteur = SizeConfig.blockSizeVertical * 5; // hauteur = 40;
      break;
  }

  return Container(
    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    height: hauteur,
    decoration: BoxDecoration(
        color: ThemeElements(context: context).whichBlue,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(40), topLeft: Radius.circular(40))),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Visibility(
          visible:
              ![ItemMenuHome.billets, ItemMenuHome.autres].contains(itemPage),
          child: Icon(
            Icons.info,
            color: ThemeElements(context: context, mode: ColorMode.endroit)
                .themeColor,
            size: SizeConfig.safeBlockHorizontal * 6,
          ),
        ),
        SizedBox(
          width: SizeConfig.safeBlockHorizontal * 6,
        ),
        Expanded(
            child: Text(
          texte!,
          textAlign: TextAlign.justify,
          overflow: TextOverflow.clip,
          maxLines: 6,
          style: ThemeElements(context: context).styleText(
              color: ThemeElements(context: context, mode: ColorMode.endroit)
                  .themeColor,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
              fontSize: SizeConfig.safeBlockHorizontal * 4),
        ))
      ],
    ),
  );
}
