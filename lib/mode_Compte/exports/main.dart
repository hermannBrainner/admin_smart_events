import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/auth/drawer/main.dart';
import '/mode_Compte/_models/ceremonie.dart';
import '/outils/widgets/main.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/strings.dart';
import '../_models/billet.dart';
import 'components/print_all/billets.dart';
import 'components/print_all/main.dart';
import 'components/print_all/qr_codes.dart';
import 'import_billet/main.dart';
import 'pages/liste.dart';

class ExportsMainView extends StatefulWidget {
  static const String routeName = "/ExportsMainView";

  @override
  _ExportsMainViewState createState() => _ExportsMainViewState();
}

class _ExportsMainViewState extends State<ExportsMainView> {
  File? fichier;

  bool bStart = false;

  List<Billet> billetsSelected = [];
  double hauteur = 500;

  TYPE_IMPRESSION type_impression = TYPE_IMPRESSION.billet;

  late bool displayLoading;
  late bool displayImportPdf;

  late bool isLoadingFini;

  late double prctgLoading;

  String titrePage = Strings.menuExport;
  String? nomBilletEnCours;
  bool displayCheckBx = false;

  @override
  void initState() {
    super.initState();

    displayLoading = false;
    displayImportPdf = false;
    isLoadingFini = false;
    prctgLoading = 0;
    nomBilletEnCours = null;

    displayCheckBx = false;
  }

  editTitreTab() {
    setState(() {
      if (!displayCheckBx) {
        titrePage = Strings.menuExport;
      } else if (type_impression == TYPE_IMPRESSION.billet) {
        titrePage = "Impression des Billets";
      } else {
        titrePage = "Impression des QrCodes";
      }
    });
  }

  editValeursEncours(
      {required String nom, required double prct, bool isFini = false}) {
    setState(() {
      nomBilletEnCours = nom;
      prctgLoading = prct;
      isLoadingFini = isFini;
    });
  }

  saveFile(File file) {
    setState(() {
      fichier = file;
    });
  }

  refreshList(List<Billet> billets) {
    setState(() {
      billetsSelected = billets;

      bStart = billetsSelected.isNotEmpty;
    });
  }

  switchDisplayCheckBx(bool wantDisplay) {
    setState(() {
      displayCheckBx = wantDisplay;
    });
  }

  switchDisplayImportPdf(bool wantDisplay) {
    setState(() {
      displayImportPdf = wantDisplay;
    });
  }

  switchDisplayLoading(bool wantDisplay) {
    setState(() {
      displayLoading = wantDisplay;
    });
  }

  selectTypePrint(TYPE_IMPRESSION type) {
    // switchDisplayLoading(true);
    setState(() {
      type_impression = type;
    });
    switchDisplayCheckBx(true);
    editTitreTab();
    //  await buildQrCodes (context, provider, editValeursEncours, saveFile ) ;
  }

  startPrint(Ceremonie ceremonie) async {
    switchDisplayLoading(true);

    await context.read<CeremonieProvider>().refreshFontsData();

    switch (type_impression) {
      case TYPE_IMPRESSION.billet:
        await buildAll(billetsSelected, context.read<CeremonieProvider>(),
            editValeursEncours, saveFile);
        break;

      case TYPE_IMPRESSION.qrCode:
        await buildQrCodes(
            billetsSelected, ceremonie, editValeursEncours, saveFile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Consumer<CeremonieProvider>(
      builder: (context, provider, child) {
        return Scaffold(
            drawer: UsefulDrawer(),
            appBar: appBar(
              titrePage,
              context,
            ),
            body: displayLoading
                ? loadingProgress(context, prctgLoading, nomBilletEnCours,
                    isLoadingFini, fichier)
                : displayImportPdf
                    ? ImportBillet(ceremonie: provider.ceremonie!)
                    : listeBillets(
                        bStart,
                        switchDisplayImportPdf,
                        startPrint,
                        selectTypePrint,
                        size,
                        displayCheckBx,
                        refreshList,
                        type_impression,
                        provider: provider));
      },
    );
  }
}
