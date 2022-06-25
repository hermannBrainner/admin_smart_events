import '/mode_Compte/_models/table.dart';
import '/mode_Compte/_models/zone.dart';
import '/providers/ceremonie.dart';

class CercleOfTables {
  List<TableInvite> tablesEnfatns;
  final int idx;

  CercleOfTables({
    required this.tablesEnfatns,
    required this.idx,
  });

  static List<CercleOfTables> build_Cercles(
      CeremonieProvider provider, Zone zone) {
    List<CercleOfTables> all = [];

    CercleOfTables c1 = CercleOfTables(idx: 1, tablesEnfatns: []);
    CercleOfTables c2 = CercleOfTables(idx: 2, tablesEnfatns: []);
    CercleOfTables c3 = CercleOfTables(idx: 3, tablesEnfatns: []);
    CercleOfTables c4 = CercleOfTables(idx: 4, tablesEnfatns: []);

    for (TableInvite table in provider.tablesInv
        .where((table) => zone.idsEnfants.cast<String>().contains(table.id))
        .toList()) {
      if (c3.tablesEnfatns.length < 8) {
        c3.tablesEnfatns.add(table);
      } else if (c2.tablesEnfatns.length < 8) {
        c2.tablesEnfatns.add(table);
      } else if (c1.tablesEnfatns.length < 4) {
        c1.tablesEnfatns.add(table);
      } else {
        c4.tablesEnfatns.add(table);
      }
    }

    all.addAll([c1, c2, c3, c4]);

    all.removeWhere((c) => c.tablesEnfatns.isEmpty);
    return all;
  }
}
