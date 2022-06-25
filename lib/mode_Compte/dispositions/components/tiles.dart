import 'package:flutter/material.dart';

import '/mode_Compte/_models/billet.dart';
import '/mode_Compte/_models/table.dart';
import '/mode_Compte/_models/zone.dart';
import '/outils/extensions/string.dart';
import '/outils/widgets/main.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/elements/main.dart';
import 'leadings.dart';
import 'tags.dart';

tableTile(BuildContext context, TableInvite tableInvite, bool isCheck,
    Zone? parentZone, CeremonieProvider provider,
    {required Function onTap}) {
  return Container(
    child: ListTile(
      shape: angleArrondi(10),
      leading: leading(tableInvite, provider, context),
      title: Text(
        tableInvite.nom.upperDebut(),
        style: ThemeElements(context: context)
            .styleText(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      subtitle: tableTag(context, provider.ceremonie!, parentZone, tableInvite),
      trailing: Checkbox(
        value: isCheck,
        onChanged: (value) {
          onTap(tableInvite);
        },
      ),
    ),
    decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
                color: ThemeElements(context: context, mode: ColorMode.envers)
                    .themeColor))),
  );
}

zoneTile(
    BuildContext context, Zone zone, bool isCheck, CeremonieProvider provider,
    {required Function onTap}) {
  // return

  return Container(
    child: ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      // tileColor: Colors.green,
      leading: leading(zone, provider, context),
      title: Text(
        zone.nom,
        style: ThemeElements(context: context).styleText(fontSize: 20),
      ),
      subtitle: zoneTag(context, zone, provider.ceremonie!),
      trailing: Checkbox(
        value: isCheck,
        onChanged: (value) {
          onTap(zone);
        },
      ),
    ),
    decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
                color: ThemeElements(context: context, mode: ColorMode.envers)
                    .themeColor))),
  );
}

billetTile(BuildContext context, Billet billet, bool isCheck, dynamic parent,
    CeremonieProvider provider,
    {required Function onTap}) {
  return Container(
    child: ListTile(
      shape: angleArrondi(10),
      // tileColor: Colors.green,
      leading: leading(billet, provider, context),
      title: Text(
        billet.nom,
        style: ThemeElements(context: context)
            .styleText(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      subtitle: billetTag(context, provider.ceremonie!, parent, billet),
      trailing: GestureDetector(
        onTap: () => onTap(billet),
        child: Container(
          width: 80,
          height: 30,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: isCheck
                  ? ThemeElements(context: context).whichBlue
                  : ThemeElements(context: context).themeColorSecondary),
          child: Center(
            child: Text(
              "Select.",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
      )

      /*Checkbox(
        value: isCheck,
        onChanged: (value) {
          onTap(billet);
        },
      )*/
      ,
    ),
    decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
                color: ThemeElements(context: context, mode: ColorMode.envers)
                    .themeColor))),
  );
}
