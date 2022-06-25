import '/mode_Compte/_models/billet.dart';
import '/mode_Compte/_models/table.dart';
import '/providers/ceremonie.dart';

class Invite {
  final String nom;
  final int index;

  Invite({
    required this.nom,
    required this.index,
  });

  static List<Invite> fromBillet(Billet billet, int lastIndex) {
    List<Invite> all = [];

    for (int idx = lastIndex; idx < lastIndex + billet.nbrePersonnes; idx++) {
      String asterix;

      if (billet.nbrePersonnes == 1) {
        asterix = "";
      } else {
        asterix = "    (${new List.filled(idx - lastIndex + 1, "*").join()})";
      }

      Invite invite = Invite(index: idx, nom: billet.nom + asterix);
      all.add(invite);
    }
    return all;
  }

  static List<Invite> fromTable(CeremonieProvider provider, TableInvite table) {
    List<Invite> all = [];

    table.idsEnfants.forEach((idEnfant) {
      var billet = provider.billetsInv.firstWhere((b) => b.id == idEnfant);
      List<Invite> temp = Invite.fromBillet(billet, all.length);
      all.addAll(temp);
    });

    return all;
  }
}
