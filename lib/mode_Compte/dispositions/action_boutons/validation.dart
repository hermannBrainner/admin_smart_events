import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/mode_Compte/dispositions/action_boutons/main.dart';
import '/outils/size_configs.dart';
import '/providers/theme/strings.dart';

class BoutonActionValidation {
  final Function cleanAllCtrl;

  final BuildContext context;
  final TypeDispo dispo;

  final RoundedLoadingButtonController btnPosCtrl;

  BoutonActionValidation(
      {required this.btnPosCtrl,
      required this.dispo,
      required this.context,
      required this.cleanAllCtrl});

  /*Widget   validerZone (String typeAction, Color colorSelected, List<Zone> zonesSelect ,Function addOrRemoveInListe, nomCtrl  ) {

    return Consumer<CeremonieProvider>(builder: (context, provider, child) {
      return RoundedLoadingButton(
          child: Text(Strings.confirm),
          color: Colors.green,
          controller: btnPosCtrl,
          borderRadius: SizeConfig.safeBlockHorizontal * 3,
          successColor: Colors.lightGreenAccent,
          width: SizeConfig.safeBlockHorizontal * 40,
          elevation: SizeConfig.safeBlockHorizontal * 2,
          height: SizeConfig.safeBlockVertical * 7,
          onPressed: () async {
            btnPosCtrl.start();
            String? msgError;
            String titre = "ERREUR CREATION";

            if (typeAction == BoutonAction.editer) {
              await editerZone(
                  provider: provider,
                  colorSelected: colorSelected,
                  nomCtrl: nomCtrl,
                  zone: zonesSelect.first);
            } else if (typeAction == BoutonAction.supprimer) {
              await deleteZone(
                  provider: provider,
                  zones: zonesSelect,
                  removeInListe: addOrRemoveInListe );
            } else if (typeAction == BoutonAction.ajouter) {

              await ajouterZone(
                  provider: provider,
                  nomCtrl: nomCtrl,
                  colorSelected: colorSelected,
                  addNewInListe: addOrRemoveInListe );


            }
            context.read<CeremonieProvider>().refresh(provider);
            cleanAllCtrl();
            btnPosCtrl.stop();
            Navigator.pop(context);
            if (!isNullOrEmpty(msgError)) {
              showFlushbar(context, false, titre, msgError!);
            }
          });
    }
    );

  }
*/

  Widget get annuler {
    return RoundedLoadingButton(
      controller: RoundedLoadingButtonController(),
      borderRadius: SizeConfig.safeBlockHorizontal * 3,
      successColor: Colors.lightGreenAccent,
      width: SizeConfig.safeBlockHorizontal * 40,
      elevation: SizeConfig.safeBlockHorizontal * 2,
      height: SizeConfig.safeBlockVertical * 7,
      onPressed: () {
        cleanAllCtrl();

        Navigator.pop(context);
      },
      child: Text(Strings.cancel),
      color: Colors.redAccent,
    );
  }
}
