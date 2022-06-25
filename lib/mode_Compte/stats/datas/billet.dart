import 'package:flutter/material.dart';

import '/mode_Compte/_models/billet.dart';

class DataInvites {
  final String name;

  final double percent;

  final Color color;

  DataInvites({required this.name, required this.percent, required this.color});

  static List<DataInvites> fromBillets(List<Billet> billets) {
    int totalArrives = billets
        .where((b) => b.estArrive)
        .toList()
        .fold(0, (prev, billet) => prev + billet.nbrePersonnes.toInt());
    int totalAttendus = billets
        .where((b) => !b.estArrive)
        .toList()
        .fold(0, (prev, billet) => prev + billet.nbrePersonnes.toInt());
    int total = totalAttendus + totalArrives;

    List<DataInvites> donnees = [
      DataInvites(
          name: 'Arrivés',
          percent:
              double.parse((100 * totalArrives / total).toStringAsFixed(2)),
          color: Colors.lightGreen),
      DataInvites(
          name: 'Attendus',
          percent:
              double.parse((100 * totalAttendus / total).toStringAsFixed(2)),
          color: const Color(0xfff8b250)),
    ];

    return donnees;
  }
}
