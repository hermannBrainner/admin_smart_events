import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/auth/drawer/main.dart';
import '/outils/widgets/main.dart';
import '/outils/widgets/no_data.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/strings.dart';
import 'pages/liste.dart';

class InstallationsMainView extends StatelessWidget {
  static const String routeName = "/installationInvites_view";

  @override
  Widget build(BuildContext context) {
    RoundedLoadingButtonController btnCtrl = RoundedLoadingButtonController();
    return DefaultTabController(
        length: 1,
        child: Scaffold(
            drawer: UsefulDrawer(),
            appBar: appBar(Strings.pageInstallation, context),
            body: Consumer<CeremonieProvider>(
                builder: (context, provider, child) {
              if (provider.billetsInv
                  .where((billet) => billet.estArrive && !billet.estInstalle)
                  .toList()
                  .isEmpty) {
                return noData_Invites(context,
                    btnCtrl: btnCtrl, provider: provider);
              } else {
                return InstallationsList(
                  provider: provider,
                );
              }
            })));
  }
}
