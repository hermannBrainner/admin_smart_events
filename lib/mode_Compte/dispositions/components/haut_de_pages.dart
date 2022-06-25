import 'package:flutter/material.dart';

import '/mode_Compte/_models/ceremonie.dart';
import '/mode_Compte/dispositions/pages/billets.dart';
import '/mode_Compte/dispositions/pages/tables.dart';
import '/mode_Compte/dispositions/pages/zones.dart';
import '/outils/constantes/colors.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/strings.dart';

TabBarView makeTabBarview(
    CeremonieProvider provider, Function editNbreSelected) {
  Widget wZ =
      ZonesListDispo(provider: provider, editNbreSelected: editNbreSelected);
  Widget wT =
      TablesListDispo(provider: provider, editNbreSelected: editNbreSelected);
  Widget wB = BilletsListDispo(
    provider: provider,
    editNbreSelected: editNbreSelected,
  );

  List<Widget> all = [wZ, wT, wB];

  if (!provider.ceremonie!.withZones) all.remove(wZ);
  if (!provider.ceremonie!.withTables) all.remove(wT);

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

Widget iconAlert(BuildContext context, int nbre) {
  if (nbre > 0) {
    return CircleAvatar(
      radius: 10,
      backgroundColor: Colors.red,
      child: Center(
        child: Text(
          (nbre).toString(),
          style: ThemeElements(context: context).styleText(
            color: dWhite,
            fontSize: 8,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  } else {
    return const Center();
  }
}

Widget tab(BuildContext context, String titre, Map<String, int> data) {
  return Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(titre),
        SizedBox(
          width: 5,
        ),
        iconAlert(context, data[titre]!)
      ],
    ),
  );
}

TabBar makeTabBar(BuildContext context, CeremonieProvider provider) {
  Map<String, int> data = provider.getAlertNbres();

  Tab tZ = Tab(
      child: tab(context, Strings.dispoZones,
          data)); //Tab( text: Strings.dispoZones, icon: iconAlert( data[Strings.dispoZones]     ), );
  Tab tT = Tab(child: tab(context, Strings.dispoTables, data));
  Tab tB = Tab(
      child: tab(context, Strings.dispoBillets,
          data)); //Tab( text: Strings.dispoBillets, icon: iconAlert( data[Strings.dispoBillets]     ), );

  List<Tab> all = [tZ, tT, tB];

  if (!provider.ceremonie!.withZones) all.remove(tZ);
  if (!provider.ceremonie!.withTables) all.remove(tT);

  return TabBar(
    tabs: all,
  );
}
