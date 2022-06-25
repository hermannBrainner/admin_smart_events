import 'package:flutter/material.dart';

import '/mode_Compte/_models/billet.dart';
import '/mode_Compte/_models/table.dart';
import '/mode_Compte/_models/zone.dart';
import '/outils/fonctions/fonctions.dart';
import '/outils/size_configs.dart';

class DataZone {
  final int id;
  final String name;
  final double y;
  final Color color;

  const DataZone({
    required this.name,
    required this.id,
    required this.y,
    required this.color,
  });

  static int interval = 10;

  static double largBarre(int nbreZones) {
    return (SizeConfig.safeBlockHorizontal * 30 / nbreZones);
  }

  static double longEntre(int nbreZones) {
    return (SizeConfig.safeBlockHorizontal * 56 / nbreZones);
  }

  static List<DataZone> fromBillets(List<Billet> allBillets,
      List<Zone> allZones, List<TableInvite> allTables) {
    List<Color> couleurs = [
      Color(0xff19bddf),
      Color(0xffff4d94),
      Color(0xff2bdb90),
      Color(0xffffdd80),
      Color(0xfa89dcfa),
      Color(0xfaa54d45),
      Color(0x55ff4d94),
      Color(0xfabbdcfa),
      Color(0xfac59d45),
    ];

    List<DataZone> donnees = [];

    for (Zone zo in allZones) {
      List<TableInvite> tablesZone =
          allTables.where((table) => table.idParent == zo.id).toList();

      List<Billet> billetsZone = [];

      tablesZone.forEach((table) {
        List<Billet> billetsTable =
            allBillets.where((billet) => billet.idParent == table.id).toList();
        billetsZone = billetsZone + billetsTable;
      });

      double nbreArrives = billetsZone
          .where((b) => b.estArrive)
          .toList()
          .fold(0, (prev, billet) => prev + billet.nbrePersonnes.toInt());
      double nbreAttendus = billetsZone
          .where((b) => !b.estArrive)
          .toList()
          .fold(0, (prev, billet) => prev + billet.nbrePersonnes.toInt());

      double prct = double.parse(
          doubleToString(100 * nbreArrives / (nbreAttendus + nbreArrives)));

      donnees.add(DataZone(
        id: allZones.indexOf(zo, 0),
        name: zo.nom,
        y: prct,
        color: couleurs[allZones.indexOf(zo, 0)],
      ));
    }
    return donnees;
  }
}
