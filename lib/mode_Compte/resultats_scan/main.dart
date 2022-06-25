// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/mode_Compte/_models/billet.dart';
import '/mode_Compte/verification/home.dart';
import '/outils/constantes/colors.dart';
import '/outils/fonctions/fonctions.dart';
import '/outils/size_configs.dart';
import '/providers/ceremonie.dart';
import 'widgets.dart';

class ResultatsMainView extends StatefulWidget {
  final String qrCode;

  static const String routeName = "/ResultatsMainView";

  ResultatsMainView({required this.qrCode});

  @override
  _ResultatsMainViewState createState() => _ResultatsMainViewState();
}

class _ResultatsMainViewState extends State<ResultatsMainView> {
  double hauteur = 1000;

  @override
  void initState() {
    super.initState();
  }

  Widget boutonChargement(Color couleur, double hauteur, String contenu) {
    return InkWell(
      onTap: () async {
        //  await majBillets();
      },
      child: Card(
          elevation: hauteur * (8 / 100),
          shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(hauteur / 10)),
          color: couleur,
          margin: new EdgeInsets.symmetric(
              horizontal: hauteur / 10, vertical: hauteur * (6 / 100)),
          child: Container(
            height: hauteur / 2,
            width: hauteur,
            margin: new EdgeInsets.symmetric(horizontal: hauteur / 5),
            child: Center(
                child: Text(
              contenu,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: hauteur / 7,
                  fontWeight: FontWeight.bold),
            )),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: couleurTheme,
        title: Text('Résultat'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.qr_code_scanner,
              size: 30,
              color: dBlack,
            ),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context, VerifMain.routeName, (Route<dynamic> route) => false),
          )
        ],
      ),
      body: Consumer<CeremonieProvider>(builder: (context, provider, child) {
        Billet? billet = provider.billetsInv
            .firstWhereOrNull((b) => b.qrCode == widget.qrCode);
        typeResultat billetType = Billet.resultScan(billet);

        return Center(
          child: Container(
            color: Color.fromRGBO(221, 223, 225, 0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                entete(billetType),
                separateur(),
                if (!isNullOrEmpty(billet))
                  corps(billet, billetType, context, provider),
              ],
            ),
          ),
        );
      }),
    );
  }
}
