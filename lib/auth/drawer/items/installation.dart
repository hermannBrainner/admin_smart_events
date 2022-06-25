import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/mode_Compte/installations/main.dart';
import '/outils/size_configs.dart';
import '/outils/widgets/main.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/strings.dart';

itemInstallations(
    BuildContext context, dynamic coef, dynamic coefText, Color couleurIcon) {
  return Consumer<CeremonieProvider>(builder: (context, provider, child) {
    int nbreAlert = provider.billetsInv
        .where((billet) => billet.estArrive && !billet.estInstalle)
        .toList()
        .length;

    return ListTile(
        leading: Icon(
          Icons.airline_seat_recline_extra,
          color: couleurIcon,
          size: SizeConfig.safeBlockVertical * coef,
        ),
        title: Text(
          Strings.menuInstalls,
          style: ThemeElements(context: context)
              .styleText(fontSize: SizeConfig.safeBlockVertical * coefText),
        ),
        onTap: () =>
            {Navigator.pushNamed(context, InstallationsMainView.routeName)},
        trailing: nbreAlert > 0
            ? Container(
                width: 20, height: 20, child: nbreAlertW(context, nbreAlert))
            : null);
  });
}
