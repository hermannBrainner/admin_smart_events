import 'dart:ui';

import 'package:flutter/material.dart';

import '/mode_Compte/stats/datas/table.dart';
import '/outils/constantes/colors.dart';
import '/outils/fonctions/fonctions.dart';
import '/providers/theme/elements/main.dart';

ListTile logTableInvites(DataTableInvites dtInv, BuildContext context) {
  Color tag =
      dtInv.id % 2 == 0 ? couleurBeigeSombre : couleurJauneMoutardeClair;

  double radius = 40;
  return ListTile(
      minLeadingWidth: 10,
      minVerticalPadding: 10,
      contentPadding: EdgeInsets.only(right: 5.0, left: 5),
      leading: Container(
          padding: EdgeInsets.only(right: 1.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white24))),
          child: Container(
              height: double.infinity,
              width: 10,
              child: Row(children: [
                Container(
                  height: double.infinity,
                  width: 10,
                  color: tag,
                ),
              ]))),
      title: Text(
        dtInv.name.toUpperCase(),
        textAlign: TextAlign.start,
        style: ThemeElements(context: context)
            .styleText(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      subtitle: Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          width: 400,
          height: 15,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: LinearProgressIndicator(
              value: dtInv.percent / 100,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff00ff00)),
              backgroundColor: Color(0xffD6D6D6),
            ),
          )),
      trailing: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dWhite,
            /* borderRadius: BorderRadius.circular(10),*/
            border: Border.all(color: couleurDoree, width: 4.0)),
        child: CircleAvatar(
          radius: radius,
          backgroundColor: Colors.transparent,
          // _randomColor.randomColor(colorBrightness: ColorBrightness.primary),
          child: Text(
            doubleToString(dtInv.percent) + "%",
            style: TextStyle(
                fontSize: radius / 3,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
        ),
      )
      //   Text(doubleToString( dtInv.percent ) + "%", style: TextStyle(fontWeight: FontWeight.bold), ) ]

      );
}
