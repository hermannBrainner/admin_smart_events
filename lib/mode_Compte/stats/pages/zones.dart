import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/mode_Compte/stats/components/zones/bar_chart_widget.dart';
import '/providers/ceremonie.dart';

class ZonesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CeremonieProvider>(builder: (context, provider, child) {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: const Color(0xff020227),
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: BarChartWidget(
            tables: provider.tablesInv,
            zones: provider.zonesSalle,
            billets: provider.billetsInv,
          ),
        ),
      );
    });
  }
}
