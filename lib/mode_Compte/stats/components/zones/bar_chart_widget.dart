import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '/mode_Compte/_models/billet.dart';
import '/mode_Compte/_models/table.dart';
import '/mode_Compte/_models/zone.dart';
import '/mode_Compte/stats/datas/zone.dart';
import '/outils/widgets/main.dart';
import 'bar_titles.dart';

class BarChartWidget extends StatelessWidget {
  List<Zone> zones;

  List<Billet> billets;

  List<TableInvite> tables;

  BarChartWidget(
      {required this.zones, required this.billets, required this.tables});

  @override
  Widget build(BuildContext context) {
    if (zones.isNotEmpty) {
      return BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceEvenly,
          maxY: 100,
          minY: 0,
          groupsSpace: DataZone.longEntre(this.zones.length),
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            topTitles: BarTitles.getTopBottomTitles(
                this.billets, this.zones, this.tables),
            bottomTitles: BarTitles.getTopBottomTitles(
                this.billets, this.zones, this.tables),
            // leftTitles: BarTitles.getSideTitles(),
            rightTitles: BarTitles.getSideTitles(),
          ),
          gridData: FlGridData(
            checkToShowHorizontalLine: (value) =>
                value % DataZone.interval == 0,
            getDrawingHorizontalLine: (value) {
              if (value == 0) {
                return FlLine(
                  color: const Color(0xff363753),
                  strokeWidth: 3,
                );
              } else {
                return FlLine(
                  color: const Color(0xff2a2747),
                  strokeWidth: 0.8,
                );
              }
            },
          ),
          barGroups: DataZone.fromBillets(this.billets, this.zones, this.tables)
              .map(
                (data) => BarChartGroupData(
                  x: data.id,
                  barRods: [
                    BarChartRodData(
                      toY: data.y,
                      width: DataZone.largBarre(this.zones.length),
                      color: data.color,
                      borderRadius: data.y > 0
                          ? BorderRadius.only(
                              topLeft: Radius.circular(6),
                              topRight: Radius.circular(6),
                            )
                          : BorderRadius.only(
                              bottomLeft: Radius.circular(6),
                              bottomRight: Radius.circular(6),
                            ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      );
    } else {
      return getLoadingWidget(context, taille: 200);
    }
  }
}
