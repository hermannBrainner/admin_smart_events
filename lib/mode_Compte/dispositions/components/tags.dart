import 'package:flutter/material.dart';

import '/mode_Compte/_models/billet.dart';
import '/mode_Compte/_models/ceremonie.dart';
import '/mode_Compte/_models/table.dart';
import '/mode_Compte/_models/zone.dart';
import '/outils/fonctions/fonctions.dart';
import 'tags_types.dart';

Widget zoneTag(BuildContext context, Zone zone, Ceremonie ceremonie) {
  String texte;

  if (isNullOrEmpty(zone.idsEnfants.length)) {
    texte = " Aucun" + (ceremonie.withTables ? "e table" : " billet");
    return errorTag(context, texte);
  } else {
    texte = (zone.idsEnfants.length.toString() +
            (ceremonie.withTables ? " tables" : " billets"))
        .toUpperCase();
    return enfantsTag(context, texte);
  }
}

Widget billetTag(
    BuildContext context, Ceremonie ceremonie, dynamic parent, Billet billet) {
  String texte;

  if ((ceremonie.withZones || ceremonie.withTables) && !isNullOrEmpty(parent)) {
    return primaryTag(context, parent);
  } else if (ceremonie.withZones || ceremonie.withTables) {
    texte = " Aucun" + (ceremonie.withTables ? "e table" : " zone");

    return errorTag(context, texte);
  } else {
    texte = (billet.nbrePersonnes.toString() + " Personnes").toUpperCase();
    return enfantsTag(context, texte);
  }
}

Widget tableTag(BuildContext context, Ceremonie ceremonie, Zone? parent,
    TableInvite tableInvite) {
  String texte;

  if (ceremonie.withZones && !isNullOrEmpty(parent)) {
    return primaryTag(context, parent);
  } else if (ceremonie.withZones) {
    texte = " Aucune zone";
    return errorTag(context, texte);
  } else {
    if (isNullOrEmpty(tableInvite.idsEnfants.length)) {
      texte = " Aucun billet";
      return errorTag(context, texte);
    } else {
      texte =
          (tableInvite.idsEnfants.length.toString() + " billets").toUpperCase();
      return enfantsTag(context, texte);
    }
  }
}
