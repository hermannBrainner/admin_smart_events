import 'dart:io';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/mode_Compte/_controllers/billet.dart';
import '/mode_Compte/_controllers/ceremonie.dart';
import '/mode_Compte/_controllers/table.dart';
import '/mode_Compte/_controllers/zone.dart';
import '/mode_Compte/_models/billet.dart';
// ignore: depend_on_referenced_packages
import '/mode_Compte/_models/billet_acces.dart';
import '/mode_Compte/_models/ceremonie.dart';
import '/mode_Compte/_models/identifiants.dart';
import '/mode_Compte/_models/table.dart';
import '/mode_Compte/_models/user_app.dart';
import '/mode_Compte/_models/zone.dart';
import '/mode_Compte/home_compte/pages/ceremonies/ceremonie_tile/values.dart';
import '/outils/file_manager.dart';
import '/outils/fonctions/fonctions.dart';
import '/providers/user_app.dart';
import '../mode_Compte/exports/components/billet_pdf/font_datas.dart';
import 'theme/strings.dart';

class CeremonieProvider with ChangeNotifier {
  Ceremonie? ceremonie;

  late List<TableInvite> tablesInv;

  late List<Zone> zonesSalle;

  File? fichierBillet;
  File? fichierBilletTemplate;

  File? listeTemplateCsv;
  File? listeTemplateXls;

  late List<Billet> billetsInv = [];

  String? urlcouverture;
  Map<FontNames, Uint8List> fontDatas = Map<FontNames, Uint8List>();

  loadCeremonie(String id) async {
    try {
      ceremonie = await CeremonieCtrl.getById(id);

      billetsInv =
          await BilletCtrl.manyById(ceremonie!.idsBillets.cast<String>());

      tablesInv = await TableCtrl.manyById(ceremonie!.idsTables.cast<String>());
      tablesInv.sort(TableInvite.comparator);
      zonesSalle =
          await ZoneCtrl().manyById(ceremonie!.idsZones.cast<String>());

      await saveValues(billets: billetsInv, idCeremonie: ceremonie!.id);
    } catch (e) {}

    notifyListeners();
  }

  refreshOnlyBillets() async {
    billetsInv =
        await BilletCtrl.manyById(ceremonie!.idsBillets.cast<String>());
    notifyListeners();
  }

  refresh(CeremonieProvider provider) async {
    zonesSalle = provider.zonesSalle;
    tablesInv = provider.tablesInv;
    billetsInv = provider.billetsInv;
    ceremonie = provider.ceremonie!;
    provider.billetsInv.sort(Billet.compParent_Nom);

    await saveValues(billets: billetsInv, idCeremonie: ceremonie!.id);
    notifyListeners();
  }

  delBilletPdf() async {
    if (!isNullOrEmpty(fichierBillet)) {
      await fichierBillet!.delete();
    }

    ceremonie!.yaFirstPage = false;
    fichierBillet = null;
    notifyListeners();
  }

  delBilletTemplate() async {
    if (!isNullOrEmpty(fichierBilletTemplate)) {
      await fichierBilletTemplate!.delete();
    }
    fichierBilletTemplate = null;
  }

  reloadBilletTemplate() async {
    if (!isNullOrEmpty(fichierBilletTemplate)) {
      await fichierBilletTemplate!.delete();
    }

    await refreshFontsData();
    fichierBilletTemplate =
        await BilletAcces(provider: this, fontDatas: fontDatas).getFile(
            template: BilletAcces.TEMPLATE_NADIA,
            billet: billetsInv.firstWhereOrNull((el) => true),
            isTemplate: true);

    notifyListeners();
  }

  refreshFontsData() async {
    if (fontDatas.isEmpty) {
      fontDatas[FontNames.millGoudy] = await millGoudyFontData();
      fontDatas[FontNames.rebecca] = await rebeccaFontData();
      fontDatas[FontNames.aphrodite] = await aphroditeFontData();
      notifyListeners();
    }
  }

  refreshCeremonie(Ceremonie c) {
    ceremonie = c;
    notifyListeners();
  }

  refreshTemplateListe() async {
    if (isNullOrEmpty(listeTemplateCsv) || isNullOrEmpty(listeTemplateXls)) {
      var pathXls = "template_import.xlsx";
      var pathCsv = "template_import.csv";
      listeTemplateCsv = await localFile(pathCsv);
      listeTemplateXls = await localFile(pathXls);

      if (!(await listeTemplateCsv!.exists())) {
        listeTemplateCsv = await getFile_web(
            pathWeb: Strings.dossierTemplates + Strings.templateCsv,
            pathLocal: pathCsv);
      }

      if (!(await listeTemplateXls!.exists())) {
        listeTemplateXls = await getFile_web(
            pathWeb: Strings.dossierTemplates + Strings.templateExcel,
            pathLocal: pathXls);
      }
    }
  }

  refreshBilletPdf({bool wantTofForce = false}) async {
    if (isNullOrEmpty(fichierBillet) || wantTofForce) {
      var path = ceremonie!.firebasePaths()[Ceremonie.c_yaFirstPage]!;
      File file = await localFile(path);
      if ((await file.exists())) {
        fichierBillet = file;
        ceremonie!.yaFirstPage = true;
      } else {
        ceremonie!.modePage = Ceremonie.modeDefault;
        fichierBillet = null;
        ceremonie!.yaFirstPage = false;
      }
    } else {
      ceremonie!.yaFirstPage = true;
    }

    if (isNullOrEmpty(fichierBilletTemplate)) {
      await refreshFontsData();
      fichierBilletTemplate =
          await BilletAcces(provider: this, fontDatas: fontDatas).getFile(
              billet: billetsInv.firstWhereOrNull((el) => true),
              isTemplate: true,
              template: BilletAcces.TEMPLATE_NADIA);
    }

    notifyListeners();
  }

  deleteAll(BuildContext context) async {
    await delBilletPdf();
    await delBilletTemplate();

    for (Billet billet in this.billetsInv) {
      await billet.delete();
    }
    for (TableInvite table in this.tablesInv) {
      await table.delete();
    }
    for (Zone zone in this.zonesSalle) {
      await zone.delete();
    }

    IdentifiantEvent? identifiantEvent =
        await IdentifiantEvent.getOne(null, inUserName: ceremonie!.username);
    if (identifiantEvent != null) await identifiantEvent.delete();

    UserApp userApp = context.read<UserAppProvider>().userApp!;
    userApp.idsCeremonies.remove(ceremonie!.id);
    await userApp.save(context);

    await ceremonie!.delete();
  }

  reinitBillets() async {
    for (Billet billet in this.billetsInv) {
      await billet.reinit();
    }
  }

  Map<String, int> getAlertNbres() {
    Map<String, int> data = Map<String, int>();

    data[Strings.dispoZones] = ZoneCtrl.nbreAlert(ceremonie!, zonesSalle);
    data[Strings.dispoTables] = TableCtrl.nbreAlert(ceremonie!, tablesInv);
    data[Strings.dispoBillets] = BilletCtrl.nbreAlert(ceremonie!, billetsInv);
    data[Strings.total] = (data[Strings.dispoZones])!.toInt() +
        (data[Strings.dispoTables])!.toInt() +
        (data[Strings.dispoBillets])!.toInt();

    return data;
  }

  static Zone? getTableParent(
      CeremonieProvider provider, TableInvite tableInvite) {
    if (provider.ceremonie!.withZones && !isNullOrEmpty(tableInvite.idParent)) {
      return provider.zonesSalle
          .firstWhere((z) => z.id == tableInvite.idParent);
    } else {
      return null;
    }
  }

  static List<dynamic>? getParentsForBillets(CeremonieProvider provider) {
    if (provider.ceremonie!.withTables) {
      return provider.tablesInv;
    } else if (provider.ceremonie!.withZones) {
      return provider.zonesSalle;
    } else {
      return null;
    }
  }
}
