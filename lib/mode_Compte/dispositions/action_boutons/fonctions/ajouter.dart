import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/mode_Compte/_controllers/ceremonie.dart';
import '/mode_Compte/_models/billet.dart';
import '/mode_Compte/_models/table.dart';
import '/mode_Compte/_models/zone.dart';
import '/outils/constantes/collections.dart';
import '/outils/fonctions/fonctions.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/strings.dart';

ajouterZone({
  required CeremonieProvider provider,
  required TextEditingController nomCtrl,
  required Color colorSelected,
  required Function addNewInListe,
}) async {
  if (!isNullOrEmpty(nomCtrl.text.trim())) {
    Zone zone = Zone(
        id: (await getNewID(nomCollectionZones)),
        nom: nomCtrl.text.trim(),
        couleur: colorSelected.toString(),
        idsEnfants: []);

    await CeremonieCtrl.addZone(provider.ceremonie!, zone);
    addNewInListe(zone);
  }
}

ajouterTable({
  required BuildContext context,
  required CeremonieProvider provider,
  required TextEditingController nomCtrl,
  required Color colorSelected,
  required Function addNewInListe,
}) async {
  if (!isNullOrEmpty(nomCtrl.text.trim())) {
    TableInvite table = TableInvite(
        id: (await getNewID(nomCollectionTableInvites)),
        nom: nomCtrl.text.trim(),
        couleur: colorSelected.toString(),
        idsEnfants: []);

    await CeremonieCtrl.addTable(provider.ceremonie!, table /*, context*/);
    addNewInListe(table);
  }
}

Future<String?> ajouterBillet(
    {required CeremonieProvider provider,
    required RoundedLoadingButtonController btnPosCtrl,
    required BuildContext context,
    required TextEditingController nbreCtrl,
    required TextEditingController nomCtrl,
    required List<Billet> billetsSelect,
    required Function addNewInListe}) async {
  String? msgError;

  if (provider.billetsInv.length < provider.ceremonie!.nbreBillets) {
    if (nomCtrl.text.trim().isNotEmpty && nbreCtrl.text.trim().isNotEmpty) {
      try {
        String qrCode = CeremonieCtrl.getUnusedQrCode(
            provider.ceremonie!, provider.billetsInv);
        Billet billet = Billet(
            id: await getNewID(nomCollectionBillets),
            nom: nomCtrl.text.trim(),
            qrCode: qrCode,
            nbrePersonnes: int.parse(nbreCtrl.text.trim()));
        await CeremonieCtrl.addBillet(
            provider.ceremonie!, provider.billetsInv, billet);
        addNewInListe(billet);
      } on Exception catch (e) {
        msgError = e.toString();
        if (e.runtimeType.toString().toUpperCase() == Strings.formatException) {
          msgError = "Nombre de personnes incorrect";
        }
      }
    } else {
      msgError = "Mauvaises saisies";
    }
  } else {
    msgError = "Nombre de maximum de billet atteint";
  }

  return msgError;
}
