import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '/mode_Compte/_models/zone.dart';
import '/outils/file_manager.dart';
import '/outils/pdf_tools.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/constantes.dart';
import 'bluids/buildZone.dart';
import 'bluids/build_table.dart';
import 'bluids/page_garde.dart';
import 'models/tableInPage.dart';

void drawBordurePage(PdfPage page) {
  page.graphics.drawRectangle(
      bounds: Rect.fromLTWH(
          0, 0, page.getClientSize().width, page.getClientSize().height),
      pen: PdfPen(pdfColor(kPrimaryColorLightTheme)));
}

Future<File> BuildPlanSalle(BuildContext context) async {
  CeremonieProvider provider = context.read<CeremonieProvider>();

  final PdfDocument document = PdfDocument();

  /// Page de garde

  await pageGarde(document: document, provider: provider);

  /// Les Zonees et leurs tables

  provider.zonesSalle.forEach((zone) {
    PdfPage page = document.pages.add();
    drawBordurePage(page);

    BuildZone(page: page, zone: zone, provider: provider).draw();

    List<TableInPage> allTablesInPage =
        TableInPage(provider: provider).editPages(zone.id);

    if (allTablesInPage.isNotEmpty) {
      for (int indexPage = 1;
          indexPage <=
              allTablesInPage.map((t) => t.idxPage).toList().reduce(max);
          indexPage++) {
        PdfPage page = document.pages.add();
        drawBordurePage(page);

        double offSet = 30;

        allTablesInPage
            .where((t) => t.idxPage == indexPage)
            .toList()
            .forEach((tableInPage) {
          BuildTable(page: page, tableInPage: tableInPage, yStart: offSet)
              .draw();

          offSet = offSet + tableInPage.hauteurTotale;
        });
      }
    }
  });

  /// les tables sans ZONE

  if (provider.tablesInv.where((t) => t.idParent == null).toList().isNotEmpty) {
    Zone zoneMock = Zone(
        id: "na",
        nom: "Sans zone",
        idsEnfants: provider.tablesInv
            .where((t) => t.idParent == null)
            .toList()
            .map((e) => e.id)
            .toList(),
        couleur: kPrimaryColorLightTheme.toString());
    PdfPage page = document.pages.add();
    drawBordurePage(page);

    BuildZone(page: page, zone: zoneMock, provider: provider).draw();

    List<TableInPage> allTablesInPage =
        TableInPage(provider: provider).editPages(null);

    if (allTablesInPage.isNotEmpty) {
      for (int indexPage = 1;
          indexPage <=
              allTablesInPage.map((t) => t.idxPage).toList().reduce(max);
          indexPage++) {
        PdfPage page = document.pages.add();
        drawBordurePage(page);

        double offSet = 30;

        allTablesInPage
            .where((t) => t.idxPage == indexPage)
            .toList()
            .forEach((tableInPage) {
          BuildTable(page: page, tableInPage: tableInPage, yStart: offSet)
              .draw();

          offSet = offSet + tableInPage.hauteurTotale;
        });
      }
    }
  }

  /// FIN ZONE
  final List<int> bytes = document.save();
  document.dispose();

  return await savePdf(bytes: bytes, chemin: "plan_table.pdf");
}
