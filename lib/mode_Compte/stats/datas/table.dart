import '/mode_Compte/_models/billet.dart';
import '/mode_Compte/_models/table.dart';

class DataTableInvites {
  final int id;

  final String name;

  final double percent;

  DataTableInvites(
      {required this.name, required this.percent, required this.id});

  static List<DataTableInvites> fromBillets(
      List<Billet> billets, List<TableInvite> tables) {
    List<DataTableInvites> donnees = [];

    for (TableInvite table in tables) {
      double nbreArrives = billets
          .where((b) => b.estArrive && table.id == b.idParent)
          .toList()
          .fold(0, (prev, billet) => prev + billet.nbrePersonnes.toInt());
      double nbreAttendus = billets
          .where((b) => !b.estArrive && table.id == b.idParent)
          .toList()
          .fold(0, (prev, billet) => prev + billet.nbrePersonnes.toInt());

      double prct = 100 * nbreArrives / (nbreAttendus + nbreArrives);

      if (prct.isNaN) {
        prct = 0;
      }

      donnees.add(DataTableInvites(
        name: table.nom,
        percent: prct,
        id: tables.indexOf(table),
      ));
    }
    return donnees;
  }
}
