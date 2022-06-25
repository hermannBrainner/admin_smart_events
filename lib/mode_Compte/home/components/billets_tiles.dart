import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:flutter/material.dart';
import '/mode_Compte/exports/main.dart';
import '/outils/fonctions/fonctions.dart';
import '/outils/size_configs.dart';
import '/outils/widgets/main.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/primary_bouton.dart';
import '/providers/theme/primary_box_decoration.dart';
import '/providers/theme/primary_loading_bouton.dart';
import '/providers/theme/strings.dart';
import 'package:flutter/material.dart';

Widget resetTile(
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
            "Voulez-vous réinitialiser tous les billets?",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(color: Colors.redAccent, fontSize: 20),
          ),
          SizedBox(height: SizeConfig.safeBlockVertical * 2),
          Text(
            "(Supprimer de façon irreversible la validation de chaque billet d'accès)",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
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
            child: PrimaryLoadingButton(
                text: Strings.valider,
                press: () async {
                  if (isConfirmationGood) {
                    await provider.reinitBillets();
                    await context
                        .read<CeremonieProvider>()
                        .loadCeremonie(provider.ceremonie!.id);
                    showFlushbar(
                        context, true, "", "Réinitialisation avec succès");
                  } else {
                    showFlushbar(context, false, "Réinitialisation",
                        "Mauvaise phrase !!!");
                  }

                  switchFct();
                },
                btnCtrl: btnPosCtrl),
          )
        ],
      ));
}

Widget exportTile({required BuildContext context}) {
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
            "Voulez-vous imprimer un ou plusieurs billets d'accès ?",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
                color: ThemeElements(context: context, mode: ColorMode.envers)
                    .themeColor,
                fontSize: 20),
          ),
          SizedBox(height: SizeConfig.safeBlockVertical * 4),
          SizedBox(height: SizeConfig.safeBlockVertical * 2),
          PrimaryButton(
              text: Strings.exportBillets,
              press: () async {
                await context.read<CeremonieProvider>().refreshBilletPdf();

                Navigator.pushNamed(context, ExportsMainView.routeName);
              }),
        ],
      ));
}

Widget importTile({required Function auClick, required BuildContext context}) {
  RoundedLoadingButtonController btnPosCtrl = RoundedLoadingButtonController();
  return Container(
      // height: 300  ,
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
            "Vous avez déjà votre liste d'invités ?",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
                color: ThemeElements(context: context, mode: ColorMode.envers)
                    .themeColor,
                fontSize: 20),
          ),
          SizedBox(height: SizeConfig.safeBlockVertical * 4),
          SizedBox(height: SizeConfig.safeBlockVertical * 2),
          PrimaryButton(
              text: Strings.importBillets,
              press: () async {
                auClick();
              }),
        ],
      ));
}

Widget qrCodeTile(
    {required Function setValue,
    required String? valueEdited,
    required displayEdition,
    required CeremonieProvider provider,
    required Function auClick,
    required BuildContext context}) {
  RoundedLoadingButtonController btnPosCtrl = RoundedLoadingButtonController();
  return Container(
      width: double.infinity,
      decoration: BoxDecorationPrimary(context,
          topRigth: 10, topLeft: 10, bottomRigth: 10, bottomLeft: 10),
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.safeBlockHorizontal * 3,
        vertical: SizeConfig.safeBlockVertical * 2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Votre url derrère le Qr Code :",
            style: GoogleFonts.inter(
                color: ThemeElements(context: context, mode: ColorMode.envers)
                    .themeColor,
                fontSize: 20),
          ),
          SizedBox(height: SizeConfig.safeBlockVertical * 2),
          Text(
            (provider.ceremonie!.urlPrefix) ?? "AUCUN",
            overflow: TextOverflow.clip,
            maxLines: 2,
            style: GoogleFonts.inter(
                color: ThemeElements(context: context, mode: ColorMode.envers)
                    .themeColor,
                fontSize: 15),
          ),
          SizedBox(height: SizeConfig.safeBlockVertical * 4),
          infoBulle(Strings.infoBulleQrCodes, context),
          SizedBox(height: SizeConfig.safeBlockVertical * 2),
          Visibility(
            visible: !displayEdition,
            child: RoundedLoadingButton(
              color: ThemeElements(context: context).whichBlue,
              controller: btnPosCtrl,
              borderRadius: SizeConfig.safeBlockHorizontal * 3,
              successColor: Colors.lightGreenAccent,
              width: SizeConfig.safeBlockHorizontal * 40,
              elevation: SizeConfig.safeBlockHorizontal * 2,
              height: SizeConfig.safeBlockVertical * 7,
              onPressed: () async {
                auClick();
              },
              child: Text(
                Strings.modifier,
                style: ThemeElements(context: context).styleText(
                    color:
                        ThemeElements(context: context, mode: ColorMode.endroit)
                            .themeColor),
              ),
            ),
          ),
          Visibility(
            visible: displayEdition,
            child: TextField(
              style: ThemeElements(context: context).styleText(
                  color: ThemeElements(context: context, mode: ColorMode.envers)
                      .themeColor),
              onChanged: (val) {
                setValue(val);
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
                  labelText: "Url",
                  hintText: provider.ceremonie!.urlPrefix,
                  border: OutlineInputBorder()),
            ),
          ),
          SizedBox(height: SizeConfig.safeBlockVertical * 2),
          Visibility(
              visible: displayEdition,
              child: Text(
                "Exemple : " +
                    '\n' +
                    (isNullOrEmpty(valueEdited)
                        ? Strings.exempleUrl
                        : valueEdited! + "/code/5207917380"),
                maxLines: 3,
                softWrap: true,
                style: ThemeElements(context: context).styleText(
                    color:
                        ThemeElements(context: context, mode: ColorMode.envers)
                            .themeColor),
              )),
          SizedBox(height: SizeConfig.safeBlockVertical * 2),
          Visibility(
            visible: displayEdition,
            child: PrimaryLoadingButton(
                text: Strings.valider,
                press: () async {
                  String? msgError;
                  String titreError = "Modification";
                  try {
                    if (!isNullOrEmpty(valueEdited)) {
                      if (isUrlValid(valueEdited!)) {
                        provider.ceremonie!.urlPrefix = valueEdited;
                        await provider.ceremonie!.save();
                        context
                            .read<CeremonieProvider>()
                            .refreshCeremonie(provider.ceremonie!);

                        auClick();
                      } else {
                        msgError =
                            "Url ne respectant pas le format international";
                        auClick();
                      }
                    } else {
                      msgError =
                          "Url ne respectant pas le format international";
                      auClick();
                    }
                  } on Exception catch (e) {
                    msgError = e.toString();
                  } catch (e, s) {
                    msgError = e.toString();
                  }

                  await context
                      .read<CeremonieProvider>()
                      .loadCeremonie(provider.ceremonie!.id);

                  if (!isNullOrEmpty(msgError)) {
                    auClick();
                    btnPosCtrl.reset();
                    auClick();
                    showFlushbar(context, false, titreError, msgError!);
                  }
                },
                btnCtrl: btnPosCtrl),
          )
        ],
      ));
}
