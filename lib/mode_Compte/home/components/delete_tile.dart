import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:flutter/material.dart';
import '/auth/sign_out.dart';
import '/outils/constantes/colors.dart';
import '/outils/size_configs.dart';
import '/outils/widgets/main.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/primary_box_decoration.dart';
import '/providers/theme/strings.dart';

Widget deleteTile(
    {required CeremonieProvider provider,
    required Function checkConfimation,
    required isConfirmationGood,
    required switchFct,
    required BuildContext context,
    required bool disPlayValidation}) {
  RoundedLoadingButtonController btnPosCtrl = RoundedLoadingButtonController();
  return Container(
      width: double.infinity,
      decoration: BoxDecorationPrimary(context,
          topRigth: 10, topLeft: 10, bottomRigth: 10, bottomLeft: 10),
      padding: EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 20,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.safeBlockHorizontal * 3,
        vertical: SizeConfig.safeBlockVertical * 2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Voulez-vous supprimer cette cérémonie ?",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(color: Colors.redAccent, fontSize: 20),
          ),
          SizedBox(height: SizeConfig.safeBlockVertical * 2),
          Text(
            "(La suppression sera irreversible)",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                color: ThemeElements(context: context, mode: ColorMode.envers)
                    .themeColor,
                fontSize: 15),
          ),
          SizedBox(height: SizeConfig.safeBlockVertical * 4),
          Visibility(
            visible: !disPlayValidation,
            child: CupertinoSwitch(
                trackColor: Colors.redAccent,
                value: disPlayValidation,
                onChanged: (_) {
                  switchFct();
                }),
          ),
          Visibility(
              visible: disPlayValidation && !isConfirmationGood,
              child: infoBulle(Strings.infoJeConfirme, context)),
          SizedBox(height: SizeConfig.safeBlockVertical * 2),
          Visibility(
              visible: disPlayValidation && !isConfirmationGood,
              child: TextField(
                style: ThemeElements(context: context).styleText(
                    color:
                        ThemeElements(context: context, mode: ColorMode.envers)
                            .themeColor),
                onChanged: (val) {
                  checkConfimation(val.trim());
                },
                maxLines: 1,
                cursorColor: ThemeElements(context: context).whichBlue,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: ThemeElements(context: context).whichBlue,
                            width: 2.0)),
                    labelStyle: ThemeElements(context: context).styleText(
                        color: ThemeElements(context: context).whichBlue),
                    labelText: "Confirmation",
                    hintText: Strings.infoJeConfirme,
                    border: OutlineInputBorder()),
              )),
          SizedBox(height: SizeConfig.safeBlockVertical * 2),
          Visibility(
            visible: disPlayValidation,
            child: RoundedLoadingButton(
                color: ThemeElements(context: context).whichBlue,
                controller: btnPosCtrl,
                borderRadius: SizeConfig.safeBlockHorizontal * 3,
                successColor: Colors.lightGreenAccent,
                width: SizeConfig.safeBlockHorizontal * 40,
                elevation: SizeConfig.safeBlockHorizontal * 2,
                height: SizeConfig.safeBlockVertical * 7,
                onPressed: () async {
                  if (isConfirmationGood) {
                    await provider.deleteAll(context);
                    await signOut(context, false);

                    showFlushbar(context, true, "", "Suppression avec succès");
                  } else {
                    showFlushbar(context, false, "", "Mauvaise phrase !!!");
                  }

                  switchFct();
                },
                child: Text(
                  Strings.valider,
                  style:
                      ThemeElements(context: context).styleText(color: dBlack),
                )),
          )
        ],
      ));
}
