import 'package:flutter/material.dart';

import '/mode_Compte/_models/billet.dart';
import '/outils/constantes/colors.dart';
import '/providers/theme/elements/main.dart';

Widget avatar({
  required Billet billet,
  required double radius,
}) {
  return Wrap(children: [
    Container(
      height: radius * 2,
      width: radius * 2,
      decoration: BoxDecoration(
        color: dWhiteLeger,
        border: Border.all(color: couleurJauneMoutardeClair, width: 2),
        borderRadius:
            BorderRadius.all(Radius.circular(radius)), //  angleArrondi(15),
        // color: colorFromHex(element.couleur)
      ),
      child: Center(child: Text(billet.nbrePersonnes.toString())),
    )
  ]);
}

Widget uneCard(BuildContext context, Color couleur, double hauteur,
    double largeur, String contenu) {
  return Card(
      elevation: hauteur * (8 / 100),
      shape: new RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(hauteur / 6)),
      color: couleur,
      //margin: new EdgeInsets.symmetric(horizontal: hauteur/10, vertical: hauteur*(6/100)),
      child: Container(
        height: hauteur,
        width: largeur,
        margin: new EdgeInsets.symmetric(horizontal: largeur / 10),
        child: Center(
            child: Text(
          contenu,
          textAlign: TextAlign.center,
          style: ThemeElements(context: context).styleText(
              color: Colors.black87,
              fontSize: largeur / 10,
              fontWeight: FontWeight.bold),
        )),
      ));
}
