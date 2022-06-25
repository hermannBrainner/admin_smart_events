import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '/mode_Compte/_models/billet.dart';
import '/mode_Compte/_models/table.dart';
import '/mode_Compte/_models/zone.dart';
import '/mode_Compte/stats/datas/zone.dart';
import '/outils/constantes/colors.dart';
import '/outils/constantes/strings.dart';

String retourCharriot(int id) {
  if (id % 2 == 0)
    return "";
  else
    return newLine;
}

class BarTitles {
  static AxisTitles getTopBottomTitles(List<Billet> allBillets,
      List<Zone> allZones, List<TableInvite> allTables) {
    return AxisTitles(
        sideTitles: SideTitles(
      showTitles: true,
      interval: DataZone.interval.toDouble(),
      getTitlesWidget: (double id, TitleMeta titreMeta) {
        return Text(
            retourCharriot(id.toInt()) +
                DataZone.fromBillets(allBillets, allZones, allTables)
                    .firstWhere((element) => element.id == id.toInt())
                    .name,
            style: const TextStyle(color: dWhite, fontSize: 10));
      },
    ));
  }

  static AxisTitles getSideTitles() {
    return AxisTitles(
        sideTitles: SideTitles(
      showTitles: true,
      interval: 10, //DataZone.interval.toDouble(),
      getTitlesWidget: (double value, TitleMeta titreMeta) {
        return Text(value == 0 ? '0' : '${value.toInt()}%',
            style: const TextStyle(color: dWhite, fontSize: 10));
      },
      reservedSize: 30,
    ));
  }
}
