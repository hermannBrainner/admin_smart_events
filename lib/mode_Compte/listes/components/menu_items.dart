import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/mode_Compte/_models/billet.dart';
import '/mode_Compte/_models/table.dart';
import '/mode_Compte/_models/zone.dart';
import '/outils/fonctions/fonctions.dart';
import '/providers/theme/elements/main.dart';

class ItemMenuListesInvites<String> extends StatelessWidget {
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;

  static const arrives = "Arrivés";
  static const attendus = "Attendus";
  static const en_salle = "En salle";
  static const ressortis = "Ressortis";

  static const menuItems = [arrives, attendus, en_salle, ressortis];

  const ItemMenuListesInvites({
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  static List<TableInvite> filterTables(
      {dynamic query, required List<TableInvite> all}) {
    if (isNullOrEmpty(query)) {
      return all;
    } else {
      return List<TableInvite>.from(all.where(
              (s_e) => s_e.nom.toLowerCase().contains(query.toLowerCase())))
          .toList();
    }
  }

  static List<Zone> filterZones({dynamic query, required List<Zone> all}) {
    if (isNullOrEmpty(query)) {
      return all;
    } else {
      return List<Zone>.from(all.where(
              (s_e) => s_e.nom.toLowerCase().contains(query.toLowerCase())))
          .toList();
    }
  }

  static List<Billet> filter(
      {dynamic menuCourant, dynamic query, required List<Billet> billets}) {
    List<Billet> listFiltree = [];

    switch (menuCourant) {
      case arrives:
        listFiltree = List<Billet>.from(billets.where((billet) =>
            billet.estArrive &&
            billet.nom.toLowerCase().contains(query.toLowerCase()))).toList();
        break;
      case attendus:
        listFiltree = List<Billet>.from(billets.where((s_e) =>
            !s_e.estArrive &&
            s_e.nom.toLowerCase().contains(query.toLowerCase()))).toList();
        break;
      case en_salle:
        listFiltree = List<Billet>.from(billets.where((billet) =>
            billet.estArrive &&
            !billet.estSorti &&
            billet.nom.toLowerCase().contains(query.toLowerCase()))).toList();
        break;

      case ressortis:
        listFiltree = List<Billet>.from(billets.where((s_e) =>
            s_e.estArrive &&
            s_e.estSorti &&
            s_e.nom.toLowerCase().contains(query.toLowerCase()))).toList();
        break;

      default:
        if (isNullOrEmpty(query)) {
          listFiltree = billets;
        } else {
          listFiltree = List<Billet>.from(billets.where(
                  (s_e) => s_e.nom.toLowerCase().contains(query.toLowerCase())))
              .toList();
        }

        break;
    }

    listFiltree.sort(Billet.compArrivee_Parent_Nom);

    return listFiltree;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(value),
      child: _customRadioButton(context),
    );
  }

  Widget _customRadioButton(context) {
    final isSelected = value == groupValue;

    final couleurTexte = isSelected
        ? ThemeElements(context: context, mode: ColorMode.envers).themeColor
        : ThemeElements(context: context, mode: ColorMode.envers)
            .themeColor
            .withOpacity(0.5);
    final double tailleTexte = isSelected ? 32 : 29;
    final font = isSelected ? FontWeight.bold : FontWeight.normal;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            margin: const EdgeInsets.only(right: 30),
            child: Text(
              value.toString(),
              style: GoogleFonts.inter(
                  fontWeight: font, color: couleurTexte, fontSize: tailleTexte),
            )),
      ],
    );
  }
}
