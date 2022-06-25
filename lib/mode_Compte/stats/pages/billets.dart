import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/mode_Compte/stats/components/billets/indicators_widget.dart';
import '/mode_Compte/stats/components/billets/pie_chart_sections.dart';
import '/providers/ceremonie.dart';

class InvitesPage extends StatefulWidget {
  @override
  _InvitesPageState createState() => _InvitesPageState();
}

class _InvitesPageState extends State<InvitesPage> {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Consumer<CeremonieProvider>(builder: (context, provider, child) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: PageView(
          children: [
            Card(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback: (fltouchEvent, pieTouchResponse) {
                            setState(() {
                              if (fltouchEvent is FlLongPressEnd ||
                                  fltouchEvent is FlPanEndEvent) {
                                touchedIndex = -1;
                              } else {
                                if (pieTouchResponse != null) {
                                  touchedIndex = pieTouchResponse
                                      .touchedSection!.touchedSectionIndex;
                                }
                              }
                            });
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: getSections(
                            context, touchedIndex ?? -1, provider.billetsInv),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: IndicatorsWidget(billets: provider.billetsInv),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
