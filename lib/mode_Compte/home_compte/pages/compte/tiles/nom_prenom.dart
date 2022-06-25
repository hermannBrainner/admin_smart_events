import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/mode_Compte/_models/user_app.dart';
import '/outils/size_configs.dart';
import '/outils/widgets/main.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/primary_box_decoration.dart';
import '../modification_infos.dart';

deconnexionTile({required BuildContext context}) {
  double hauteur = 20;

  return Padding(
    padding: const EdgeInsets.all(30.0),
    child: InkWell(
      onTap: () => showDialog(
          context: context,
          builder: (context) =>
              boiteDeDialogue(context, signOutComplete: true)),
      child: Container(
        width: 200,
        height: hauteur * 2,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(hauteur),
            border: Border.all(
                color: ThemeElements(context: context).whichBlue, width: 1)),
        alignment: Alignment.center,
        child: Text(
          "Se déconnecter",
          style: TextStyle(
              color: ThemeElements(context: context).whichBlue,
              fontWeight: FontWeight.bold,
              fontSize: hauteur * 0.8),
        ),
      ),
    ),
  );
}

nomPrenomTile(BuildContext context, UserApp userApp) {
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      userApp.avatar(context),
      SizedBox(
        width: 20,
      ),
      Expanded(
          child: Text(
              userApp.prenom.toUpperCase() + " " + userApp.nom.toUpperCase(),
              style: TextStyle(
                  color: ThemeElements(context: context, mode: ColorMode.envers)
                      .themeColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)))
    ]),
  );
}

infosTile({required BuildContext context, required UserApp userApp}) {
  String libelle = "Vos informations";
  String texte = "Nom, prénom, e-mail, mot de passe...";

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
          height: 80 + (texte.length > 21 ? 20 : 0),
          decoration: BoxDecorationPrimary(context,
              topLeft: 10, topRigth: 10, bottomLeft: 10, bottomRigth: 10),
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
                      libelle,
                      style: GoogleFonts.inter(
                          color: ThemeElements(
                                  context: context, mode: ColorMode.envers)
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
                            color: ThemeElements(
                                    context: context, mode: ColorMode.envers)
                                .themeColor
                                .withOpacity(0.3),
                            fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PageModifInfos(
                                userApp: userApp,
                              )));
                },
                child: Icon(
                  Icons.chevron_right,
                  color: ThemeElements(context: context).whichBlue,
                  size: SizeConfig.safeBlockHorizontal * 6,
                ),
              )
            ],
          )),
    ],
  );
}
/*

themeTile(BuildContext context) {
  String libelle = "Theme";
  String texte = "Theme sombre";

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
          height: 80 + (texte.length > 21 ? 20 : 0),
          decoration: BoxDecorationPrimary(context,
              topLeft: 10, topRigth: 10, bottomLeft: 10, bottomRigth: 10),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Icon(Icons.light_mode),
                        ),
                        Text(
                          libelle,
                          style: GoogleFonts.inter(
                              color: ThemeElements(
                                      context: context, mode: ColorMode.envers)
                                  .themeColor,
                              fontSize: 20),
                        ),
                      ],
                    ),
                    SizedBox(height: SizeConfig.safeBlockVertical * 2),
                    Expanded(
                      child: Text(
                        texte,
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                        style: GoogleFonts.inter(
                            color: ThemeElements(
                                    context: context, mode: ColorMode.envers)
                                .themeColor
                                .withOpacity(0.3),
                            fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
              BoutonEdit(context: context, onPressed: () {  }).view,

            ],
          )),
    ],
  );
}
*/
