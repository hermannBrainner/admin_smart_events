import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/outils/size_configs.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/elements/boutons.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/primary_box_decoration.dart';
import '/providers/theme/primary_loading_bouton.dart';
import '../../plan_salle/display.dart';
import '../../plan_salle/main.dart';

Widget planSalle(
  BuildContext context,
) {
  RoundedLoadingButtonController btnCtrl = RoundedLoadingButtonController();

  return Container(
      height: 100,
      decoration: BoxDecorationPrimary(context,
          topRigth: 10, topLeft: 10, bottomRigth: 10, bottomLeft: 10),
      padding: EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.safeBlockHorizontal * 5,
        vertical: SizeConfig.safeBlockVertical * 2,
      ),
      child: PrimaryLoadingButton(
          text: "Plan de salle",
          press: () async {
            File pdfPlanSalle = await BuildPlanSalle(context);

            btnCtrl.stop();
            Navigator.pushNamed(context, DisplayPdf.routeName,
                arguments: [pdfPlanSalle]);
          },
          btnCtrl: btnCtrl));
}

Widget salleTile(BuildContext context,
    {required titre,
    required details,
    required CeremonieProvider provider,
    required Function auClick,
    required bool isRed}) {
  return Container(
      height: 80,
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
                      fontWeight: FontWeight.bold,
                      color: ThemeElements(
                              context: context, mode: ColorMode.envers)
                          .themeColor,
                      fontSize: 15),
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
                        fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          BoutonsOfTheme(
                  couleur: isRed ? Colors.redAccent : null,
                  onPressed: () {
                    auClick();
                  },
                  context: context)
              .edit
        ],
      ));
}
