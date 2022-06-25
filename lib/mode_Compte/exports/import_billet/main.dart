import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/mode_Compte/_models/ceremonie.dart';
import '/outils/fonctions/fonctions.dart';
import '/outils/size_configs.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/primary_bouton.dart';
import '/providers/theme/primary_loading_bouton.dart';
import '/providers/theme/strings.dart';
import '../fonctions.dart';
import '../main.dart';
import 'radios_list.dart';
import 'views.dart';

RoundedRectangleBorder commonShape = RoundedRectangleBorder(
  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
);
const Color commonBckgrd = Color.fromRGBO(240, 255, 255, .9);
EdgeInsetsGeometry commonMargin = EdgeInsets.symmetric(
    horizontal: SizeConfig.safeBlockHorizontal * 3,
    vertical: SizeConfig.blockSizeVertical);
EdgeInsetsGeometry commonPadding =
    EdgeInsets.symmetric(vertical: SizeConfig.safeBlockVertical * 1.5);

class ImportBillet extends StatefulWidget {
  final Ceremonie ceremonie;

  const ImportBillet({required this.ceremonie});

  @override
  _ImportBilletState createState() => _ImportBilletState();
}

class _ImportBilletState extends State<ImportBillet> {
  String valueDispo = Ceremonie.modeDefault;
  RoundedLoadingButtonController btCtrl = RoundedLoadingButtonController();

  bool bYaFirstPage = false;

  switchYaFirstPage(bool value) {
    setState(() {
      bYaFirstPage = value;
    });
  }

  @override
  void initState() {
    valueDispo = widget.ceremonie.modePage;
    bYaFirstPage = widget.ceremonie.yaFirstPage;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: commonPadding,
            child: Card(
                shape: commonShape,
                elevation: 3,
                margin: commonMargin,
                child: Container(
                  alignment: Alignment.center,
                  margin:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  height: SizeConfig.safeBlockVertical * 20,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.upload_outlined,
                            color: ThemeElements(context: context)
                                .whichBlue, //   Colors.greenAccent,
                            size: SizeConfig.blockSizeVertical * 5,
                          ),
                          //  adherent.avatar(),
                          SizedBox(width: SizeConfig.blockSizeHorizontal * 5),

                          Expanded(
                            child: Text(
                              Strings.exportUploadDetails,
                              style: ThemeElements(context: context).styleText(
                                  fontSize: SizeConfig.safeBlockVertical * 2,
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.justify,
                              maxLines: 4,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 2,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.blockSizeHorizontal * 10),
                        child: PrimaryButton(
                            rayonBord: SizeConfig.blockSizeVertical * 2,
                            text: Strings.exportUploadBillet,
                            press: () async {
                              File? fichier = await loadBillet(context);
                              context.read<CeremonieProvider>().fichierBillet =
                                  await widget.ceremonie
                                      .saveDebutBillet(context, fichier);
                              await context
                                  .read<CeremonieProvider>()
                                  .refreshBilletPdf(wantTofForce: true);
                              switchYaFirstPage(true);
                              switchYaFirstPage(false);
                              switchYaFirstPage(true);
                            }),
                      )
                    ],
                  ),
                )),
          ),
          Visibility(
            visible: bYaFirstPage,
            child: Padding(
              padding: commonPadding,
              child: Card(
                  shape: commonShape,
                  elevation: 3,
                  margin: commonMargin,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.safeBlockHorizontal * 2,
                        vertical: SizeConfig.safeBlockVertical * 2),
                    height: SizeConfig.safeBlockVertical * 25,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            Strings.exportBilletExistant.toUpperCase(),
                            style: ThemeElements(context: context).styleText(
                                fontSize: SizeConfig.safeBlockVertical * 2,
                                fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.justify,
                            maxLines: 2,
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: SizeConfig.safeBlockHorizontal * 40,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        SizeConfig.blockSizeHorizontal * 2),
                                child: PrimaryButton(
                                    rayonBord: SizeConfig.blockSizeVertical * 2,
                                    text: Strings.voir,
                                    press: () async {
                                      File? file = await context
                                          .read<CeremonieProvider>()
                                          .fichierBillet;

                                      if (!isNullOrEmpty(file)) {
                                        popBillet(
                                            context: context,
                                            onlyLastPage: false,
                                            modePage: Ceremonie.modeLast);
                                      }
                                    }),
                              ),
                            ),
                            Container(
                              width: SizeConfig.safeBlockHorizontal * 50,
                              child: PrimaryLoadingButton(
                                  text: Strings.supprimer,
                                  press: () async {
                                    await widget.ceremonie
                                        .deleteBilletFirstPages();
                                    switchYaFirstPage(false);
                                    btCtrl.stop();
                                  },
                                  btnCtrl: btCtrl),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
            ),
          ),
          Visibility(
              visible: bYaFirstPage,
              child: Padding(
                padding: commonPadding,
                child: Card(
                    //  color: commonBckgrd,
                    shape: commonShape,
                    elevation: 3,
                    margin: commonMargin,
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: SizeConfig.blockSizeHorizontal * 3,
                          vertical: SizeConfig.blockSizeHorizontal * 1.5),
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.blockSizeHorizontal * 0.1,
                          vertical: SizeConfig.blockSizeVertical * 1.9),
                      height: SizeConfig.safeBlockVertical * 60,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(
                              "Utiliser le Billet d'accès par defaut ou mettre le Qr Code sur la dernière page du billet importé",
                              style: ThemeElements(context: context).styleText(
                                  fontSize: SizeConfig.safeBlockVertical * 2,
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.justify,
                              maxLines: 4,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PageViewerTile<String>(
                                value: Ceremonie.modeDefault,
                                groupValue: valueDispo,
                                onChanged: (value) {
                                  setState(() {
                                    valueDispo = value;
                                  });
                                },
                              ),
                              PageViewerTile<String>(
                                value: Ceremonie.modeLast,
                                groupValue: valueDispo,
                                onChanged: (value) {
                                  setState(() {
                                    valueDispo = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          Visibility(
                            visible: widget.ceremonie.modePage != valueDispo,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  fixedSize: Size(
                                      SizeConfig.blockSizeHorizontal * 40, 40),
                                  primary: Colors.green),
                              onPressed: () async {
                                await widget.ceremonie.switchModePage();
                                await context
                                    .read<CeremonieProvider>()
                                    .refreshCeremonie(widget.ceremonie);
                                Navigator.pushNamed(
                                    context, ExportsMainView.routeName);
                              },
                              child: Text(Strings.valider),
                            ),
                          ),
                        ],
                      ),
                    )),
              ))
        ],
      ),
    );
  }
}
