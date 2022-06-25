import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/outils/extensions/time.dart';
import '/outils/size_configs.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/elements/boutons.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/primary_box_decoration.dart';
import '../pages/modification_details.dart';

class ItemDetailsCeremonie<String> extends StatelessWidget {
  final CeremonieProvider provider;
  final BuildContext context;

  final String item;

  static const titre = "Titre cérémonie";
  static const invites = "Nombre d'invités";
  static const lieu = "Lieu cérémonie";
  static const date = "Date";
  static const heure = "Heure";
  static const nbreBillets = "Nombre billets";

  static const items = [
    titre,
    nbreBillets,
    invites,
    lieu,
    date,
    heure,
  ];

  const ItemDetailsCeremonie({
    required this.context,
    required this.provider,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return tile;
  }

  Widget get tile {
    var texte;

    switch (item.toString()) {
      case titre:
        texte = provider.ceremonie!.titreCeremonie;
        break;
      case invites:
        texte = provider.billetsInv
            .fold(
                0,
                (int previousValue, billet) =>
                    previousValue + billet.nbrePersonnes)
            .toString();
        break;
      case lieu:
        texte = provider.ceremonie!.lieuCeremonie;
        break;

      case date:
        texte = provider.ceremonie!.dateCeremonie.toStringExt(separator: "/");
        break;
      case heure:
        texte = provider.ceremonie!.dateCeremonie.hourString();
        break;
      case nbreBillets:
        texte = provider.ceremonie!.nbreBillets.toInt().toString();
        break;

      default:
        texte = provider.ceremonie!.titreCeremonie;
        break;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            height: 80 + (texte.length > 21 ? 20 : 0),
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
                        item.toString(),
                        style: GoogleFonts.inter(
                            color: ThemeElements(
                                    context: context, mode: ColorMode.envers)
                                .themeColor
                                .withOpacity(0.7),
                            fontSize: 15),
                      ),
                      SizedBox(height: SizeConfig.safeBlockVertical * 2),
                      Expanded(
                        child: Text(
                          texte,
                          overflow: TextOverflow.clip,
                          maxLines: 2,
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              color: ThemeElements(
                                      context: context, mode: ColorMode.envers)
                                  .themeColor,
                              fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: item.toString() != invites,
                  child: BoutonsOfTheme(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PageModifDetailsCeremonie()));
                          },
                          context: context)
                      .edit,
                )
              ],
            )),
      ],
    );
  }
}
