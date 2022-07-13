import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '/mode_Compte/_models/billet.dart';
import '/mode_Compte/_models/billet_acces.dart';
import '/mode_Compte/billets_acces/edition_template.dart';
import '/mode_Compte/exports/main.dart';
import '/mode_Compte/exports/pages/display_billet.dart';
import '/mode_Compte/imports/main.dart';
import '/mode_Compte/messagerie/main.dart';
import '/mode_Compte/plan_salle/display.dart';
import '/mode_Compte/plan_salle/main.dart';
import '/outils/fonctions/dates.dart';
import '../../../providers/ceremonie.dart';
import 'main.dart';

class Logo extends ThemeElements {
  static const String PLAN_SALLE = "PLAN_SALLE";
  static const String PRINT_BILLET = "PRINT_BILLET";
  static const String EXPORT = "EXPORT";
  static const String IMPORT = "IMPORT";
  static const String MESSAGE = "MESSAGE";
  static const String EDITION_TEMPLATE = "EDITION_TEMPLATE";

  Logo(
      {required this.context,
      this.ACTION_NAME,
      this.billet,
      this.ceremonieProvider})
      : super(context: context);

  final BuildContext context;
  final String? ACTION_NAME;
  late Billet? billet;
  late CeremonieProvider? ceremonieProvider;

  Widget withTexte({required double fontSize}) {
    return Center(
      child: Container(
        height: 200,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: fontSize),
              child: Image.asset(
                provider.themeData.brightness == Brightness.light
                    ? "assets/images/Logo_light.png"
                    : "assets/images/Logo_dark.png",
                height: 120,
              ),
            ),
            Center(
              child: Text.rich(TextSpan(
                  text: 'Smart',
                  style: ThemeElements(context: context).styleText(
                      color: ThemeElements(context: context).whichBlue,
                      fontSize: fontSize),
                  children: <InlineSpan>[
                    TextSpan(
                        text: ' EVENTS',
                        style: ThemeElements(context: context)
                            .styleText(fontSize: fontSize * 1.2))
                  ])),
            ),
          ],
        ),
      ),
    );
  }

  Widget get logo {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: whichBlue,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Stack(
        children: [
          SpinKitFadingCircle(
            color: this.themeColor, // Colors.white,
            size: 80,
          ),
          Positioned(
            left: 10,
            right: 10,
            bottom: 10,
            top: 10,
            child: CircleAvatar(
              maxRadius: 70,
              backgroundColor: whichBlue,
              child: Image.asset(
                provider.themeData.brightness == Brightness.light
                    ? "assets/images/Logo_light.png"
                    : "assets/images/Logo_dark.png",
                height: 120,
              ),
            ),
          ),
        ],
      ),
    );
  }

  show() async {
    late BuildContext dialogContext; // <<----
    showDialog(
      context: context, // <<----
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context;
        return Dialog(
          backgroundColor: whichBlue,
          insetPadding: EdgeInsets.symmetric(
              horizontal: (MediaQuery.of(context).size.width - 80) / 2),
          shape: CircleBorder(),
          child: Container(width: 80, height: 80, child: logo),
        );
      },
    );

    await wait(nbreSeconde: 2);

    if (ACTION_NAME == MESSAGE) {
      Navigator.pushReplacement(dialogContext,
          MaterialPageRoute(builder: (context) => MessagesScreen()));
    } else if (ACTION_NAME == PLAN_SALLE) {
      File pdfPlanSalle = await BuildPlanSalle(dialogContext);
      Navigator.pushReplacement(dialogContext,
          MaterialPageRoute(builder: (context) => ExportsMainView()));
      Navigator.pushReplacement(
          dialogContext,
          MaterialPageRoute(
              builder: (context) => DisplayPdf(
                    fichier: pdfPlanSalle,
                  )));
    } else if (ACTION_NAME == EXPORT) {

    } else if (ACTION_NAME == IMPORT) {
      Navigator.pushReplacement(dialogContext,
          MaterialPageRoute(builder: (context) => ImportsMainView()));
    } else if (ACTION_NAME == PRINT_BILLET) {
      File printFile = await billet!.getBilletAccesPdf(ceremonieProvider!);

      Navigator.pushReplacement(
          dialogContext,
          MaterialPageRoute(
              builder: (context) => DisplayBillet(
                    billet: billet!,
                    fichier: printFile,
                  )));
    } else if (ACTION_NAME == EDITION_TEMPLATE) {
      String templateCurrent = await BilletAcces(
              provider: ceremonieProvider!,
              fontDatas: ceremonieProvider!.fontDatas)
          .getCurrentTemplate;

      Navigator.pushReplacement(
          dialogContext,
          MaterialPageRoute(
              builder: (context) => EditionTemplate(
                    templateCourant: templateCurrent,
                  )));
    }
  }
}
