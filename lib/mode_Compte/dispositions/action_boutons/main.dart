import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '/outils/fonctions/fonctions.dart';
import '/outils/size_configs.dart';
import '/providers/theme/elements/main.dart';

enum TypeDispo { Zone, Table, Billet }

class BoutonAction extends StatelessWidget {
  final String valueText;
  final bool showBtn;
  final TextEditingController nomCtrl;
  final TextEditingController? nbreCtrl;

  // final double hauteurSheet;
  final BuildContext context;
  final Widget boutonAnnuler;
  final Widget btnValider;
  final String hintTextNom;
  final String? hintTextNbre;
  final int nbreSelected;

  Widget? listChoixParent;
  Widget? colorPicker;

  final TypeDispo typeDispo;

  static const editer = "Editer";
  static const affecter = "affecter";
  static const supprimer = "supprimer";
  static const ajouter = "ajouter";

  static const allItems = [editer, affecter, supprimer, ajouter];

  BoutonAction(
      {required this.typeDispo,
      required this.hintTextNom,
      this.hintTextNbre,
      required this.valueText,
      required this.context,
      required this.showBtn,
      required this.nomCtrl,
      this.nbreCtrl = null,
      required this.btnValider,
      required this.boutonAnnuler,
      required this.nbreSelected,
      this.colorPicker,
      this.listChoixParent});

  /// ELements dépendants du thème

  Color get couleurBouton {
    return (showBtn)
        ? ThemeElements(context: context, mode: ColorMode.endroit).themeColor
        : ThemeElements(context: context, mode: ColorMode.endroit)
            .themeColor
            .withOpacity(0.3);
  }

  Widget question(String string) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal * 5),
      child: Text(
        string,
        style: ThemeElements(context: context).styleText(
            color: ThemeElements(context: context, mode: ColorMode.envers)
                .themeColor,
            decoration: TextDecoration.none,
            fontSize: SizeConfig.safeBlockVertical * 2),
      ),
    );
  }

  Widget wTitre(String string) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal * 5),
      child: Text(
        string,
        style: ThemeElements(context: context).styleText(
            color: ThemeElements(context: context, mode: ColorMode.envers)
                .themeColor,
            decoration: TextDecoration.none,
            fontSize: SizeConfig.safeBlockVertical * 4),
      ),
    );
  }

  Widget wTextfield(String labelText, TextEditingController ctrl,
      {TextInputType inputType = TextInputType.text}) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal * 5),
      child: TextField(
        keyboardType: inputType,
        controller: ctrl,
        style: ThemeElements(context: context).styleText(),
        decoration: InputDecoration(
            labelStyle: ThemeElements(context: context).styleText(
                fontSize: SizeConfig.safeBlockVertical * 2,
                fontWeight: FontWeight.bold),
            labelText: labelText,
            hintText: hintTextNom,
            border: OutlineInputBorder()),
      ),
    );
  }

  Widget wTextfieldNombre(String labelText, TextEditingController ctrl) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal * 5),
      child: TextField(
        keyboardType: TextInputType.phone,
        controller: ctrl,
        style: ThemeElements(context: context).styleText(),
        decoration: InputDecoration(
            labelStyle: ThemeElements(context: context).styleText(
                fontSize: SizeConfig.safeBlockVertical * 2,
                fontWeight: FontWeight.bold),
            labelText: labelText,
            hintText: hintTextNbre ?? "",
            border: OutlineInputBorder()),
      ),
    );
  }

  /// ELements NON dépendants du thème

  Widget get wNberField {
    return wTextfieldNombre("Nombre de personnes", nbreCtrl!);
  }

  String get singulierApres {
    if (typeDispo == TypeDispo.Billet) return "cette table";
    if (typeDispo == TypeDispo.Table)
      return "cette zone";
    else
      return "";
  }

  String get singulier {
    if (typeDispo == TypeDispo.Billet) return "ce billet";
    if (typeDispo == TypeDispo.Table)
      return "cette table";
    else
      return "cette zone";
  }

  String get pluriel {
    if (typeDispo == TypeDispo.Billet) return "ces $nbreSelected invités";
    if (typeDispo == TypeDispo.Table)
      return "ces $nbreSelected tables";
    else
      return "ces $nbreSelected zones";
  }

  Widget get editTextNom {
    write(" nomCtrl.text = ${nomCtrl.text} //// hintTextNom = ${hintTextNom} ",
        "AVANT");
    if (nomCtrl.text.isEmpty) {
      nomCtrl.text = hintTextNom;
    }
    write(" nomCtrl.text = ${nomCtrl.text} //// hintTextNom = ${hintTextNom} ",
        "APRES");
    if (typeDispo == TypeDispo.Billet)
      return wTextfield("Nom invités", nomCtrl);
    else
      return wTextfield("Nom${singulier.replaceAll("cette", "")}", nomCtrl);
  }

  Widget get questionAffectation {
    return question(
        "Choisissez ${singulierApres.replaceAll("cette", "la")} d'affectation, pour les " +
            nbreSelected.toString() +
            " ${singulier}(s) sélectionné(es) ");
  }

  Widget get questionSuppression {
    return question(
        "Etes-vous sur de vouloir retirer ${(nbreSelected == 1) ? singulier : pluriel} ?");
  }

  Widget get textTitreAffeter {
    return wTitre("Affecter");
  }

  Widget get textTitreSuppression {
    return wTitre("Suppresion");
  }

  Widget get textTitreModif {
    return wTitre("Modification");
  }

  Widget get textTitreAjout {
    return wTitre("Ajout");
  }

  Icon get icon {
    switch (valueText.toString()) {
      case editer:
        return Icon(Icons.edit, color: couleurBouton);

      case affecter:
        return Icon(Icons.drive_file_move_outline, color: couleurBouton);

      case supprimer:
        return Icon(Icons.delete_outline, color: couleurBouton);

      default:
        return Icon(Icons.edit, color: couleurBouton);
    }
  }

  Widget get texte {
    return Text(valueText.toString(),
        style: ThemeElements(context: context).styleText(color: couleurBouton));
  }

  Row get boutons {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        btnValider,
        SizedBox(
          width: SizeConfig.safeBlockHorizontal * 5,
        ),
        boutonAnnuler,
      ],
    );
  }

  Widget get sep3 {
    return SizedBox(
      height: SizeConfig.blockSizeVertical * 3,
    );
  }

  Widget? get champs {
    switch (valueText) {
      case ajouter:
      case editer:
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            sep3,

            if (valueText == ajouter) textTitreAjout,
            if (valueText == editer) textTitreModif,
            sep3,
            editTextNom,
            sep3,
            if (typeDispo == TypeDispo.Billet) wNberField,
            if (typeDispo != TypeDispo.Billet) colorPicker!,
            sep3,
            boutons,
            sep3,
            //   Padding()
          ],
        );

      case supprimer:
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            sep3,
            textTitreSuppression,
            sep3,
            questionSuppression,
            sep3,
            boutons,
            sep3,
          ],
        );

      case affecter:
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            sep3,
            textTitreAffeter,
            sep3,
            questionAffectation,
            sep3,
            listChoixParent!,
            sep3,
            boutons,
            sep3,
          ],
        );
    }
  }

  void get sheet {
    showCupertinoModalBottomSheet(
      isDismissible: false,
      expand: false,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                top: SizeConfig.safeBlockVertical * 2,
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: SizeConfig.blockSizeVertical * 60,
              child: Material(child: champs),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (showBtn) {
          sheet;
        }
      },
      child: Column(
        children: [icon, texte],
      ),
    );
  }
}
