import '/mode_Compte/_controllers/ceremonie.dart';
import '/mode_Compte/_models/billet.dart';
import '/mode_Compte/_models/table.dart';
import '/mode_Compte/_models/zone.dart';
import '/providers/ceremonie.dart';

affecterTable({
  required CeremonieProvider provider,
  required List<TableInvite> tablesSelect,
  required Zone parentSelected,
}) async {
  await CeremonieCtrl().assignTablesToZone(
    provider,
    tablesSelect,
    parentSelected,
  );
}

affecterBillet({
  required CeremonieProvider provider,
  required List<Billet> billetsSelect,
  required TableInvite parentSelected,
}) async {
  await CeremonieCtrl().assignBillets(
    provider,
    billetsSelect,
    parentSelected,
  );
}
