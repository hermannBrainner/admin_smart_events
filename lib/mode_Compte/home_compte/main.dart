import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/mode_Compte/home_compte/chapeau.dart';
import '/outils/peintures.dart';
import '/outils/size_configs.dart';
import '/outils/widgets/main.dart';
import '/providers/theme/bouton_retour.dart';
import '/providers/user_app.dart';
import 'menu_items.dart';
import 'pages/ceremonies/main.dart';
import 'pages/compte/main.dart';
import 'pages/parrainage/main.dart';

class HomeCompte extends StatefulWidget {
  static const String routeName = "/HomeCompteView";

  @override
  HomeCompteState createState() => HomeCompteState();
}

class HomeCompteState extends State<HomeCompte> {
  // int randInt = (new Random()).nextInt(ItemMenuCeremonie.allItems.length);
  String itemCourant = ItemMenuCeremonie
      .ceremonie; //allItems[(new Random()).nextInt(ItemMenuCeremonie.allItems.length)];

  @override
  void initState() {
    super.initState();
  }

  switchItem(String item) {
    setState(() {
      itemCourant = item;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
        appBar: AppBar(
          leading: BoutonRetour(
            press: () => showDialog(
                context: context,
                builder: (context) =>
                    boiteDeDialogue(context, signOutComplete: true)),
          ),
        ),
        body: Consumer<UserAppProvider>(builder: (context, provider, child) {
          return CustomPaint(
            painter: toileBas(context: context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                chapeauCeremonies(context,
                    fctSwitch: switchItem, itemCourant: itemCourant),
                if (itemCourant == ItemMenuCeremonie.ceremonie)
                  Expanded(
                    child: PageCeremonies(userApp: provider.userApp!),
                  ),
                if (itemCourant == ItemMenuCeremonie.compte)
                  Expanded(
                    child: PageCompte(userApp: provider.userApp!),
                  ),
                if (itemCourant == ItemMenuCeremonie.parrainage)
                  PageParrainage(userApp: provider.userApp!),
              ],
            ),
          );
        }));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
