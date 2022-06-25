import 'package:flutter/material.dart';

import '/mode_Compte/listes/main.dart';
import '/mode_Compte/stats/main.dart';
import '/mode_Compte/verification/home.dart';
import '/outils/size_configs.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/strings.dart';
import '../items/installation.dart';

Widget blockInvite(
  BuildContext context, {
  required double coef,
  required double coefText,
}) {
  return Column(
    children: [
      Divider(color: Colors.black, height: SizeConfig.safeBlockVertical * coef),
      ListTile(
          leading: Icon(
            Icons.location_searching_sharp,
            color: ThemeElements(context: context).iconColorDrawer,
            size: SizeConfig.safeBlockVertical * coef,
          ),
          title: Text(
            Strings.menuVerif,
            style: ThemeElements(context: context)
                .styleText(fontSize: SizeConfig.safeBlockVertical * coefText),
          ),
          onTap: () => {Navigator.pushNamed(context, VerifMain.routeName)}),
      ListTile(
          leading: Icon(
            Icons.list_alt_outlined,
            color: ThemeElements(context: context).iconColorDrawer,
            size: SizeConfig.safeBlockVertical * coef,
          ),
          title: Text(
            Strings.menuListeInv,
            style: ThemeElements(context: context)
                .styleText(fontSize: SizeConfig.safeBlockVertical * coefText),
          ),
          onTap: () =>
              {Navigator.pushNamed(context, ListesMainView.routeName)}),
      itemInstallations(context, coef, coefText,
          ThemeElements(context: context).iconColorDrawer),
      ListTile(
          leading: Icon(
            Icons.query_stats,
            color: ThemeElements(context: context).iconColorDrawer,
            size: SizeConfig.safeBlockVertical * coef,
          ),
          title: Text(
            Strings.menuStats,
            style: ThemeElements(context: context)
                .styleText(fontSize: SizeConfig.safeBlockVertical * coefText),
          ),
          onTap: () => {Navigator.pushNamed(context, StatsMainView.routeName)}),
    ],
  );
}
