import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

import '/mode_Compte/_controllers/billet.dart';
import '/mode_Compte/_models/billet.dart';
import '/mode_Compte/_models/ceremonie.dart';
import '/mode_Compte/_models/table.dart';
import '/mode_Compte/_models/zone.dart';
import '/outils/constantes/numbers.dart';
import '/outils/fonctions/fonctions.dart';
import '/providers/ceremonie.dart';

class CeremonieCtrl {
  static Future<Ceremonie> getById(String id) async {
    late Ceremonie ceremonie;
    await Ceremonie.collection
        .where(Ceremonie.c_id, isEqualTo: id)
        .get()
        .then((user) {
      if (user.docs.isNotEmpty) {
        ceremonie =
            Ceremonie.fromJson(user.docs.first.data() as Map<String, dynamic>);
      }
    }).catchError((e) {
      return null;
    });

    return ceremonie;
  }

  Future<List<String>> initialisationImport(
      CeremonieProvider provider, int nbreImports, bool replaceAll) async {
    if (replaceAll) {
      await provider.ceremonie!.retraitAllHierachies();
      await BilletCtrl.delete(null,
          ids: provider.ceremonie!.idsBillets.cast<String>());

      provider.ceremonie!.idsBillets = [];
      provider.ceremonie!.qrCodesDispo = [];
    }

    // on genere des code pour attente
    return makeQrCodeList(provider.ceremonie!.nbreBillets.toInt());
  }

  static List<String> ajustQrcodes(
      int nbreBillets, List<String> affectedQrCodesList, List<String> allIds) {
    allIds.removeWhere((id) => !affectedQrCodesList.contains(id));

    allIds = makeQrCodeList(nbreBillets, actuelList: allIds);

    return allIds;
  }

  static List<String> makeQrCodeList(int nbreBillets,
      {List<String>? actuelList}) {
    actuelList = actuelList ?? [];

    while (actuelList.length < nbreBillets) {
      String newId = BilletCtrl.makeQrCode();

      if (!actuelList.contains(newId)) {
        actuelList.add(newId);
      }
    }

    return actuelList;
  }

  removeZones(CeremonieProvider provider, List<Zone> zones,
      List<TableInvite> allTables) async {
    for (Zone zone in zones) {
      for (String idEnfant in zone.idsEnfants.cast<String>()) {
        if (provider.ceremonie!.withTables) {
          provider.tablesInv.firstWhere((t) => t.id == idEnfant).idParent =
              null;
          await provider.tablesInv.firstWhere((t) => t.id == idEnfant).save();
        } else {
          provider.billetsInv.firstWhere((b) => b.id == idEnfant).idParent =
              null;
          await provider.billetsInv.firstWhere((b) => b.id == idEnfant).save();
        }
      }

      // Retrait de l'id dans ceremonie
      provider.ceremonie!.idsZones.remove(zone.id);
      // Suppression de la table dans sa base
      await zone.delete();
    }

    await provider.ceremonie!.save();

    //await context.read<CeremonieProvider>().loadCeremonie(ceremonie.id);
  }

  removeTables(CeremonieProvider provider, List<TableInvite> tables,
      List<Zone> allZones /*, BuildContext context*/) async {
    for (TableInvite table in tables) {
      if (!isNullOrEmpty(table.idParent)) {
        Zone zoneParent = allZones.firstWhere((z) => z.id == table.idParent);
        var index = zoneParent.idsEnfants.indexWhere((id) => id == table.id);

        zoneParent.idsEnfants.removeAt(index);
        await zoneParent.save();
      }

      for (String idEnfant in table.idsEnfants.cast<String>().toList()) {
        provider.billetsInv.firstWhere((b) => b.id == idEnfant).idParent = null;
        await provider.billetsInv.firstWhere((b) => b.id == idEnfant).save();
      }

      // Retrait de l'id dans ceremonie
      provider.ceremonie!.idsTables.remove(table.id);
      // Suppression de la table dans sa base
      await table.delete();
      await provider.ceremonie!.save();
    }
    await provider.ceremonie!.save();

    //  await context.read<CeremonieProvider>().loadCeremonie(ceremonie.id);
  }

  removeBillets(
    CeremonieProvider provider,
    List<Billet> billets,
    dynamic allParents,
    /*BuildContext context*/
  ) async {
    for (Billet billet in billets) {
      if (!isNullOrEmpty(billet.idParent)) {
        var parent = allParents.firstWhere((p) => p.id == billet.idParent);
        parent.idsEnfants!.remove(billet.id);

        if (provider.ceremonie!.withTables) {
          await parent.save();
        } else {
          await parent.save();
        }
      }

      // Retrait de l'id dans ceremonie
      provider.ceremonie!.idsBillets.remove(billet.id);
      // Suppression du billet dans sa base
      await BilletCtrl.delete(billet.id);
    }
    await provider.ceremonie!.save();
  }

  static disAssignBillet(
      {required CeremonieProvider provider, required Billet billet}) async {
    if (billet.idParent != null) {
      provider.tablesInv
          .firstWhere((z) => z.id == billet.idParent)
          .idsEnfants
          .remove(billet.id);
      await provider.tablesInv
          .firstWhere((z) => z.id == billet.idParent)
          .save();
    }
    billet.idParent = null;
    await billet.save();
    await provider.ceremonie!.save();
  }

  assignBillets(
      CeremonieProvider provider, List<Billet> billets, dynamic parent) async {
    for (Billet billet in billets) {
      await disAssignBillet(provider: provider, billet: billet);

      provider.tablesInv
          .firstWhere((z) => z.id == parent.id)
          .idsEnfants
          .add(billet.id);
      await provider.tablesInv.firstWhere((z) => z.id == parent.id).save();

      billet.idParent = parent.id;

      provider.billetsInv.firstWhere((t) => t.id == billet.id).idParent =
          parent.id;
      await provider.billetsInv.firstWhere((t) => t.id == billet.id).save();
    }
    await provider.ceremonie!.save();
  }

  assignTablesToZone(
    CeremonieProvider provider,
    List<TableInvite> tables,
    Zone zone,
  ) async {
    for (TableInvite table in tables) {
      if (table.idParent != null) {
        provider.zonesSalle
            .firstWhere((z) => z.id == table.idParent)
            .idsEnfants
            .remove(table.id);
        await provider.zonesSalle
            .firstWhere((z) => z.id == table.idParent)
            .save();
      }

      provider.zonesSalle
          .firstWhere((z) => z.id == zone.id)
          .idsEnfants
          .add(table.id);
      await provider.zonesSalle.firstWhere((z) => z.id == zone.id).save();

      table.idParent = zone.id;

      provider.tablesInv.firstWhere((t) => t.id == table.id).idParent = zone.id;
      await provider.tablesInv.firstWhere((t) => t.id == table.id).save();
    }
    await provider.ceremonie!.save();

    // await context.read<CeremonieProvider>().loadCeremonie(ceremonie.id);
  }

  static String getUnusedQrCode(Ceremonie ceremonie, List<Billet> allBillets) {
    List<String> allCodes = ceremonie.qrCodesDispo.cast<String>();
    bool bContinue = true;
    String? qrCode;
    Billet? billet;
    while (bContinue) {
      int indexRndm = getRandom(max: ceremonie.nbreBillets.toInt());

      billet =
          allBillets.firstWhereOrNull((b) => b.qrCode == allCodes[indexRndm]);

      bContinue = !isNullOrEmpty(billet);
      qrCode = allCodes[indexRndm];
    }

    return qrCode!;
  }

  refreshQrCodes(Ceremonie ceremonie, List<Billet> allBillets) async {
    List<String> affectedQrCodes =
        allBillets.map((b) => b.qrCode as String).toList();
    ceremonie.qrCodesDispo = ajustQrcodes(ceremonie.nbreBillets.toInt(),
        affectedQrCodes, ceremonie.qrCodesDispo.cast<String>());
    await ceremonie.save();
  }

  static addBillet(
      Ceremonie ceremonie, List<Billet> allbillets, Billet billet) async {
    List<String> qrCodesAffected = [];
    allbillets.forEach((b) {
      qrCodesAffected.add(b.qrCode!);
    });
    ceremonie.qrCodesDispo = ajustQrcodes(ceremonie.nbreBillets.toInt(),
        qrCodesAffected, ceremonie.qrCodesDispo.cast<String>());

    await billet.save();

    ceremonie.idsBillets.add(billet.id);
    await ceremonie.save();
  }

  static addTable(
      Ceremonie ceremonie, TableInvite table /*, BuildContext context*/) async {
    await table.save();

    ceremonie.idsTables.add(table.id);
    await ceremonie.save();
  }

  static addZone(Ceremonie ceremonie, Zone zone) async {
    await zone.save();
    ceremonie.idsZones.add(zone.id);
    await ceremonie.save();
  }

  Future<String> makeId() async {
    bool Bon = false;
    String? id;

    final snapshot = await Ceremonie.collection.get();
    if (snapshot.docs.length > 0) {
      while (!Bon) {
        id = genererCodeRandom(nbreDigits: CEREMONIE_ID_NBRE_DIGITS);
        DocumentSnapshot ds = await Ceremonie.collection.doc(id).get();
        Bon = !ds.exists;
      }
    } else {
      id = genererCodeRandom(nbreDigits: CEREMONIE_ID_NBRE_DIGITS);
    }

    return id!;
  }
}
