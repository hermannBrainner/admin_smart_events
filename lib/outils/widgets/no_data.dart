import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/mode_Compte/home_compte/pages/ceremonies/new.dart';
import '/mode_Compte/messagerie/open_button.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/primary_bouton.dart';
import '/providers/theme/primary_loading_bouton.dart';
import '../size_configs.dart';

Widget infoW(context, {String texte = "Aucun invité dans cette catégorie"}) {
  return Container(
    padding: EdgeInsets.only(top: 50, left: 20, right: 20),
    alignment: Alignment.topCenter,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.info,
          color: ThemeElements(context: context, mode: ColorMode.envers)
              .themeColor,
          size: SizeConfig.safeBlockHorizontal * 6,
        ),
        SizedBox(
          width: SizeConfig.safeBlockHorizontal * 6,
        ),
        Expanded(
            child: Text(
          texte,
          textAlign: TextAlign.justify,
          overflow: TextOverflow.clip,
          maxLines: 2,
          style: ThemeElements(context: context).styleText(
              color: ThemeElements(context: context, mode: ColorMode.envers)
                  .themeColor,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
              fontSize: SizeConfig.safeBlockHorizontal * 4),
        ))
      ],
    ),
  );
}

Widget noData_Ceremonies(BuildContext context) {
  return Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 50.0),
          child: infoW(context, texte: "Aucune cérémonie enregistrée"),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 50),
          child: PrimaryButton(
            fontSize: 18,
            isBold: true,
            rayonBord: 10,
            /* padding: EdgeInsets.only(
                top: 40.0,
                left: 100,
                right: 100,
              ),*/
            text: "Créez une cérémonie",
            press: () async {
              Navigator.pushNamed(context, NewCeremonie.routeName);
            },
          ),
        ),
        openMessagerie(context),
      ],
    ),
  );
}

Widget noData_Invites(
  BuildContext context, {
  required RoundedLoadingButtonController btnCtrl,
  required CeremonieProvider provider,
}) {
  return Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 100.0),
          child: infoW(context),
        ),
        PrimaryLoadingButton(
            padding: EdgeInsets.only(
              top: 40.0,
              left: 100,
              right: 100,
            ),
            text: "REFRESH",
            press: () async {
              await context.read<CeremonieProvider>().refreshOnlyBillets();
              btnCtrl.stop();
            },
            btnCtrl: btnCtrl)
      ],
    ),
  );
}
