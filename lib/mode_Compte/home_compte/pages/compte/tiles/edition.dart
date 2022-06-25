import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/mode_Compte/_models/user_app.dart';
import '/outils/constantes/colors.dart';
import '/outils/extensions/string.dart';
import '/outils/fonctions/fonctions.dart';
import '/outils/size_configs.dart';
import '/outils/widgets/main.dart';
import '/providers/authentification_provider.dart';
import '/providers/theme/elements/boutons.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/primary_box_decoration.dart';
import '/providers/theme/strings.dart';
import '../modification_infos.dart';

infosTile(BuildContext context, {required UserApp userApp}) {
  String libelle = "Vos informations";
  String texte = "Nom, prénom, e-mail, mot de passe...";

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            libelle,
            style: GoogleFonts.inter(
                color: ThemeElements(context: context, mode: ColorMode.envers)
                    .themeColor,
                fontSize: 20),
          ),
          SizedBox(height: SizeConfig.safeBlockVertical * 2),
          Expanded(
            child: Text(
              texte,
              overflow: TextOverflow.clip,
              maxLines: 2,
              style: GoogleFonts.inter(
                  color: ThemeElements(context: context, mode: ColorMode.envers)
                      .themeColor
                      .withOpacity(0.5),
                  fontSize: 15),
            ),
          ),
        ],
      )),
      BoutonsOfTheme(onPressed: () {}, context: context).edit
    ],
  );
}

passwordEditionTile(
    {required Function setValue,
    required UserApp userApp,
    required Function editedValue,
    required Function switchDisplay,
    required displayEdition,
    required BuildContext context}) {
  RoundedLoadingButtonController btnPosCtrl = RoundedLoadingButtonController();

  return Container(
      width: double.infinity,
      height: displayEdition
          ? SizeConfig.safeBlockVertical * 50
          : SizeConfig.safeBlockVertical * 10,
      decoration: BoxDecorationPrimary(context,
          topRigth: 10, topLeft: 10, bottomRigth: 10, bottomLeft: 10),
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.safeBlockVertical * 1,
        horizontal: SizeConfig.safeBlockHorizontal * 3,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.safeBlockHorizontal * 3,
        vertical: SizeConfig.safeBlockVertical * 2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  height: SizeConfig.safeBlockVertical * 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mot de passe",
                        style: GoogleFonts.inter(
                            color: ThemeElements(
                                    context: context, mode: ColorMode.envers)
                                .themeColor,
                            fontSize: 20),
                      ),
                      SizedBox(height: SizeConfig.safeBlockVertical * 2),
                      Expanded(
                        child: Text(
                          "  XXXXXXXXXXXX",
                          overflow: TextOverflow.clip,
                          maxLines: 2,
                          style: GoogleFonts.inter(
                              color: ThemeElements(
                                      context: context, mode: ColorMode.envers)
                                  .themeColor
                                  .withOpacity(0.5),
                              fontSize: 15),
                        ),
                      ),
                    ],
                  )),
              Expanded(child: Center()),
              BoutonsOfTheme(
                      onPressed: () => switchDisplay(InfosItem.Password),
                      context: context)
                  .edit
            ],
          ),
          sizedCustom(display: displayEdition, coef: 4),
          Visibility(
            visible: displayEdition,
            child: TextField(
              style: TextStyle(
                  color: ThemeElements(context: context, mode: ColorMode.envers)
                      .themeColor),
              onChanged: (val) {
                setValue(val, InfosItem.Password);
              },
              maxLines: 1,
              cursorColor: ThemeElements(context: context).whichBlue,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: ThemeElements(context: context).whichBlue,
                          width: 2.0)),
                  labelStyle: TextStyle(
                      color: ThemeElements(context: context).whichBlue),
                  labelText: "Mot de passe",
                  //      hintText: userApp.email,
                  border: OutlineInputBorder()),
            ),
          ),
          sizedCustom(display: displayEdition, coef: 2),
          Visibility(
            visible: displayEdition,
            child: TextField(
              style: TextStyle(
                  color: ThemeElements(context: context, mode: ColorMode.envers)
                      .themeColor),
              onChanged: (val) {
                setValue(val, InfosItem.PasswordConfirm);
              },
              maxLines: 1,
              cursorColor: ThemeElements(context: context).whichBlue,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: ThemeElements(context: context).whichBlue,
                          width: 2.0)),
                  labelStyle: TextStyle(
                      color: ThemeElements(context: context).whichBlue),
                  labelText: "Confirmation",
                  border: OutlineInputBorder()),
            ),
          ),
          sizedCustom(display: displayEdition, coef: 2),
          Visibility(
            visible: displayEdition,
            child: RoundedLoadingButton(
              color: ThemeElements(context: context).whichBlue,
              controller: btnPosCtrl,
              borderRadius: SizeConfig.safeBlockHorizontal * 3,
              successColor: Colors.lightGreenAccent,
              width: SizeConfig.safeBlockHorizontal * 40,
              elevation: SizeConfig.safeBlockHorizontal * 2,
              height: SizeConfig.safeBlockVertical * 7,
              onPressed: () async {
                if (!isNullOrEmpty(editedValue(InfosItem.Password)) &&
                    (editedValue(InfosItem.Password) ==
                        editedValue(InfosItem.PasswordConfirm))) {
                  try {
                    await AuthentificationProvider()
                        .updatePassword(editedValue(InfosItem.Password));
                    /*   Compte compte = await Compte.getById(userApp.email).first ;

                    compte.mdp = toTrimAndCase(editedValue(InfosItem.Password));

                    await compte.save();
*/

                  } on FirebaseAuthException catch (e) {
                    showFlushbar(context, false, "",
                        e.message ?? "Enregistrement du mail impossible");
                  }

                  // je supprime l'ancien

                } else {
                  showFlushbar(
                      context, false, "", "Mots de passe non correspondants");
                }

                switchDisplay(InfosItem.Password);
              },
              child: Text(
                Strings.valider,
                style: TextStyle(color: dBlack),
              ),
            ),
          )
        ],
      ));
}

emailEditionTile(
    {required Function setValue,
    required UserApp userApp,
    required Function editedValue,
    required Function switchDisplay,
    required displayEdition,
    required BuildContext context}) {
  RoundedLoadingButtonController btnPosCtrl = RoundedLoadingButtonController();

  return Container(
      width: double.infinity,
      height: displayEdition
          ? SizeConfig.safeBlockVertical * 50
          : SizeConfig.safeBlockVertical * 10,
      decoration: BoxDecorationPrimary(context,
          topRigth: 10, topLeft: 10, bottomRigth: 10, bottomLeft: 10),
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.safeBlockVertical * 1,
        horizontal: SizeConfig.safeBlockHorizontal * 3,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.safeBlockHorizontal * 3,
        vertical: SizeConfig.safeBlockVertical * 2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  height: SizeConfig.safeBlockVertical * 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Adresse email",
                        style: GoogleFonts.inter(
                            color: ThemeElements(
                                    context: context, mode: ColorMode.envers)
                                .themeColor,
                            fontSize: 20),
                      ),
                      SizedBox(height: SizeConfig.safeBlockVertical * 2),
                      Expanded(
                        child: Text(
                          "  " + userApp.email,
                          overflow: TextOverflow.clip,
                          maxLines: 2,
                          style: GoogleFonts.inter(
                              color: ThemeElements(
                                      context: context, mode: ColorMode.envers)
                                  .themeColor
                                  .withOpacity(0.5),
                              fontSize: 15),
                        ),
                      ),
                    ],
                  )),
              Expanded(child: Center()),
              BoutonsOfTheme(
                      onPressed: () => switchDisplay(InfosItem.Email),
                      context: context)
                  .edit
            ],
          ),
          sizedCustom(display: displayEdition, coef: 4),
          Visibility(
            visible: displayEdition,
            child: TextField(
              style: TextStyle(
                  color: ThemeElements(context: context, mode: ColorMode.envers)
                      .themeColor),
              onChanged: (val) {
                setValue(val, InfosItem.Email);
              },
              maxLines: 1,
              cursorColor: ThemeElements(context: context).whichBlue,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: ThemeElements(context: context).whichBlue,
                          width: 2.0)),
                  labelStyle: TextStyle(
                      color: ThemeElements(context: context).whichBlue),
                  labelText: "Email",
                  hintText: userApp.email,
                  border: OutlineInputBorder()),
            ),
          ),
          sizedCustom(display: displayEdition, coef: 2),
          Visibility(
            visible: displayEdition,
            child: TextField(
              style: TextStyle(
                  color: ThemeElements(context: context, mode: ColorMode.envers)
                      .themeColor),
              onChanged: (val) {
                setValue(val, InfosItem.EmailConfirm);
              },
              maxLines: 1,
              cursorColor: ThemeElements(context: context).whichBlue,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: ThemeElements(context: context).whichBlue,
                          width: 2.0)),
                  labelStyle: TextStyle(
                      color: ThemeElements(context: context).whichBlue),
                  labelText: "Confirmation",
                  border: OutlineInputBorder()),
            ),
          ),
          sizedCustom(display: displayEdition, coef: 2),
          Visibility(
            visible: displayEdition,
            child: RoundedLoadingButton(
              color: ThemeElements(context: context).whichBlue,
              controller: btnPosCtrl,
              borderRadius: SizeConfig.safeBlockHorizontal * 3,
              successColor: Colors.lightGreenAccent,
              width: SizeConfig.safeBlockHorizontal * 40,
              elevation: SizeConfig.safeBlockHorizontal * 2,
              height: SizeConfig.safeBlockVertical * 7,
              onPressed: () async {
                if (toTrimAndCase(editedValue(InfosItem.Email))
                        .isValidEmail() &&
                    (toTrimAndCase(editedValue(InfosItem.Email)) ==
                        toTrimAndCase(editedValue(InfosItem.EmailConfirm)))) {
                  try {
                    await AuthentificationProvider()
                        .updateMail(editedValue(InfosItem.Email));
                    /*Compte compte = await Compte.getById(userApp.email).first ;

                    final String ancienMail = compte.id! ;

                    compte.id = toTrimAndCase(editedValue(InfosItem.Email));

                    await Compte().update(ancienMail, compte.id!, compte.mdp!  );*/

                    userApp.email = toTrimAndCase(editedValue(InfosItem.Email));
                    await userApp.save(context);
                  } on FirebaseAuthException catch (e) {
                    showFlushbar(context, false, "",
                        e.message ?? "Enregistrement du mail impossible");
                  }

                  // je supprime l'ancien

                } else {
                  showFlushbar(context, false, "",
                      "Mauvais email, ou non correspondants");
                }

                switchDisplay(InfosItem.Email);
              },
              child: Text(
                Strings.valider,
                style: TextStyle(color: dBlack),
              ),
            ),
          )
        ],
      ));
}

phoneEditionTile(
    {required Function setValue,
    required UserApp userApp,
    required Function editedValue,
    required Function switchDisplay,
    required displayEdition,
    required BuildContext context}) {
  RoundedLoadingButtonController btnPosCtrl = RoundedLoadingButtonController();

  return Container(
      width: double.infinity,
      height: displayEdition
          ? SizeConfig.safeBlockVertical * 35
          : SizeConfig.safeBlockVertical * 10,
      decoration: BoxDecorationPrimary(context,
          topRigth: 10, topLeft: 10, bottomRigth: 10, bottomLeft: 10),
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.safeBlockVertical * 1,
        horizontal: SizeConfig.safeBlockHorizontal * 3,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.safeBlockHorizontal * 3,
        vertical: SizeConfig.safeBlockVertical * 2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  height: SizeConfig.safeBlockVertical * 8,
                  child: Column(
                    children: [
                      Text(
                        "Téléphone",
                        style: GoogleFonts.inter(
                            color: ThemeElements(
                                    context: context, mode: ColorMode.envers)
                                .themeColor,
                            fontSize: 20),
                      ),
                      SizedBox(height: SizeConfig.safeBlockVertical * 2),
                      Expanded(
                        child: Text(
                          "  " + userApp.nroTel,
                          overflow: TextOverflow.clip,
                          maxLines: 2,
                          style: GoogleFonts.inter(
                              color: ThemeElements(
                                      context: context, mode: ColorMode.envers)
                                  .themeColor
                                  .withOpacity(0.5),
                              fontSize: 15),
                        ),
                      ),
                    ],
                  )),
              BoutonsOfTheme(
                      onPressed: () {
                        switchDisplay(InfosItem.Phone);
                      },
                      context: context)
                  .edit,
            ],
          ),
          sizedCustom(display: displayEdition, coef: 4),
          Visibility(
            visible: displayEdition,
            child: TextField(
              style: TextStyle(
                  color: ThemeElements(context: context, mode: ColorMode.envers)
                      .themeColor),
              onChanged: (val) {
                setValue(val, InfosItem.Phone);
              },
              maxLines: 1,
              cursorColor: ThemeElements(context: context).whichBlue,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: ThemeElements(context: context).whichBlue,
                          width: 2.0)),
                  labelStyle: TextStyle(
                      color: ThemeElements(context: context).whichBlue),
                  labelText: "Telephone",
                  hintText: userApp.nroTel,
                  border: OutlineInputBorder()),
            ),
          ),
          sizedCustom(display: displayEdition, coef: 2),
          Visibility(
            visible: displayEdition,
            child: RoundedLoadingButton(
              color: ThemeElements(context: context).whichBlue,
              controller: btnPosCtrl,
              borderRadius: SizeConfig.safeBlockHorizontal * 3,
              successColor: Colors.lightGreenAccent,
              width: SizeConfig.safeBlockHorizontal * 40,
              elevation: SizeConfig.safeBlockHorizontal * 2,
              height: SizeConfig.safeBlockVertical * 7,
              onPressed: () async {
                if (checkPhoneNumber(editedValue(InfosItem.Phone))) {
                  userApp.nroTel = toTrimAndCase(editedValue(InfosItem.Phone));
                  await userApp.save(context);
                } else {
                  showFlushbar(context, false, "",
                      "Numéro de téléphone ne repectant pas le format");
                }

                switchDisplay(InfosItem.Phone);
              },
              child: Text(
                Strings.valider,
                style: TextStyle(color: dBlack),
              ),
            ),
          )
        ],
      ));
}

nomPrenomEditionTile(
    {required Function setValue,
    required UserApp userApp,
    required Function editedValue,
    required Function switchDisplay,
    required displayEdition,
    required BuildContext context}) {
  RoundedLoadingButtonController btnPosCtrl = RoundedLoadingButtonController();

  return Container(
      width: double.infinity,
      height: displayEdition
          ? SizeConfig.safeBlockVertical * 50
          : SizeConfig.safeBlockVertical * 10,
      decoration: BoxDecorationPrimary(context,
          topRigth: 10, topLeft: 10, bottomRigth: 10, bottomLeft: 10),
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.safeBlockVertical * 1,
        horizontal: SizeConfig.safeBlockHorizontal * 3,
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
          Row(
            children: [
              userApp.avatar(context),
              SizedBox(width: 20),
              Expanded(
                  child: Text(
                      userApp.prenom.toUpperCase() +
                          " " +
                          userApp.nom.toUpperCase(),
                      style: TextStyle(
                          color: ThemeElements(
                                  context: context, mode: ColorMode.envers)
                              .themeColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20))),
              BoutonsOfTheme(
                      onPressed: () {
                        switchDisplay(InfosItem.Nom);
                      },
                      context: context)
                  .edit,
            ],
          ),
          sizedCustom(display: displayEdition, coef: 4),
          Visibility(
            visible: displayEdition,
            child: TextField(
              style: TextStyle(
                  color: ThemeElements(context: context, mode: ColorMode.envers)
                      .themeColor),
              onChanged: (val) {
                setValue(val, InfosItem.Nom);
              },
              maxLines: 1,
              cursorColor: ThemeElements(context: context).whichBlue,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: ThemeElements(context: context).whichBlue,
                          width: 2.0)),
                  labelStyle: TextStyle(
                      color: ThemeElements(context: context).whichBlue),
                  labelText: "Nom",
                  hintText: userApp.nom,
                  border: OutlineInputBorder()),
            ),
          ),
          sizedCustom(display: displayEdition, coef: 4),
          Visibility(
            visible: displayEdition,
            child: TextField(
              style: TextStyle(
                  color: ThemeElements(context: context, mode: ColorMode.envers)
                      .themeColor),
              onChanged: (val) {
                setValue(val, InfosItem.Prenom);
              },
              maxLines: 1,
              cursorColor: ThemeElements(context: context).whichBlue,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: ThemeElements(context: context).whichBlue,
                          width: 2.0)),
                  labelStyle: TextStyle(
                      color: ThemeElements(context: context).whichBlue),
                  labelText: "Prenom",
                  hintText: userApp.nom,
                  border: OutlineInputBorder()),
            ),
          ),
          sizedCustom(display: displayEdition, coef: 2),
          Visibility(
            visible: displayEdition,
            child: RoundedLoadingButton(
              color: ThemeElements(context: context).whichBlue,
              controller: btnPosCtrl,
              borderRadius: SizeConfig.safeBlockHorizontal * 3,
              successColor: Colors.lightGreenAccent,
              width: SizeConfig.safeBlockHorizontal * 40,
              elevation: SizeConfig.safeBlockHorizontal * 2,
              height: SizeConfig.safeBlockVertical * 7,
              onPressed: () async {
                userApp.nom = isNullOrEmpty(editedValue(InfosItem.Nom))
                    ? userApp.nom
                    : editedValue(InfosItem.Nom);
                userApp.prenom = isNullOrEmpty(editedValue(InfosItem.Prenom))
                    ? userApp.prenom
                    : editedValue(InfosItem.Prenom);

                await userApp.save(context);
                switchDisplay(InfosItem.Nom);
              },
              child: Text(
                Strings.valider,
                style: TextStyle(color: dBlack),
              ),
            ),
          )
        ],
      ));
}
