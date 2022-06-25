import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/mode_Compte/_models/billet_acces.dart';
import '/providers/ceremonie.dart';
import 'info_tile.dart';

class EditionValeursTemplates extends StatefulWidget {
  final CeremonieProvider provider;
  final String template;
  final Map<String, dynamic> templateValues;

  const EditionValeursTemplates(
      {required this.templateValues,
      required this.template,
      Key? key,
      required this.provider})
      : super(key: key);

  @override
  State<EditionValeursTemplates> createState() =>
      _EditionValeursTemplatesState();
}

RoundedLoadingButtonController btnPosCtrl = RoundedLoadingButtonController();

class _EditionValeursTemplatesState extends State<EditionValeursTemplates> {
  Map<String, dynamic> inTemplateValues = {
    BilletAcces.TITRE: null,
    BilletAcces.TEXTE: null
  };
  Map<String, bool> displayEdit = {
    BilletAcces.TITRE: false,
    BilletAcces.TEXTE: false
  };
  Map<String, TextEditingController> editCtrls = {
    BilletAcces.TITRE: new TextEditingController(text: null),
    BilletAcces.TEXTE: new TextEditingController(text: null)
  };

  switchDisplay(String key) {
    setState(() {
      displayEdit[key] = !(displayEdit[key]!);
    });
  }

  String hintValue(String key) {
    return widget.templateValues[key];
  }

  setValue(String? value, String key) {
    setState(() {
      inTemplateValues[key] = value;
    });
  }

  onValidation(String key) async {
    var values = Map<String, String>();
    editCtrls.keys.forEach((key) {
      values[key] = (editCtrls[key]!.text.isEmpty)
          ? widget.templateValues[key]
          : editCtrls[key]!.text;
    });

    await BilletAcces(
            provider: widget.provider, fontDatas: widget.provider.fontDatas)
        .setValuesOfTemplate(widget.template, values);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          infoTile(
            key: BilletAcces.TITRE,
            context: context,
            onValidation: onValidation,
            displayEdition: (displayEdit[BilletAcces.TITRE]!),
            setValue: setValue,
            switchDisplay: switchDisplay,
            hintValue: hintValue(BilletAcces.TITRE),
            textCtrl: editCtrls[BilletAcces.TITRE]!,
          ),
          infoTile(
            key: BilletAcces.TEXTE,
            hintValue: hintValue(BilletAcces.TEXTE),
            context: context,
            onValidation: onValidation,
            displayEdition: (displayEdit[BilletAcces.TEXTE]!),
            setValue: setValue,
            switchDisplay: switchDisplay,
            textCtrl: editCtrls[BilletAcces.TEXTE]!,
          )
        ],
      ),
    );
  }
}
