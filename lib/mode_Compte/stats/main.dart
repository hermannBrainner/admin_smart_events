import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/auth/drawer/main.dart';
import '/outils/widgets/main.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/strings.dart';
import 'components/haut_page_main.dart';

class StatsMainView extends StatelessWidget {
  static const String routeName = "/statInvites_view";

  @override
  Widget build(BuildContext context) {
    return Consumer<CeremonieProvider>(builder: (context, provider, child) {
      return DefaultTabController(
          length: nbreTabs(provider.ceremonie!),
          child: Scaffold(
              drawer: UsefulDrawer(),
              appBar: appBar(Strings.menuStats, context,
                  bottom: makeTabBar(provider)),
              body: makeTabBarview(provider.ceremonie!)));
    }

/*    return Scaffold(
      drawer: UsefulDrawer(),
      appBar:  appBar(Strings.menuStats, context)   ,
      body:   DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Container(
              height: SizeConfig.safeBlockVertical*90,
              child: TabBarView(

                children: [

                  InvitesPage( ),
                  TablesPage(),
                  ZonesPage()




                ],
              ),
            ),
          ],
        ),
      ),

    );*/

        );
  }
}
