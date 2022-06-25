import '/mode_Compte/_models/ceremonie.dart';
import '/mode_Compte/_models/table.dart';
import '/outils/fonctions/fonctions.dart';

class TableCtrl {
  static int nbreAlert(Ceremonie ceremonie, List<TableInvite> tables) {
    if (isNullOrEmpty(tables)) {
      return 0;
    }
    int nbreSansParent = ceremonie.withZones
        ? tables.where((table) => isNullOrEmpty(table.idParent)).length
        : 0;
    int nbreSansEnfant =
        tables.where((table) => table.idsEnfants.isEmpty).length;

    return nbreSansEnfant + nbreSansParent;
  }

  static Future<List<TableInvite>> manyById(List<String> ids) async {
    List<TableInvite> all = [];

    for (String id in ids) {
      TableInvite tableInvite = await TableInvite.getById(id);
      all.add(tableInvite);
    }

    return all;
  }

  static rmvHierachieByIds(List<String> ids) async {
    for (String id in ids) {
      await rmvHierachieById(id);
    }
  }

  static rmvHierachieById(String id) async {
    dynamic element = await TableInvite.getById(id);
    element.idParent = null;
    element.idsEnfants = [];
    await element.save();
  }
}
