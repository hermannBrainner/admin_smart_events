import '/mode_Compte/_controllers/ceremonie.dart';
import '/mode_Compte/_models/billet.dart';
import '/mode_Compte/_models/table.dart';
import '/mode_Compte/_models/zone.dart';
import '/providers/ceremonie.dart';

deleteZone(
    {required CeremonieProvider provider,
    required List<Zone> zones,
    required Function removeInListe}) async {
  await CeremonieCtrl().removeZones(provider, zones, provider.tablesInv);

  zones.forEach((elt) {
    removeInListe(elt);
  });
}

deleteBillet(
    {required CeremonieProvider provider,
    required List<Billet> billetsSelect,
    required Function removeInListe}) async {
  await CeremonieCtrl().removeBillets(
    provider,
    billetsSelect,
    provider.ceremonie!.withTables ? provider.tablesInv : provider.zonesSalle,
  );

  billetsSelect.forEach((billet) {
    removeInListe(billet);
  });
}

deleteTable(
    {required CeremonieProvider provider,
    required List<TableInvite> tablesSelect,
    required Function removeInListe}) async {
  await CeremonieCtrl()
      .removeTables(provider, tablesSelect, provider.zonesSalle);

  tablesSelect.forEach((elt) {
    removeInListe(elt);
  });
}
