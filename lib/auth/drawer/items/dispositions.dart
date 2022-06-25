import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/mode_Compte/dispositions/main.dart';
import '/outils/size_configs.dart';
import '/outils/widgets/main.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/strings.dart';

itemDispositions(
    BuildContext context, dynamic coef, dynamic coefText, Color couleurIcon) {
  return Consumer<CeremonieProvider>(builder: (context, provider, child) {
    Map<String, int> data = provider.getAlertNbres();
    int nbreAlert = data[Strings.total]!;

    return ListTile(
        leading: Icon(
          Icons.view_comfortable_sharp,
          color: couleurIcon,
          size: SizeConfig.safeBlockVertical * coef,
        ),
        title: Text(
          Strings.menuDispos,
          style: ThemeElements(context: context)
              .styleText(fontSize: SizeConfig.safeBlockVertical * coefText),
        ),
        onTap: () => {Navigator.pushNamed(context, Dispositions.routeName)},
        trailing: nbreAlert > 0
            ? Container(
                width: 20, height: 20, child: nbreAlertW(context, nbreAlert))
            : null);
  });
}
