import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/mode_Compte/stats/datas/table.dart';
import '/providers/ceremonie.dart';
import '../components/tables/progressbar.dart';

class TablesPage extends StatefulWidget {
  @override
  _TablesPageState createState() => _TablesPageState();
}

class _TablesPageState extends State<TablesPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CeremonieProvider>(builder: (context, provider, child) {
      List<DataTableInvites> dataTInv = DataTableInvites.fromBillets(
        provider.billetsInv,
        provider.tablesInv,
      );

      return Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: dataTInv.length,
          itemBuilder: (context, id) {
            return Card(
                elevation: 5.0,
                margin:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                child: logTableInvites(dataTInv[id], context));
          },
        ),
      );
    });
  }
}
