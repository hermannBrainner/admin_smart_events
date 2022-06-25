/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/outils/extensions/string.dart';
import 'package:provider/provider.dart';

import '/mode_Compte/dispositions/main.dart';
import '/mode_Compte/exports/components/modal_bottom.dart';
import '/mode_Compte/exports/main.dart';
import '/mode_Compte/home/main.dart';
import '/mode_Compte/imports/main.dart';
import '/mode_Compte/installations/main.dart';
import '/mode_Compte/listes/main.dart';
import '/outils/strings.dart';
import '/outils/fonctions.dart';
import '/outils/size_configs.dart';
import '/outils/strings.dart';
import '/providers/theme/bouton_retour.dart';
import '/outils/main.dart';
import '/providers/ceremonie.dart';
import '/providers/theme.dart';
import '/mode_Compte/stats/main.dart';
import '/mode_Compte/verification/home.dart';
import '../sign_out.dart';
import 'ampoule.dart';
double coef = 4;
double coefText = 2;

drawerBody(ThemeProvider provider, Function onPress ){
  return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData) {
          return getLoadingWidget(context);
        } else {
          final user = userSnapshot.data as User;
          return Drawer(
              shape: RoundedRectangleBorder(
                  side: BorderSide(),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      bottomRight: Radius.circular(40))),
              child: Stack(
                children: [
                  Positioned(
                    right: 0, //230.0,
                    top : 0, //40.0,
                    child: GestureDetector(
                      onTap: () {
                        onPress(provider);
                      },
                      child: new Container(
                        height: MediaQuery.of(context).size.height / 5.5,
                        width: MediaQuery.of(context).size.height / 15,
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30)),
                          shape: BoxShape.rectangle,
                          color: Theme.of(context).hoverColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 14, right: 14, bottom: 28),
                          child: provider.themeData.brightness==Brightness.light
                              ? Image.asset(
                            "assets/bulb_on.png",
                            fit: BoxFit.fitHeight,
                          )
                              : Image.asset(
                            "assets/bulb_off.png",
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Padding(
                          child: ampoule(),
                          padding: EdgeInsets.symmetric( horizontal: 30)),

                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 1,
                      ),
                      if (!user.isAnonymous) blockNormal(context),
                      blockInvite(context),
                      blockLogOut(context, user.isAnonymous),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 3,
                      ),
                    ],
                  ),
                )],
              ));
        }
      });

}



Widget blockInvite(BuildContext context) {
  return Column(
    children: [
      Divider(
          color: Colors.black, height: SizeConfig.safeBlockVertical * coef),
      ListTile(
          leading: Icon(
            Icons.location_searching_sharp,
            color: couleurIcon,
            size: SizeConfig.safeBlockVertical * coef,
          ),
          title: Text(
            Strings.menuVerif,
            style:
            TextStyle(fontSize: SizeConfig.safeBlockVertical * coefText),
          ),
          onTap: () => {Navigator.pushNamed(context, VerifMain.routeName)}),
      ListTile(
          leading: Icon(
            Icons.list_alt_outlined,
            color: couleurIcon,
            size: SizeConfig.safeBlockVertical * coef,
          ),
          title: Text(
            Strings.menuListeInv,
            style:
            TextStyle(fontSize: SizeConfig.safeBlockVertical * coefText),
          ),
          onTap: () =>
          {Navigator.pushNamed(context, ListesMainView.routeName)}),
      itemInstallations(context, coef, coefText, couleurIcon),
      ListTile(
          leading: Icon(
            Icons.query_stats,
            color: couleurIcon,
            size: SizeConfig.safeBlockVertical * coef,
          ),
          title: Text(
            Strings.menuStats,
            style:
            TextStyle(fontSize: SizeConfig.safeBlockVertical * coefText),
          ),
          onTap: () =>
          {Navigator.pushNamed(context, StatsMainView.routeName)}),
    ],
  );
}

Widget blockLogOut(BuildContext context, bool isInvite) {
  return Column(children: [
    Divider(color: Colors.black, height: SizeConfig.safeBlockVertical * coef),
    InkWell(
      onTap: () async {
        await signOut(context, isInvite);
      },
      child: ListTile(
          leading: Icon(
            Icons.logout,
            color: Colors.red,
            size: SizeConfig.safeBlockVertical * coef,
          ),
          title: Text(
            "Quitter l'evenement",
            style: TextStyle(
                color: Colors.red,
                fontSize: SizeConfig.safeBlockVertical * coefText),
          )),
    ),
    FutureBuilder<Map<String, String>>(
        future: getAppInfos(),
        builder: (context, v) {
          if (!v.hasData) {
            return Center();
          } else {
            final data = v.data as Map<String, String>;
            return Center(child: Text("Version " + data["VERSION"]!));
          }
        }),
  ]);
}

Widget blockNormal(BuildContext context) {
  return Column(
    children: [
      ListTile(
          leading: Icon(
            Icons.home,
            color: couleurIcon,
            size: SizeConfig.safeBlockVertical * coef,
          ),
          title: Text(
            Strings.menuAccueil,
            style:
            TextStyle(fontSize: SizeConfig.safeBlockVertical * coefText),
          ),
          onTap: () =>
          {Navigator.pushNamed(context, ParametresMainView.routeName)}),
      itemDispositions(context, coef, coefText, couleurIcon),
      ListTile(
          leading: Icon(
            Icons.list,
            color: couleurIcon,
            size: SizeConfig.safeBlockVertical * coef,
          ),
          title: Text(
            Strings.menuImport,
            style:
            TextStyle(fontSize: SizeConfig.safeBlockVertical * coefText),
          ),
          onTap: () =>
          {Navigator.pushNamed(context, ImportsMainView.routeName)}),
      ListTile(
          leading: Icon(
            Icons.print,
            color: couleurIcon,
            size: SizeConfig.safeBlockVertical * coef,
          ),
          title: Text(
            Strings.menuExport,
            style:
            TextStyle(fontSize: SizeConfig.safeBlockVertical * coefText),
          ),
          */
/* subtitle: Container(
              width: SizeConfig.safeBlockVertical * coef / 5,
              margin: EdgeInsets.only(right: SizeConfig.safeBlockVertical * 18),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(5),
                  border:
                      Border.all(color: couleurJauneMoutardeClair, width: 2.0)),
              child: Text(
                "PREMIUM",
                textAlign: TextAlign.right,
                overflow: TextOverflow.clip,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    fontSize: SizeConfig.safeBlockHorizontal * 3),
              ),
            ),*/ /*

          onTap: () async {
            await context.read<CeremonieProvider>().refreshBilletPdf();

            Navigator.pushNamed(context, ExportsMainView.routeName);
          }),
      SizedBox(height: SizeConfig.safeBlockVertical * coef),
    ],
  );
}

detailsCeremonie(BuildContext context) {
  return Consumer<CeremonieProvider>(builder: (context, provider, child) {
    return Container(
      height: SizeConfig.safeBlockVertical * 18,
      // color: Colors.red,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              child: Text(
                provider.ceremonie!.titreCeremonie.upperDebut(),
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: SizeConfig.safeBlockVertical * 3,
                    fontWeight: FontWeight.bold),
              )),
          Expanded(
              child: Text(
                "@" + provider.ceremonie!.lieuCeremonie.upperDebut(),
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: SizeConfig.safeBlockVertical * 2.5,
                    fontWeight: FontWeight.normal),
              )),
          Expanded(
              child: Text(
                timestampToString(provider.ceremonie!.dateCeremonie, separator: "/")
                    .trim() +
                    " à " +
                    heureToString(provider.ceremonie!.dateCeremonie),
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: SizeConfig.safeBlockVertical * 2.5,
                    fontWeight: FontWeight.normal),
              )),
          SizedBox(
            height: SizeConfig.safeBlockVertical * 2,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      provider.billetsInv.length.toString().upperDebut(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockVertical * 2.5,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " Billets",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockVertical * 2.5,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: SizeConfig.safeBlockHorizontal * 4,
              ),
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      (provider.billetsInv
                          .fold(
                          0,
                              (int prev, billet) =>
                          prev + billet.nbrePersonnes.toInt())
                          .toString())
                          .upperDebut(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockVertical * 2.5,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " invités",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockVertical * 2.5,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  });
}

itemInstallations(
    BuildContext context, dynamic coef, dynamic coefText, Color couleurIcon) {
  return Consumer<CeremonieProvider>(builder: (context, provider, child) {
    int nbreTotal = provider.billetsInv
        .where((billet) => billet.estArrive && !billet.estInstalle)
        .toList()
        .length;

    dynamic texteW;

    if (nbreTotal > 0) {
      texteW = Stack(
        children: <Widget>[
          Text(
            Strings.menuInstalls,
            style: TextStyle(fontSize: SizeConfig.safeBlockVertical * coefText),
          ),
          Positioned(
            right: SizeConfig.safeBlockHorizontal * coefText * 7,
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              constraints: const BoxConstraints(
                minWidth: 18,
                minHeight: 18,
              ),
              child: Center(
                child: Text(
                  (nbreTotal).toString(),
                  style: const TextStyle(
                    color: dWhite,
                    fontSize: 8,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        ],
      );
    } else {
      texteW = Text(
        Strings.menuInstalls,
        style: TextStyle(fontSize: SizeConfig.safeBlockVertical * coefText),
      );
    }

    return ListTile(
        leading: Icon(
          Icons.airline_seat_recline_extra,
          color: couleurIcon,
          size: SizeConfig.safeBlockVertical * coef,
        ),
        title: texteW,
        onTap: () =>
        {Navigator.pushNamed(context, InstallationsMainView.routeName)});
  });
}

itemDispositions(
    BuildContext context, dynamic coef, dynamic coefText, Color couleurIcon) {
  return Consumer<CeremonieProvider>(builder: (context, provider, child) {
    Map<String, int> data = provider.getAlertNbres();
    int nbreTotal = data[Strings.total]!;

    dynamic texteW;

    if (nbreTotal > 0) {
      texteW = Stack(
        children: <Widget>[
          Text(
            Strings.menuDispos,
            style: TextStyle(fontSize: SizeConfig.safeBlockVertical * coefText),
          ),
          Positioned(
            right: SizeConfig.safeBlockHorizontal * coefText * 4,
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              constraints: const BoxConstraints(
                minWidth: 18,
                minHeight: 18,
              ),
              child: Center(
                child: Text(
                  (nbreTotal).toString(),
                  style: const TextStyle(
                    color: dWhite,
                    fontSize: 8,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        ],
      );
    } else {
      texteW = Text(
        Strings.menuDispos,
        style: TextStyle(fontSize: SizeConfig.safeBlockVertical * coefText),
      );
    }

    return ListTile(
        leading: Icon(
          Icons.view_comfortable_sharp,
          color: couleurIcon,
          size: SizeConfig.safeBlockVertical * coef,
        ),
        title: texteW,
        onTap: () => {Navigator.pushNamed(context, Dispositions.routeName)});
  });
}

Widget menuIcon(BuildContext context) {
  return Consumer<CeremonieProvider>(builder: (context, provider, child) {
    Map<String, int> data = provider.getAlertNbres();
    int nbreTotal = data[Strings.total]! +
        provider.billetsInv
            .where((billet) => billet.estArrive && !billet.estInstalle)
            .toList()
            .length;

    if (nbreTotal > 0) {
      return BoutonLeadingWithAlert(
        nbreAlert: nbreTotal,
      );
    } else {
      return BoutonLeading();
    }
  });
}*/
