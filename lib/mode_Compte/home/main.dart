import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/auth/drawer/main.dart';
import '/mode_Compte/home/liste.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/bouton_retour.dart';

class ParametresMainView extends StatelessWidget {
  static const String routeName = "/ParametresMainView";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: UsefulDrawer(),
      appBar: AppBar(
        leading: BoutonLeading(),
        //    backgroundColor: dBlack,
      ),
      body: Consumer<CeremonieProvider>(builder: (context, provider, child) {
        return HomeListe(provider: provider);
      }),
    );
  }
}
