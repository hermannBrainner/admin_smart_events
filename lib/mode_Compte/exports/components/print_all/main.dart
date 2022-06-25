import 'dart:io';

import 'package:flutter/material.dart';

import '/outils/constantes/colors.dart';
import '/outils/fonctions/fonctions.dart';
import '/outils/size_configs.dart';
import '/outils/widgets/main.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/strings.dart';
import '../../pages/liste.dart';
import '../bottom_bar/main.dart';
import 'display.dart';

EdgeInsetsGeometry commonMargin = EdgeInsets.symmetric(
    horizontal: SizeConfig.safeBlockHorizontal * 3,
    vertical: SizeConfig.blockSizeVertical);
EdgeInsetsGeometry commonPadding =
    EdgeInsets.symmetric(vertical: SizeConfig.safeBlockVertical * 1.5);

listeBillets(
    bool bStart,
    Function fctSwitchDisplayImportPdf,
    Function startPrint,
    Function selectTypePrint,
    Size size,
    bool displayCheckBx,
    Function refreshList,
    TYPE_IMPRESSION type_impression,
    {required CeremonieProvider provider}) {
  return Column(
    children: [
      Expanded(
          child: BilletsListe(
        fctRefresh: refreshList,
        isSelection: displayCheckBx,
        type_impression: type_impression,
        provider: provider,
      )),
      BottomBarExports(
        fctSwitchDisplayImportPdf: fctSwitchDisplayImportPdf,
        displayGo: bStart,
        fctStartPrint: startPrint,
        selectTypePrint: selectTypePrint,
        size: size.width,
      ),
    ],
  );
}

loadingProgress(BuildContext context, double prct, String? nomEnCours,
    bool isLoadingFini, File? fichier) {
  isLoadingFini = isNullOrEmpty(isLoadingFini) ? false : isLoadingFini;

  return Container(
    child: Stack(
      children: <Widget>[
        Container(
          alignment: AlignmentDirectional.center,
          decoration: const BoxDecoration(
            color: dWhiteLeger,
          ),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.blue[200],
                borderRadius: BorderRadius.circular(10.0)),
            width: 300.0,
            height: 200.0,
            alignment: AlignmentDirectional.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                (isLoadingFini)
                    ? const Center(
                        child: Icon(
                          Icons.check_circle,
                          size: 80,
                          color: Colors.lightGreenAccent,
                        ),
                      )
                    : Center(
                        child: SizedBox(
                          height: 50.0,
                          width: 50.0,
                          child: getLoadingWidget(
                              context) /* CircularProgressIndicator(
                      value: null,
                      strokeWidth: 7.0,
                    )*/
                          ,
                        ),
                      ),
                Container(
                  child: Center(
                    child: Text(
                      prct >= 100 ? "" : (nomEnCours ?? ""),
                      style: ThemeElements(context: context)
                          .styleText(color: dWhite),
                    ),
                  ),
                ),
                Container(
                  child: Center(
                    child: Text(
                      "${doubleToString(prct)} %",
                      style: ThemeElements(context: context)
                          .styleText(color: dWhite),
                    ),
                  ),
                ),
                Container(
                  child: Center(
                    child: Text(
                      prct == 0
                          ? Strings.initialisation
                          : (isLoadingFini
                              ? ""
                              : (prct >= 100
                                  ? Strings.finalisation
                                  : Strings.chargement)),
                      style: ThemeElements(context: context)
                          .styleText(color: dWhite),
                    ),
                  ),
                ),
                Visibility(
                  visible: isLoadingFini,
                  child: ElevatedButton(
                    child: Text(Strings.voir),
                    onPressed: () {
                      Navigator.pushNamed(context, DisplayReport.routeName,
                          arguments: [fichier]);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
