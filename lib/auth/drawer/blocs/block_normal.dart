import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/mode_Compte/exports/main.dart';
import '/mode_Compte/home/main.dart';
import '/mode_Compte/imports/main.dart';
import '/outils/size_configs.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/strings.dart';
import '../items/dispositions.dart';

Widget blockNormal(
  BuildContext context, {
  required bool isInvite,
  required double coef,
  required double coefText,
}) {
  if (!isInvite) {
    return Column(
      children: [
        ListTile(
            leading: Icon(
              Icons.home,
              color: ThemeElements(context: context).iconColorDrawer,
              size: SizeConfig.safeBlockVertical * coef,
            ),
            title: Text(
              Strings.menuAccueil,
              style: ThemeElements(context: context)
                  .styleText(fontSize: SizeConfig.safeBlockVertical * coefText),
            ),
            onTap: () =>
                {Navigator.pushNamed(context, ParametresMainView.routeName)}),
        itemDispositions(context, coef, coefText,
            ThemeElements(context: context).iconColorDrawer),
        ListTile(
            leading: Icon(
              Icons.list,
              color: ThemeElements(context: context).iconColorDrawer,
              size: SizeConfig.safeBlockVertical * coef,
            ),
            title: Text(
              Strings.menuImport,
              style: ThemeElements(context: context)
                  .styleText(fontSize: SizeConfig.safeBlockVertical * coefText),
            ),
            onTap: () =>
                {Navigator.pushNamed(context, ImportsMainView.routeName)}),
        ListTile(
            leading: Icon(
              Icons.print,
              color: ThemeElements(context: context).iconColorDrawer,
              size: SizeConfig.safeBlockVertical * coef,
            ),
            title: Text(
              Strings.menuExport,
              style: ThemeElements(context: context)
                  .styleText(fontSize: SizeConfig.safeBlockVertical * coefText),
            ),
            onTap: () async {
              await context.read<CeremonieProvider>().refreshBilletPdf();

              Navigator.pushNamed(context, ExportsMainView.routeName);
            }),
        SizedBox(height: SizeConfig.safeBlockVertical * coef),
      ],
    );
  } else {
    return SizedBox(
      height: 10,
    );
  }
}
