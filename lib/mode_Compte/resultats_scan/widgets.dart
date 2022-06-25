import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/mode_Compte/_models/billet.dart';
import '/mode_Compte/verification/home.dart';
import '/outils/constantes/colors.dart';
import '/outils/fonctions/dates.dart';
import '/outils/fonctions/fonctions.dart';
import '/outils/size_configs.dart';
import '/providers/ceremonie.dart';

enum typeResultat { A_VALIDE, DEJA_VALIDE, INVALIDE }

separateur() {
  return SizedBox(
    height: 15,
    child: Container(
      color: Color.fromRGBO(221, 223, 225, 0.99),
    ),
  );
}

bouton(
  Billet billet,
  typeResultat filtre,
  BuildContext context,
) {
  final RoundedLoadingButtonController btnCtrl =
      RoundedLoadingButtonController();

  Color couleur;
  String texte;

  switch (filtre) {
    case typeResultat.A_VALIDE:
      couleur = Colors.amberAccent;
      texte = "VALIDER LE BILLET";
      break;
    case typeResultat.DEJA_VALIDE:
      couleur = billet.estSorti ? Colors.lime : Colors.lightBlueAccent;
      texte = billet.estSorti ? "RETOUR EN SALLE" : "VALIDER LA SORTIE";
      break;
    case typeResultat.INVALIDE:
      couleur = Colors.brown;
      texte = "NOUVEAU SCAN";
      break;
  }

  double largeur = SizeConfig.safeBlockHorizontal * 70;

  return Padding(
    padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 2),
    child: RoundedLoadingButton(
      //  width:largeur,
      elevation: largeur * (8 / 100),
      height: largeur / 4,
      borderRadius: largeur / 25,
      color: couleur,

      // duration: Duration(seconds: 5) ,
      successColor: Colors.lightGreenAccent,
      // margin:  EdgeInsets.symmetric(horizontal: largeur/20),
      child: Center(
          child: Text(
        texte,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: dWhite, fontSize: largeur / 13, fontWeight: FontWeight.bold),
      )),
      controller: btnCtrl,
      onPressed: () async {
        btnCtrl.start();

        if (filtre == typeResultat.DEJA_VALIDE) {
          await billet.switchEntreeSortie();
          btnCtrl.success();
        } else if (filtre == typeResultat.A_VALIDE) {
          await billet.valider();
          btnCtrl.success();
        }

        await wait(nbreSeconde: 1);

        await context.read<CeremonieProvider>().refreshOnlyBillets();
        Navigator.pushReplacementNamed(context, VerifMain.routeName);
      },
    ),
  );
}

sousDetails(String titre, String detail, hauteur) {
  double dTailleDetail = hauteur / 3;
  return Container(
    height: hauteur,
    alignment: Alignment.bottomLeft,
    margin: EdgeInsets.all(hauteur / 5),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titre,
          style: TextStyle(
              color: Colors.blueAccent, fontSize: dTailleDetail * 0.7),
        ),
        Text(
          "  " + detail,
          style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: dTailleDetail),
        ),
      ],
    ),
  );
}

sousDetails_Disposition(
    Billet billet, double dHauteurDetail, CeremonieProvider provider) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      if (!isNullOrEmpty(billet.getMyZone(provider)))
        sousDetails("ZONE", billet.getMyZone(provider)!.nom, dHauteurDetail),
      if (!isNullOrEmpty(billet.getMyTable(provider)))
        sousDetails("TABLE", billet.getMyTable(provider)!.nom, dHauteurDetail),
    ],
  );
}

details(Billet billet, double hauteur, typeResultat filtre,
    CeremonieProvider provider) {
  double dHauteurDetail = hauteur / 7;
  return Container(
    height: hauteur,
    alignment: Alignment.bottomCenter,
    // color: Colors.pink,

    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Informations du billet",
          style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
              fontSize: hauteur / 12),
        ),
        sousDetails("NOM INVITÉ", billet.nom, dHauteurDetail),
        sousDetails("NOMBRE DE PERSONNES", billet.nbrePersonnes.toString(),
            dHauteurDetail),
        sousDetails_Disposition(billet, dHauteurDetail, provider)
      ],
    ),
  );
}

corps(Billet? billet, typeResultat filtre, BuildContext context,
    CeremonieProvider provider) {
  return Container(
    height: SizeConfig.safeBlockVertical * 70,
    alignment: Alignment.bottomCenter,
    // color: Colors.pink,

    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (!(filtre == typeResultat.INVALIDE))
          details(billet!, SizeConfig.safeBlockVertical * 70 * 0.8, filtre,
              provider),
        bouton(billet!, filtre, context)
      ],
    ),
  );
}

entete(typeResultat filtre) {
  IconData ic;
  String texte;
  Color couleur;
  double hauteur = SizeConfig.safeBlockVertical * 15;
  double heigthIcone = hauteur / 2;
  double dEspacement = hauteur / 10;
  double dTailleTexte = hauteur / 3;

  switch (filtre) {
    case typeResultat.A_VALIDE:
      couleur = Colors.greenAccent;
      ic = Icons.check_circle_outline_rounded;
      texte = "Billet valide";
      break;
    case typeResultat.DEJA_VALIDE:
      couleur = Colors.orangeAccent;
      ic = Icons.warning_amber_outlined;
      texte = "Billet déjà validé";
      break;
    case typeResultat.INVALIDE:
      couleur = Colors.redAccent;
      ic = Icons.cancel_outlined;
      texte = "Billet invalide";
      break;
  }

  return Container(
    width: double.infinity,
    height: hauteur,
    alignment: Alignment.center,
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            ic,
            color: couleur,
            size: heigthIcone,
          ),
          SizedBox(
            width: dEspacement,
          ),
          Text(
            texte,
            style: TextStyle(
                fontSize: dTailleTexte,
                color: couleur,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    ),
  );
}
