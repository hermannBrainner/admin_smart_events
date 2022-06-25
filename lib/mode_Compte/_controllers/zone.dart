import '/mode_Compte/_models/ceremonie.dart';
import '/mode_Compte/_models/zone.dart';
import '/outils/fonctions/fonctions.dart';

class ZoneCtrl {
  static int nbreAlert(Ceremonie ceremonie, List<Zone> zones) {
    int nbreSansEnfant;

    if (isNullOrEmpty(zones)) {
      nbreSansEnfant = 0;
    } else {
      nbreSansEnfant = zones.where((zone) => zone.idsEnfants.isEmpty).length;
    }

    return nbreSansEnfant;
  }

  static rmvHierachieByIds(List<String> ids) async {
    for (String id in ids) {
      await rmvHierachieById(id);
    }
  }

  static rmvHierachieById(String id) async {
    Zone zone = await Zone.getById(id);
    zone.idsEnfants = [];
    await zone.save();
  }

  Future<List<Zone>> manyById(List<String> ids) async {
    List<Zone> all = [];

    for (String id in ids) {
      Zone zone = await Zone.getById(id);
      all.add(zone);
    }

    return all;
  }
}
