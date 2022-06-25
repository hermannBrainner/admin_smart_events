import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/auth/drawer/main.dart';
import '/mode_Compte/_controllers/ceremonie.dart';
import '/mode_Compte/_models/billet.dart';
import '/mode_Compte/dispositions/main.dart';
import '/outils/constantes/collections.dart';
import '/outils/fonctions/dates.dart';
import '/outils/fonctions/fonctions.dart';
import '/outils/peintures.dart';
import '/outils/size_configs.dart';
import '/outils/widgets/main.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/strings.dart';
import '../home_compte/pages/ceremonies/common.dart';
import '../messagerie/open_button.dart';
import 'components/boutons.dart';
import 'functions/chargement.dart';
import 'functions/validation.dart';

class ImportsMainView extends StatefulWidget {
  static const String routeName = "/ImportsMainView";

  @override
  _ImportsMainViewState createState() => _ImportsMainViewState();
}

class _ImportsMainViewState extends State<ImportsMainView> {
  double hauteur = 500;

  late bool displayLoading, displayAsk, isLoadingFini;
  bool bReplaceAll = false;
  late double prctgLoading;

  String? nomEnChargement;

  late List<List<dynamic>> lignesToLoad;

  @override
  void initState() {
    super.initState();
    displayLoading = false;
    bReplaceAll = false;
    displayAsk = false;

    isLoadingFini = false;
    prctgLoading = 0;
    lignesToLoad = [];
  }

  loadingBillets(CeremonieProvider provider) async {
    List<Billet> allBillets = [];

    setState(() {
      isLoadingFini = false;
    });

    lignesToLoad.removeAt(0);

    List<String> qrCodes = await CeremonieCtrl()
        .initialisationImport(provider, lignesToLoad.length, bReplaceAll);

    for (var ligne in lignesToLoad) {
      setState(() {
        nomEnChargement = ligne[0].toString();
        prctgLoading = 100 * (1 + allBillets.length) / lignesToLoad.length;
      });

      var id = (await getNewID(nomCollectionBillets));

      Billet billet = Billet(
        id: id,
        nom: ligne[0].toString(),
        nbrePersonnes: ligne[1].toInt(),
      );
      allBillets.add(billet);
      billet.qrCode = qrCodes.first;
      qrCodes.remove(billet.qrCode);
      provider.ceremonie!.qrCodesDispo.add(billet.qrCode);
      await CeremonieCtrl.addBillet(provider.ceremonie!, allBillets, billet);

      if (prctgLoading >= 100) {
        await context
            .read<CeremonieProvider>()
            .loadCeremonie(provider.ceremonie!.id);
        await CeremonieCtrl().refreshQrCodes(provider.ceremonie!, allBillets);
        setState(() {
          isLoadingFini = true;
        });

        await wait(nbreSeconde: 3);
        Navigator.pushNamed(context, Dispositions.routeName);
      }
    }
  }

  switchReplace() {
    setState(() {
      bReplaceAll = !bReplaceAll;
    });
  }

  switchDisplayLoading(bool wantDisplay) {
    setState(() {
      displayLoading = wantDisplay;
    });
  }

  switchDisplayAsk(bool wantDisplay) {
    setState(() {
      displayAsk = wantDisplay;
    });
  }

  askLoading(List<List<dynamic>> data) {
    setState(() {
      lignesToLoad = data;
    });

    switchDisplayAsk(true);
  }

  startLoading(bool loadOrNot, CeremonieProvider provider) {
    if (loadOrNot) {
      switchDisplayAsk(false);
      switchDisplayLoading(true);
      loadingBillets(provider);
    } else {
      switchDisplayLoading(false);
      switchDisplayAsk(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: UsefulDrawer(),
        appBar: appBar(
          Strings.menuImport,
          context,
        ),
        body: CustomPaint(
          painter: toileHautetBas(context),
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            //  color: Colors.transparent,
            child: displayAsk
                ? importValidation(
                    bReplaceAll, lignesToLoad.length - 1, startLoading, context)
                : displayLoading
                    ? importChargement(
                        context, prctgLoading, nomEnChargement, isLoadingFini)
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          topBlock(),
                          Expanded(
                              child: SingleChildScrollView(
                            child: Column(
                              children: [
                                btnSwitchReplace(
                                    context, bReplaceAll, switchReplace),
                                SizedBox(
                                  height: SizeConfig.safeBlockVertical * 1,
                                ),
                                btnDownload(context),
                                SizedBox(
                                  height: SizeConfig.safeBlockVertical * 3,
                                ),
                                btnImport(
                                    context, switchDisplayLoading, askLoading),
                                openMessagerie(context),
                              ],
                            ),
                          )),
                          bottomBlock()
                        ],
                      ),
          ),
        ));
  }
}
