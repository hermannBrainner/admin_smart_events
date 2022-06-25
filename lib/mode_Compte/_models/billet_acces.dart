import 'dart:io';
import 'dart:typed_data';

import 'package:syncfusion_flutter_pdf/pdf.dart';

import '/mode_Compte/_models/ceremonie.dart';
import '/mode_Compte/_models/prefs.dart';
import '/outils/file_manager.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/strings.dart';
import '../billets_acces/nadia/main.dart';
import '../exports/components/billet_pdf/font_datas.dart';
import 'billet.dart';

class BilletAcces {
  final CeremonieProvider provider;
  final Map<FontNames, Uint8List> fontDatas;

  static const String TYPE_TEMPLATE = "TYPE_TEMPLATE_";

  /// Les valeurs

  static const TITRE = "TITRE";
  static const TEXTE = "TEXTE";

  /// Liste des templates
  static const String TEMPLATE_NADIA = "NADIA";
  static const String TEMPLATE_STEPHANIE = "STEPHANIE";

  static const List<String> allTemplates = [
    TEMPLATE_NADIA, /*TEMPLATE_STEPHANIE*/
  ];

  BilletAcces({required this.provider, required this.fontDatas});

  String nomFichierTemplate(String template) {
    return "template_${template.toLowerCase()}_${provider.ceremonie!.id}${Strings.extensionPdf}";
  }

  setValuesOfTemplate(String template, Map<String, dynamic> dataValues) async {
    dataValues.keys.forEach((key) {
      Prefs.setString(
          key: provider.ceremonie!.id + "_${template}_${key}",
          value: dataValues[key]);
    });
  }

  Future<Map<String, dynamic>> getValuesOfTemplate(String template) async {
    switch (template) {
      case TEMPLATE_NADIA:
        return getNadiaValues;
      case TEMPLATE_STEPHANIE:
        return getStephanieValues;
      default:
        return getNadiaValues;
    }
  }

  Future<Map<String, dynamic>> get getNadiaValues async {
    var data = Map<String, dynamic>();

    data[TITRE] = await Prefs.getString(
        key: provider.ceremonie!.id + "_${TEMPLATE_NADIA}_${TITRE}",
        defaut: provider.ceremonie!.titreCeremonie);

    data[TEXTE] = await Prefs.getString(
        key: provider.ceremonie!.id + "_${TEMPLATE_NADIA}_${TEXTE}",
        defaut:
            "Seraient heureux de vous compter parmi leurs invités à la soirée dansante ");

    return data;
  }

  Future<Map<String, dynamic>> get getStephanieValues async {
    var data = Map<String, dynamic>();

    data[TITRE] = await Prefs.getString(
        key: provider.ceremonie!.id + "_${TEMPLATE_STEPHANIE}_${TITRE}",
        defaut: "Pendaison de Cremaillere");

    data[TEXTE] = await Prefs.getString(
        key: provider.ceremonie!.id + "_${TEMPLATE_STEPHANIE}_${TEXTE}",
        defaut: "Merci de venir ");

    return data;
  }

  set currentTemplate(String template) {
    Prefs.setString(
        key: TYPE_TEMPLATE + provider.ceremonie!.id, value: template);
  }

  Future<String> get getCurrentTemplate async {
    return await Prefs.getString(
        key: TYPE_TEMPLATE + provider.ceremonie!.id, defaut: TEMPLATE_NADIA);
  }

  Future<File> getTemplate({required String template}) async {
    final PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();

    switch (template) {
      case TEMPLATE_NADIA:
        await pageAccesNadia(
            isTemplate: true,
            fontDatas: fontDatas,
            page: page,
            billet: Billet.mock(),
            provider: provider);
        break;
      default:
        break;
    }

    final List<int> bytes = document.save();
    document.dispose();

    return await savePdf(bytes: bytes, chemin: nomFichierTemplate(template));
  }

  Future<File> getFile(
      {required String template,
      required Billet? billet,
      required bool isTemplate}) async {
    billet = billet ?? Billet.mock();

    final PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();

    switch (template) {
      case TEMPLATE_NADIA:
        await pageAccesNadia(
            isTemplate: isTemplate,
            fontDatas: fontDatas,
            page: page,
            billet: billet,
            provider: provider);
        break;
      default:
        break;
    }

    final List<int> bytes = document.save();
    document.dispose();

    String? path;

    if (isTemplate) {
      path = (await localPath()) +
          "/${provider.ceremonie!.firebasePaths()[Ceremonie.billetTemplate]!}";
    } else {
      path = (await localPath()) +
          "/${provider.ceremonie!.id}_${billet.qrCode}_${Strings.extensionPdf}";
    }
    final File file = File(path);
    return await file.writeAsBytes(bytes);
  }
}
