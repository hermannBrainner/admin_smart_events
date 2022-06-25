import 'package:flutter/material.dart';

import '/mode_Compte/_models/billet.dart';
import '/mode_Compte/_models/table.dart';
import '/mode_Compte/_models/zone.dart';
import '/mode_Compte/listes/tiles.dart';
import '/outils/extensions/string.dart';
import '/outils/fonctions/fonctions.dart';
import '/outils/size_configs.dart';
import '/providers/theme/primary_box_decoration.dart';

double largeurCadre = SizeConfig.safeBlockHorizontal * 25;
double hauteurCadre = SizeConfig.safeBlockVertical * 5;

zoneEtTable(BuildContext context, Zone? zone, TableInvite? table) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.max,
    children: [
      if (!isNullOrEmpty(table))
        uneCard(context, table!.couleur.couleurFromHex(), hauteurCadre,
            largeurCadre, table.nom.toUpperCase()),
      if (!isNullOrEmpty(zone))
        uneCard(context, zone!.couleur.couleurFromHex(), hauteurCadre,
            largeurCadre, zone.nom.toUpperCase()),
    ],
  );
}

Widget billetTile(
    Billet billet, TableInvite? table, Zone? zone, BuildContext context) {
  return Card(
    margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.safeBlockHorizontal * 2,
        vertical: SizeConfig.safeBlockVertical * 1),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    elevation: SizeConfig.safeBlockVertical,
    child: Container(
      decoration: BoxDecorationPrimary(context,
          topRigth: 20, topLeft: 20, bottomRigth: 20, bottomLeft: 20),
      height: SizeConfig.safeBlockVertical * 14,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
              width: SizeConfig.blockSizeHorizontal * 15,
              alignment: Alignment.center,
              child: avatar(
                  billet: billet, radius: SizeConfig.blockSizeHorizontal * 5)),
          Container(
            width: SizeConfig.blockSizeHorizontal * 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  billet.nom,
                  style: TextStyle(
                      fontSize: SizeConfig.safeBlockVertical * 2.5,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 2,
                ),
                zoneEtTable(context, zone, table)
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
