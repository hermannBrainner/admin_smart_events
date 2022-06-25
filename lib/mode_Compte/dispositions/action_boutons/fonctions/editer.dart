import 'package:flutter/material.dart';

import '/mode_Compte/_models/billet.dart';
import '/mode_Compte/_models/table.dart';
import '/mode_Compte/_models/zone.dart';
import '/outils/extensions/string.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/strings.dart';

editerZone({
  required CeremonieProvider provider,
  required Color colorSelected,
  required TextEditingController nomCtrl,
  required Zone zone,
}) async {
  if (nomCtrl.text.trim().isNotEmpty ||
      (zone.couleur != colorSelected.toString())) {
    zone.nom = nomCtrl.text.trim().isNotEmpty ? nomCtrl.text.trim() : zone.nom;
    zone.couleur = colorSelected.toString();
    await zone.save();
  }
}

editerTable({
  required CeremonieProvider provider,
  required Color colorSelected,
  required TextEditingController nomCtrl,
  required TableInvite table,
}) async {
  if (nomCtrl.text.trim().isNotEmpty ||
      (table.couleur != colorSelected.toString())) {
    table.nom =
        nomCtrl.text.trim().isNotEmpty ? nomCtrl.text.trim() : table.nom;
    table.couleur = colorSelected.toString();

    await table.save();
  }
}

editerBillet({
  required CeremonieProvider provider,
  required String? msgError,
  required TextEditingController nbreCtrl,
  required TextEditingController nomCtrl,
  required Billet billet,
}) async {
  if (nomCtrl.text.trim().isNotEmpty || nbreCtrl.text.trim().isNotEmpty) {
    try {
      billet.nom =
          nomCtrl.text.trim().isNotEmpty ? nomCtrl.text.trim() : billet.nom;
      billet.nbrePersonnes = nbreCtrl.text.isInt()
          ? int.parse(nbreCtrl.text)
          : billet.nbrePersonnes;

      await billet.save();
    } on Exception catch (e) {
      msgError = e.toString();
      if (e.runtimeType.toString().toUpperCase() == Strings.formatException) {
        msgError = "Nombre de personnes incorrect";
      }
    }
  } else {
    msgError = "Mauvaises saisies";
  }
}
