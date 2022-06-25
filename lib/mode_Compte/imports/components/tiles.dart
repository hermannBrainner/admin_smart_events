import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/mode_Compte/imports/functions/loaders.dart';
import '/outils/constantes/colors.dart';
import '/outils/file_manager.dart';
import '/outils/fonctions/fonctions.dart';
import '/outils/size_configs.dart';
import '/outils/widgets/main.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/strings.dart';

tileImpt(Function startLoading, BuildContext context, bool cleanAll,
    {required String extension}) {
  return ListTile(
    leading: icone(context, extension),
    title: ElevatedButton(
        style: ElevatedButton.styleFrom(
            fixedSize: Size(SizeConfig.blockSizeHorizontal * 80,
                SizeConfig.safeBlockVertical * 7),
            primary: dWhite),
        onPressed: () async {
          List<List<dynamic>> dataRetour = await loadFile(extension, context);
          if (dataRetour.isEmpty) {
          } else {
            Navigator.of(context).pop();
            startLoading(dataRetour);
          }
        },
        child: Text(
          ((extension == Strings.extensionXls)
              ? "Fichier Excel (.xls, .xlsx)"
              : "Fichier Csv (comma separated)"),
          style: ThemeElements(context: context).styleText(color: Colors.black),
        )),
  );
}

///Download

tileDwld(BuildContext context, String extension) {
  return ListTile(
    leading: icone(context, extension),
    title: ElevatedButton(
        style: ElevatedButton.styleFrom(
            fixedSize: Size(SizeConfig.blockSizeHorizontal * 80,
                SizeConfig.safeBlockVertical * 7),
            primary: dWhite),
        onPressed: () async {
          await context.read<CeremonieProvider>().refreshTemplateListe();

          File? fileTemplate = (extension == Strings.extensionXls)
              ? context.read<CeremonieProvider>().listeTemplateXls
              : context.read<CeremonieProvider>().listeTemplateCsv;

          if (!isNullOrEmpty(fileTemplate)) {
            await urlFileShare(context, fileTemplate!);
            Navigator.of(context).pop();
          } else {
            showFlushbar(context, false, "",
                "Template non disponible. Veuillez réessayer ulterieurement");
            Navigator.of(context).pop();
          }
        },
        child: Text(
          ((extension == Strings.extensionXls)
              ? "Fichier Excel (.xls, .xlsx)"
              : "Fichier Csv (comma separated)"),
          style: ThemeElements(context: context).styleText(color: Colors.black),
        )),
  );
}

icone(context, String string) {
  return Container(
    width: SizeConfig.safeBlockHorizontal * 10,
    //  margin: EdgeInsets.only(right:SizeConfig.safeBlockVertical * 18 ),
    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
    decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: couleurJauneMoutardeClair, width: 2.0)),
    child: Text(
      string,
      textAlign: TextAlign.center,
      // overflow: TextOverflow.clip,
      style: ThemeElements(context: context).styleText(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none,
          fontSize: SizeConfig.safeBlockHorizontal * 3),
    ),
  );
}
