import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/outils/size_configs.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/elements/boutons.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/primary_box_decoration.dart';

Widget shareAppTile(BuildContext context) {
  final double coteBouton = 50;
  return Container(
      height: 150,
      decoration: BoxDecorationPrimary(context,
          topRigth: 10, topLeft: 10, bottomRigth: 10, bottomLeft: 10),
      padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 3),
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.safeBlockHorizontal * 2,
        vertical: SizeConfig.safeBlockVertical * 2,
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Partager l'application",
              style: GoogleFonts.inter(
                  color: ThemeElements(context: context, mode: ColorMode.envers)
                      .themeColor,
                  fontSize: 20),
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: coteBouton,
                  height: coteBouton,
                  decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Icon(
                    Icons.apple,
                    size: coteBouton,
                  ),
                ),
                SizedBox(
                  width: SizeConfig.safeBlockHorizontal * 8,
                ),
                Container(
                  width: coteBouton,
                  height: coteBouton,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Icon(
                    Icons.android,
                    size: coteBouton,
                  ),
                ),
              ],
            )
          ]));
}

Widget useTile(BuildContext context,
    {required bool displayEdit,
    required titre,
    required details,
    required CeremonieProvider provider,
    required Function auClick,
    required bool isRed}) {
  return Container(
      height: 100,
      decoration: BoxDecorationPrimary(context,
          topRigth: 10, topLeft: 10, bottomRigth: 10, bottomLeft: 10),
      padding: EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.safeBlockHorizontal * 5,
        vertical: SizeConfig.safeBlockVertical * 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  titre,
                  style: GoogleFonts.inter(
                      color: ThemeElements(
                              context: context, mode: ColorMode.envers)
                          .themeColor,
                      fontSize: 20),
                ),
                SizedBox(height: SizeConfig.safeBlockVertical * 2),
                Expanded(
                  child: Text(
                    details,
                    overflow: TextOverflow.clip,
                    maxLines: 2,
                    style: GoogleFonts.inter(
                        color: ThemeElements(
                                context: context, mode: ColorMode.envers)
                            .themeColor,
                        fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
          if (displayEdit)
            BoutonsOfTheme(
                couleur: isRed ? Colors.redAccent : null,
                context: context,
                onPressed: () {
                  auClick();
                }).edit
        ],
      ));
}
