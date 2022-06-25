import 'package:flutter/material.dart';

import '/mode_Compte/_models/filleul.dart';
import '/outils/fonctions/fonctions.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/strings.dart';

Widget leadingFilleul(BuildContext context, Filleul filleul) {
  if (filleul.idUser == null) {
    return Padding(
      padding: const EdgeInsets.only(right: 02.0),
      child: IconButton(
        onPressed: () async {
          await envoieSMS(context, message: Strings.corpsMsgeParrainage);
        },
        icon: Icon(Icons.share, size: 25),
      ),
    );
  } else if (filleul.primeDebloquee && !filleul.primeRecue) {
    return Padding(
      padding: const EdgeInsets.only(right: 2.0),
      child: Text(
        "5€",
        style: ThemeElements(context: context).styleText(
            color: ThemeElements(context: context, mode: ColorMode.endroit)
                .themeColor,
            fontWeight: FontWeight.bold,
            fontSize: 25),
      ),
    );
  } else {
    return Center();
  }
}

Widget nameWidget(BuildContext context, Filleul filleul) {
  return Padding(
    padding: const EdgeInsets.only(top: 10.0),
    child: Text(
      filleul.prenom,
      style: ThemeElements(context: context).styleText(
          color: ThemeElements(context: context, mode: ColorMode.endroit)
              .themeColor,
          fontWeight: FontWeight.bold,
          fontSize: 20),
    ),
  );
}

Widget emailWidget(BuildContext context, Filleul filleul) {
  return Text(
    filleul.email,
    style: ThemeElements(context: context).styleText(
        color:
            ThemeElements(context: context, mode: ColorMode.endroit).themeColor,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.italic,
        fontSize: 13),
  );
}

Widget pings(BuildContext context, Filleul filleul, double rayonPings,
    Color colorPings) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    child: Container(
      width: rayonPings * 2,
      height: rayonPings * 2,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(rayonPings * 2),
          border: Border.all(
              color: ThemeElements(context: context).whichBlue, width: 1)),
      child: CircleAvatar(
        radius: rayonPings,
        backgroundColor: colorPings,
        child: (filleul.primeRecue) ? Icon(Icons.check) : null,
      ),
    ),
  );
}

Widget infoWidget(BuildContext context, double rayonPings, Color colorPings,
    String infoTexte) {
  return Container(
    margin: EdgeInsets.only(bottom: 5),
    width: 220,
    height: 30,
    decoration: BoxDecoration(
        color:
            ThemeElements(context: context, mode: ColorMode.envers).themeColor,
        borderRadius: BorderRadius.circular(rayonPings * 2),
        border: Border.all(color: colorPings, width: 3)),
    child: Center(
      child: Text(
        infoTexte,
        style: ThemeElements(context: context).styleText(
            color: ThemeElements(context: context, mode: ColorMode.endroit)
                .themeColor,
            fontWeight: FontWeight.bold,
            fontSize: 10),
      ),
    ),
  );
}
