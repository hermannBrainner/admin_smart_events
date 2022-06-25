import 'package:flutter/material.dart';

import '/outils/constantes/colors.dart';
import '/outils/fonctions/fonctions.dart';
import '/outils/size_configs.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/strings.dart';
import '../../../common.dart';

detailsNewTile(BuildContext context,
    {required Function hintTexts,
    required Function editionDate,
    required Function editHourDebut,
    required Function onChange}) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
        color: dBlack, borderRadius: BorderRadius.all(Radius.circular(10))),
    padding: EdgeInsets.symmetric(
      vertical: 20,
      horizontal: 20,
    ),
    margin: EdgeInsets.symmetric(
      horizontal: SizeConfig.safeBlockHorizontal * 1,
      vertical: SizeConfig.safeBlockVertical * 2,
    ),
    child: Column(
      children: [
        wTritre(Strings.paramsDetails, context),
        getInfoBulle(Strings.paramsDetails, context),
        TextFormField(
            style: ThemeElements(context: context).styleTextFieldTheme,
            maxLines: 1,
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: ThemeElements(context: context).whichBlue,
                        width: 2.0)),
                labelStyle:
                    TextStyle(color: ThemeElements(context: context).whichBlue),
                hintStyle: TextStyle(
                    color:
                        ThemeElements(context: context, mode: ColorMode.envers)
                            .themeColor),
                labelText: "Titre cérémonie",
                hintText: "Quelle est le titre ? ",
                border: OutlineInputBorder()),
            onChanged: (val) {
              onChange(ElementDetails.Titre, val);
            },
            validator: (val) => val!.isEmpty ? "Entrez l'adresse !!" : null),
        SizedBox(height: 10.0),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: editionDate(),
              child: IgnorePointer(
                child: TextFormField(
                  style: ThemeElements(context: context).styleTextFieldTheme,
                  maxLines: 1,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: ThemeElements(context: context).whichBlue,
                              width: 2.0)),
                      labelStyle: TextStyle(
                          color: ThemeElements(context: context).whichBlue),
                      hintStyle: TextStyle(
                          color: ThemeElements(
                                  context: context, mode: ColorMode.envers)
                              .themeColor),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: hintTexts(ElementDetails.Jour),
                      labelText: "Date debut",
                      // helperText: "helper",
                      border: OutlineInputBorder()),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: InkWell(
              onTap: editHourDebut(),
              child: IgnorePointer(
                child: TextFormField(
                  style: ThemeElements(context: context).styleTextFieldTheme,
                  maxLines: 1,

                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: ThemeElements(context: context).whichBlue,
                              width: 2.0)),
                      labelStyle: TextStyle(
                          color: ThemeElements(context: context).whichBlue),
                      hintStyle: TextStyle(
                          color: ThemeElements(
                                  context: context, mode: ColorMode.envers)
                              .themeColor),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: hintTexts(ElementDetails.Heure),
                      labelText: "Heure début",
                      // helperText: "helper",
                      border: OutlineInputBorder()),
                  //  onChanged:(val) => nbreBillets = double.parse(val) , validator: (val) => ! isNumeric(val)  ? "Entrez le nombre de billets" : null
                ),
              ),
            ),
          )
        ]),
        SizedBox(height: 10.0),
        TextFormField(
            style: ThemeElements(context: context).styleTextFieldTheme,
            maxLines: 1,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: ThemeElements(context: context).whichBlue,
                        width: 2.0)),
                labelStyle:
                    TextStyle(color: ThemeElements(context: context).whichBlue),
                hintStyle: TextStyle(
                    color:
                        ThemeElements(context: context, mode: ColorMode.envers)
                            .themeColor),
                labelText: "Nombre de billets",
                border: OutlineInputBorder()),
            onChanged: (val) {
              onChange(ElementDetails.Nbre, val);
            },
            validator: (val) =>
                !isStringNumeric(val!) ? "Entrez le nombre de billets" : null),
        SizedBox(height: 10.0),
        TextFormField(
            style: ThemeElements(context: context).styleTextFieldTheme,
            maxLines: 1,
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: ThemeElements(context: context).whichBlue,
                        width: 2.0)),
                labelStyle:
                    TextStyle(color: ThemeElements(context: context).whichBlue),
                hintStyle: TextStyle(
                    color:
                        ThemeElements(context: context, mode: ColorMode.envers)
                            .themeColor),
                labelText: "Lieu",
                border: OutlineInputBorder()),
            onChanged: (val) => onChange(ElementDetails.Lieu, val),
            validator: (val) =>
                val!.isEmpty ? "Entrez le lieu de la cérémonie" : null),
      ],
    ),
  );
}
