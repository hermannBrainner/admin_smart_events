import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/mode_Compte/_models/ceremonie.dart';
import '/mode_Compte/home/main.dart';
import '/outils/extensions/string.dart';
import '/outils/size_configs.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/primary_box_decoration.dart';
import '/providers/theme/primary_loading_bouton.dart';
import 'values.dart';

Widget ceremonieTile(
    BuildContext context, Ceremonie ceremonie, Map<String, dynamic> values) {
  return GridTile(
      child: Container(
    margin: EdgeInsets.symmetric(vertical: 30),
    child: Column(
      children: [
        details(context, ceremonie, values),
        SizedBox(
          height: 3,
        ),
        panneauBtnVoir(context, ceremonie),
      ],
    ),
  ));
}

Widget details(
    BuildContext context, Ceremonie ceremonie, Map<String, dynamic> values) {
  initializeDateFormatting("fr");
  Intl.defaultLocale = "fr_FR";

  return Container(
    margin: EdgeInsets.only(
      top: SizeConfig.blockSizeVertical * 2,
      left: SizeConfig.blockSizeHorizontal * 2,
      right: SizeConfig.blockSizeHorizontal * 2,
    ),
    padding: EdgeInsets.symmetric(
        vertical: SizeConfig.blockSizeVertical * 2,
        horizontal: SizeConfig.blockSizeHorizontal * 2),
    decoration: BoxDecorationPrimary(context,
        topRigth: 20, topLeft: 20, bottomRigth: 0, bottomLeft: 0),
    height: SizeConfig.blockSizeVertical * 33,
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text(
            ceremonie.titreCeremonie,
            textAlign: TextAlign.justify,
            overflow: TextOverflow.clip,
            maxLines: 2,
            style: TextStyle(
                color: ThemeElements(context: context, mode: ColorMode.envers)
                    .themeColor,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
                fontSize: SizeConfig.safeBlockVertical * 3),
          ),
        ),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 1.5,
        ),
        Text(
          DateFormat('EEE d MMM yyyy')
              .format(ceremonie.dateCeremonie.toDate())
              .upperDebut(),
          textAlign: TextAlign.justify,
          overflow: TextOverflow.clip,
          style: TextStyle(
              color: ThemeElements(context: context, mode: ColorMode.envers)
                  .themeColor,
              fontWeight: FontWeight.normal,
              decoration: TextDecoration.none,
              fontSize: SizeConfig.safeBlockVertical * 2),
        ),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 1.5,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person),
            Text(
              "x${values[values.keys.firstWhere((key) => key.contains(INVITES))]}",
              textAlign: TextAlign.justify,
              overflow: TextOverflow.clip,
              style: TextStyle(
                  color: ThemeElements(context: context, mode: ColorMode.envers)
                      .themeColor,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                  fontSize: SizeConfig.safeBlockVertical * 2),
            ),
            Text(
              "                                  Invités",
              textAlign: TextAlign.justify,
              overflow: TextOverflow.clip,
              style: TextStyle(
                  color: ThemeElements(context: context, mode: ColorMode.envers)
                      .themeColor,
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.none,
                  fontSize: SizeConfig.safeBlockVertical * 2),
            ),
          ],
        ),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 1,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.airplane_ticket),
            Text(
              "x${values[values.keys.firstWhere((key) => key.contains(BILLETS))]}",
              textAlign: TextAlign.right,
              overflow: TextOverflow.clip,
              style: TextStyle(
                  color: ThemeElements(context: context, mode: ColorMode.envers)
                      .themeColor,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                  fontSize: SizeConfig.safeBlockVertical * 2),
            ),
            Text(
              "                                  Billets",
              textAlign: TextAlign.right,
              overflow: TextOverflow.clip,
              style: TextStyle(
                  color: ThemeElements(context: context, mode: ColorMode.envers)
                      .themeColor,
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.none,
                  fontSize: SizeConfig.safeBlockVertical * 2),
            ),
          ],
        ),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 1.5,
        ),
        Text(
          "Identifiants",
          textAlign: TextAlign.justify,
          overflow: TextOverflow.clip,
          style: TextStyle(
              color: ThemeElements(context: context, mode: ColorMode.envers)
                  .themeColor,
              fontWeight: FontWeight.normal,
              decoration: TextDecoration.none,
              fontSize: SizeConfig.safeBlockVertical * 2),
        ),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 1,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Id : ",
              textAlign: TextAlign.justify,
              overflow: TextOverflow.clip,
              style: TextStyle(
                  color: ThemeElements(context: context, mode: ColorMode.envers)
                      .themeColor,
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.none,
                  fontSize: SizeConfig.safeBlockVertical * 2),
            ),
            Expanded(
              child: Text(
                ceremonie.username,
                textAlign: TextAlign.justify,
                overflow: TextOverflow.clip,
                maxLines: 2,
                style: TextStyle(
                    color:
                        ThemeElements(context: context, mode: ColorMode.envers)
                            .themeColor,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    fontSize: SizeConfig.safeBlockVertical * 2),
              ),
            ),
            Expanded(
              child: Center(),
            ),
            Text(
              "Password : ",
              textAlign: TextAlign.justify,
              overflow: TextOverflow.clip,
              style: TextStyle(
                  color: ThemeElements(context: context, mode: ColorMode.envers)
                      .themeColor,
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.none,
                  fontSize: SizeConfig.safeBlockVertical * 2),
            ),
            Expanded(
              child: Text(
                ceremonie.mdp,
                textAlign: TextAlign.justify,
                overflow: TextOverflow.clip,
                maxLines: 2,
                style: TextStyle(
                    color:
                        ThemeElements(context: context, mode: ColorMode.envers)
                            .themeColor,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    fontSize: SizeConfig.safeBlockVertical * 2),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget panneauBtnVoir(BuildContext context, Ceremonie ceremonie) {
  return Container(
    margin: EdgeInsets.only(
      bottom: SizeConfig.blockSizeVertical * 2,
      left: SizeConfig.blockSizeHorizontal * 2,
      right: SizeConfig.blockSizeHorizontal * 2,
    ),
    // padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical*2, horizontal: SizeConfig.blockSizeHorizontal*2),

    height: SizeConfig.blockSizeVertical * 10,
    child: PrimaryLoadingButton(
        text: "Voir & editer",
        press: () async {
          await context.read<CeremonieProvider>().loadCeremonie(ceremonie.id);
          await context.read<CeremonieProvider>().refreshBilletPdf();
          Navigator.pushNamedAndRemoveUntil(context,
              ParametresMainView.routeName, (Route<dynamic> route) => false);
        },
        btnCtrl: RoundedLoadingButtonController()),

    width: double.infinity,
    decoration: BoxDecorationPrimary(context,
        topRigth: 0, topLeft: 0, bottomRigth: 20, bottomLeft: 20),
  );
}
