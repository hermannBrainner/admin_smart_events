import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/mode_Compte/_models/user_app.dart';
import '/outils/fonctions/fonctions.dart';
import '/providers/theme/bouton_retour.dart';
import 'tiles/edition.dart';

enum InfosItem {
  Nom,
  Prenom,
  Phone,
  Email,
  EmailConfirm,
  Password,
  PasswordConfirm
}

class PageModifInfos extends StatefulWidget {
  final UserApp userApp;

  const PageModifInfos({required this.userApp});

  @override
  _PageModifInfosState createState() => _PageModifInfosState();
}

class _PageModifInfosState extends State<PageModifInfos> {
  RoundedLoadingButtonController btnPosCtrl = RoundedLoadingButtonController();

  String? inNom,
      inPrenom,
      inPhone,
      inEmail,
      inEmailConfirm,
      inPassword,
      inPasswordConfirm;

  bool displayEditionNomPrenom = false;
  bool displayEditionPhone = false;
  bool displayEditionEmail = false;
  bool displayEditionPassword = false;

  switchDisplay(InfosItem item) {
    setState(() {
      switch (item) {
        case InfosItem.Nom:
          displayEditionNomPrenom = !displayEditionNomPrenom;
          break;
        case InfosItem.Phone:
          displayEditionPhone = !displayEditionPhone;
          break;
        case InfosItem.Email:
          displayEditionEmail = !displayEditionEmail;
          break;
        case InfosItem.Password:
          displayEditionPassword = !displayEditionPassword;
          break;
      }
    });
  }

  String? editedValue(InfosItem item) {
    switch (item) {
      case InfosItem.Nom:
        return inNom;
      case InfosItem.Prenom:
        return inPrenom;
      case InfosItem.Phone:
        return inPhone;
      case InfosItem.Email:
        return inEmail;
      case InfosItem.EmailConfirm:
        return inEmailConfirm;
      case InfosItem.Password:
        return inPassword;
      case InfosItem.PasswordConfirm:
        return inPasswordConfirm;
    }
  }

  editionValue(String? value, InfosItem item) {
    setState(() {
      switch (item) {
        case InfosItem.Nom:
          inNom = toTrimAndCase(value);
          break;
        case InfosItem.Prenom:
          inPrenom = toTrimAndCase(value);
          break;
        case InfosItem.Phone:
          inPhone = toTrimAndCase(value);
          break;
        case InfosItem.Email:
          inEmail = toTrimAndCase(value);
          break;
        case InfosItem.EmailConfirm:
          inEmailConfirm = toTrimAndCase(value);
          break;
        case InfosItem.Password:
          inPassword = toTrimAndCase(value);
          break;
        case InfosItem.PasswordConfirm:
          inPasswordConfirm = toTrimAndCase(value);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Vos informations",
        ),
        leading: BoutonRetour(
          press: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        height: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              nomPrenomEditionTile(
                  setValue: editionValue,
                  userApp: widget.userApp,
                  displayEdition: displayEditionNomPrenom,
                  switchDisplay: switchDisplay,
                  context: context,
                  editedValue: editedValue),
              phoneEditionTile(
                  setValue: editionValue,
                  userApp: widget.userApp,
                  displayEdition: displayEditionPhone,
                  switchDisplay: switchDisplay,
                  context: context,
                  editedValue: editedValue),
              emailEditionTile(
                  setValue: editionValue,
                  userApp: widget.userApp,
                  displayEdition: displayEditionEmail,
                  switchDisplay: switchDisplay,
                  context: context,
                  editedValue: editedValue),
              passwordEditionTile(
                  setValue: editionValue,
                  userApp: widget.userApp,
                  displayEdition: displayEditionPassword,
                  switchDisplay: switchDisplay,
                  context: context,
                  editedValue: editedValue)
            ],
          ),
        ),
      ),
    );
  }
}
