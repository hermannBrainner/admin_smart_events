import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import '/mode_Compte/_models/billet.dart';
import '/mode_Compte/_models/table.dart';
import '/mode_Compte/_models/zone.dart';
import '/mode_Compte/listes/tiles.dart';
import '/outils/constantes/colors.dart';
import '/outils/extensions/string.dart';
import '/outils/fonctions/fonctions.dart';
import '/outils/size_configs.dart';
import '/outils/widgets/main.dart';
import '/providers/theme/elements/main.dart';

class ligneBillet extends StatelessWidget {
  Billet? billet;
  TableInvite? table;
  Zone? zone;

  ligneBillet({this.billet, this.table, this.zone});

  ExpandableThemeData leTheme() {
    return const ExpandableThemeData(
      headerAlignment: ExpandablePanelHeaderAlignment.center,
      tapBodyToExpand: true,
      tapBodyToCollapse: true,
      hasIcon: false,
    );
  }

  zoneEtTable(BuildContext context, Zone? zone, TableInvite? table) {
    if (isNullOrEmpty(table) && isNullOrEmpty(zone)) {
      return Center();
    } else if (!isNullOrEmpty(table) && !isNullOrEmpty(zone)) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          uneCard(
              context,
              table!.couleur.couleurFromHex(),
              SizeConfig.safeBlockVertical * 5,
              SizeConfig.safeBlockHorizontal * 35,
              "Table : " + table.nom.toUpperCase()),
          uneCard(
              context,
              zone!.couleur.couleurFromHex(),
              SizeConfig.safeBlockVertical * 5,
              SizeConfig.safeBlockHorizontal * 35,
              "Zone : " + zone.nom.toUpperCase())
        ],
      );
    } else if (!isNullOrEmpty(table)) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          uneCard(
              context,
              table!.couleur.couleurFromHex(),
              SizeConfig.safeBlockVertical * 5,
              SizeConfig.safeBlockHorizontal * 35,
              "Table : " + table.nom.toUpperCase()),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          uneCard(
              context,
              zone!.couleur.couleurFromHex(),
              SizeConfig.safeBlockVertical * 5,
              SizeConfig.safeBlockHorizontal * 35,
              "Zone : " + zone.nom.toUpperCase())
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ScrollOnExpand(
            child: ExpandablePanel(
          collapsed: Center(),
          theme: leTheme(),
          header: Container(
            color: couleurBleue, //Colors.indigoAccent,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  flecheExpension(),
                  avatar(
                      billet: billet!,
                      radius: SizeConfig.blockSizeHorizontal * 5),
                  SizedBox(
                    width: SizeConfig.blockSizeHorizontal * 5,
                  ),
                  Expanded(
                      child: Text(
                    billet!.nom,
                    style: ThemeElements(context: context).styleText(
                        color: dWhite,
                        fontSize: SizeConfig.blockSizeHorizontal * 5),
                  ))
                ],
              ),
            ),
          ),
          expanded: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (billet!.estArrive)
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 2,
                  ),
                if (billet!.estArrive)
                  Row(
                    children: [
                      SizedBox(
                        width: SizeConfig.blockSizeHorizontal * 5,
                      ),
                      Icon(
                        Icons.watch_later_outlined,
                        size: SizeConfig.safeBlockVertical * 4,
                      ),
                      SizedBox(
                        width: SizeConfig.blockSizeHorizontal * 5,
                      ),
                      Expanded(
                          child: Text(billet!.dateArrivee(),
                              style: ThemeElements(context: context).styleText(
                                  fontSize: SizeConfig.safeBlockVertical * 2)))
                    ],
                  ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 2,
                ),
                zoneEtTable(context, zone, table)
              ],
            ),
          ),
        )),
      ),
    );
  }
}
