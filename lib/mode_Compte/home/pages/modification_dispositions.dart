import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/mode_Compte/_controllers/billet.dart';
import '/mode_Compte/_controllers/table.dart';
import '/mode_Compte/_controllers/zone.dart';
import '/mode_Compte/dispositions/main.dart';
import '/outils/constantes/colors.dart';
import '/outils/size_configs.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/strings.dart';
import '../../messagerie/open_button.dart';
import '../components/dispositions_items.dart';
import '../components/salle_tile.dart';

class PageModifDispositions extends StatefulWidget {
  @override
  _PageModifDispositionsState createState() => _PageModifDispositionsState();
}

class _PageModifDispositionsState extends State<PageModifDispositions> {
  String? valueDispo;

  bool displayChoixDispo = false;

  switchDisplayChoixDispoOn() {
    setState(() {
      displayChoixDispo = !displayChoixDispo;
    });
  }

  goTodisposisitions() {
    Navigator.pushNamed(context, Dispositions.routeName);
  }

  RoundedLoadingButtonController btnPosCtrl = RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Consumer<CeremonieProvider>(builder: (context, provider, child) {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            salleTile(
              context,
              titre: "Dispositions",
              details: provider.ceremonie!.quelleDispo(),
              provider: provider,
              auClick: switchDisplayChoixDispoOn,
              isRed: false,
            ),
            Visibility(
              visible: displayChoixDispo,
              child: Column(
                children: [
                  Strings.dispoMin,
                  Strings.dispoMoyen,
                  Strings.dispoMax
                ].map((dispo) {
                  return ItemDisposition<String>(
                    value: dispo,
                    groupValue: valueDispo ?? provider.ceremonie!.quelleDispo(),
                    onChanged: (value) {
                      setState(() {
                        valueDispo = value;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 2,
            ),
            Visibility(
              visible: !((valueDispo ?? provider.ceremonie!.quelleDispo()) ==
                  provider.ceremonie!.quelleDispo()),
              child: RoundedLoadingButton(
                color: ThemeElements(context: context).whichBlue,
                controller: btnPosCtrl,
                borderRadius: SizeConfig.safeBlockHorizontal * 3,
                successColor: Colors.lightGreenAccent,
                width: SizeConfig.safeBlockHorizontal * 40,
                elevation: SizeConfig.safeBlockHorizontal * 2,
                height: SizeConfig.safeBlockVertical * 7,
                onPressed: () async {
                  await provider.ceremonie!.editDisposAndSave(valueDispo!);
                  await context
                      .read<CeremonieProvider>()
                      .loadCeremonie(provider.ceremonie!.id);

                  setState(() {
                    valueDispo = provider.ceremonie!.quelleDispo();
                    displayChoixDispo = false;
                  });
                },
                child: Text(
                  Strings.valider,
                  style:
                      ThemeElements(context: context).styleText(color: dBlack),
                ),
              ),
            ),
            Visibility(
              visible: provider.ceremonie!.withZones,
              child: salleTile(context,
                  titre: Strings.dispoZones,
                  details: (ZoneCtrl.nbreAlert(
                              provider.ceremonie!, provider.zonesSalle) ==
                          0)
                      ? "${provider.zonesSalle.length} ${Strings.dispoZones} disposées "
                      : "${ZoneCtrl.nbreAlert(provider.ceremonie!, provider.zonesSalle)} ${Strings.dispoZones} non disposées ",
                  provider: provider,
                  auClick: goTodisposisitions,
                  isRed: (ZoneCtrl.nbreAlert(
                          provider.ceremonie!, provider.zonesSalle) !=
                      0)),
            ),
            Visibility(
                visible: provider.ceremonie!.withTables,
                child: salleTile(context,
                    titre: Strings.dispoTables,
                    details: (TableCtrl.nbreAlert(
                                provider.ceremonie!, provider.tablesInv) ==
                            0)
                        ? "${provider.tablesInv.length} ${Strings.dispoTables} disposées "
                        : "${TableCtrl.nbreAlert(provider.ceremonie!, provider.tablesInv)} ${Strings.dispoTables} non disposées ",
                    provider: provider,
                    auClick: goTodisposisitions,
                    isRed: (TableCtrl.nbreAlert(
                            provider.ceremonie!, provider.tablesInv) !=
                        0))),
            salleTile(context,
                titre: Strings.dispoBillets,
                details: (BilletCtrl.nbreAlert(
                            provider.ceremonie!, provider.billetsInv) ==
                        0)
                    ? "${provider.billetsInv.length} ${Strings.dispoBillets} disposés "
                    : "${BilletCtrl.nbreAlert(provider.ceremonie!, provider.billetsInv)} ${Strings.dispoBillets} non disposées ",
                provider: provider,
                auClick: goTodisposisitions,
                isRed: (BilletCtrl.nbreAlert(
                        provider.ceremonie!, provider.billetsInv) !=
                    0)),
            planSalle(context),
            openMessagerie(context),
          ],
        ),
      );
    });
  }
}
