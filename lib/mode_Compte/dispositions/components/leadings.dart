import 'package:flutter/material.dart';

import '/mode_Compte/_models/billet.dart';
import '/mode_Compte/_models/table.dart';
import '/mode_Compte/_models/zone.dart';
import '/mode_Compte/dispositions/components/plan_table/plan_table.dart';
import '/outils/constantes/colors.dart';
import '/outils/extensions/string.dart';
import '/outils/fonctions/fonctions.dart';
import '/providers/ceremonie.dart';
import 'plan_table/hero_dialog_route.dart';

leading(
    dynamic inputElement, CeremonieProvider provider, BuildContext context) {
  switch (inputElement.runtimeType) {
    case Zone:
      return Wrap(children: [
        Container(
          height: 30,
          width: 30,
          color: (inputElement.couleur as String).couleurFromHex(),
          child: Center(
              child: Text(
            (inputElement as Zone).totalInvites(provider).toString(),
            style: TextStyle(
                color: blackOrWhite_formLuminance(
                    (inputElement.couleur as String).couleurFromHex())),
          )),
        )
      ]);
    case TableInvite:
      return InkWell(
        onTap: () {
          Navigator.of(context).push(HeroDialogRoute(
              isDismissible: true,
              builder: (context) {
                return PlanTable(
                  provider: provider,
                  tableInvite: inputElement,
                );
              }));
        },
        child: Wrap(children: [
          Container(
            height: 60,
            width: 30,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), //  angleArrondi(15),
                color: (inputElement.couleur as String).couleurFromHex()),
            child: Center(
                child: Text(
              (inputElement as TableInvite).totalInvites(provider).toString(),
              style: TextStyle(
                  color: blackOrWhite_formLuminance(
                      (inputElement.couleur as String).couleurFromHex())),
            )),
          )
        ]),
      );

    case Billet:
      return Wrap(children: [
        Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            border: Border.all(color: couleurJauneMoutardeClair, width: 2),
            borderRadius:
                BorderRadius.all(Radius.circular(15)), //  angleArrondi(15),
            // color: colorFromHex(element.couleur)
          ),
          child: Center(child: Text(inputElement.nbrePersonnes.toString())),
        )
      ]);
  }
}
