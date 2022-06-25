import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '/mode_Compte/_models/billet.dart';
import '/mode_Compte/stats/datas/billet.dart';
import '/providers/theme/elements/main.dart';

List<PieChartSectionData> getSections(
        BuildContext context, int touchedIndex, List<Billet> billets) =>
    DataInvites.fromBillets(billets)
        .asMap()
        .map<int, PieChartSectionData>((index, data) {
          final isTouched = index == touchedIndex;
          final double fontSize = isTouched ? 25 : 16;
          final double radius = isTouched ? 100 : 80;

          final value = PieChartSectionData(
            color: data.color,
            value: data.percent,
            title: '${data.percent}%',
            radius: radius,
            titleStyle: ThemeElements(context: context).styleText(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );

          return MapEntry(index, value);
        })
        .values
        .toList();
