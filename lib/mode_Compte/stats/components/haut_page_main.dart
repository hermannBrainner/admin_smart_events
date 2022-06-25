import 'package:flutter/material.dart';

import '/mode_Compte/_models/ceremonie.dart';
import '/mode_Compte/stats/pages/billets.dart';
import '/mode_Compte/stats/pages/tables.dart';
import '/mode_Compte/stats/pages/zones.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/strings.dart';

TabBarView makeTabBarview(Ceremonie c) {
  Widget wZ = ZonesPage();
  Widget wT = TablesPage();
  Widget wB = InvitesPage();

  List<Widget> all = [wZ, wT, wB];

  if (!c.withZones) all.remove(wZ);
  if (!c.withTables) all.remove(wT);

  return TabBarView(
    children: all,
  );
}

int nbreTabs(Ceremonie c) {
  int total = 3;

  if (!c.withZones) total -= 1;
  if (!c.withTables) total -= 1;

  return total;
}

Widget tab(String titre, Map<String, int> data) {
  return Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(titre),
      ],
    ),
  );
}

TabBar makeTabBar(CeremonieProvider provider) {
  Map<String, int> data = provider.getAlertNbres();

  Tab tZ = Tab(
      child: tab(Strings.dispoZones,
          data)); //Tab( text: Strings.dispoZones, icon: iconAlert( data[Strings.dispoZones]     ), );
  Tab tT = Tab(child: tab(Strings.dispoTables, data));
  Tab tB = Tab(
      child: tab(Strings.dispoBillets,
          data)); //Tab( text: Strings.dispoBillets, icon: iconAlert( data[Strings.dispoBillets]     ), );

  List<Tab> all = [tZ, tT, tB];

  if (!provider.ceremonie!.withZones) all.remove(tZ);
  if (!provider.ceremonie!.withTables) all.remove(tT);

  return TabBar(
    tabs: all,
  );
}
